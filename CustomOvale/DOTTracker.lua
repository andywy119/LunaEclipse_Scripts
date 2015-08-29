local FORCE_DEBUG = false;
local Debug = LunaEclipseScripts.Debug;

local Ovale = LunaEclipseScripts.Ovale;

local moduleName = "DOTTracker";
local DOTTracker = LunaEclipseScripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");
Ovale.DOTTracker = DOTTracker;

-- Death Knight SpellID's
local AURA_BLOOD_PLAGUE = 55078;
local AURA_FROST_FEVER = 55095;
local AURA_NECROTIC_PLAGUE = 155159;

-- Hunter SpellID's
local AURA_SERPENT_STING = 118253;

-- Player's GUID.
local playerGUID = nil;

-- SpellIDs to track
local CLEU_TRACK_SPELLID = {
	[AURA_BLOOD_PLAGUE] = true,
	[AURA_FROST_FEVER] = true,
	[AURA_NECROTIC_PLAGUE] = true,
	[AURA_SERPENT_STING] = true,
};

-- Table to store GUIDs affected by the tracked spells
local tableList = {};

-- Table to store the count of the targets affected by the tracked spells
local auraTargetCount = {};

-- Events
-- Table of CLEU events for when a unit is removed from combat
local CLEU_UNIT_REMOVED = {
	UNIT_DESTROYED = true,
	UNIT_DIED = true,
	UNIT_DISSIPATES = true,
};

-- List of CLEU events for applying auras
local CLEU_DOT_ADDED = {
	SPELL_AURA_APPLIED = true,
	SPELL_AURA_REFRESH = true,
	SPELL_AURA_APPLIED_DOSE = true,
	SPELL_CAST_SUCCESS = true,
};

-- List of CLEU events for aura ticks
local CLEU_DOT_DAMAGE = {
	SPELL_PERIODIC_DAMAGE = true,
	SPELL_PERIODIC_MISSED = true,
	SPELL_DAMAGE = true,
};

-- List of CLEU events for removing auras
local CLEU_DOT_REMOVED = {
	SPELL_AURA_REMOVED = true,
	SPELL_AURA_BROKEN = true,
	SPELL_AURA_BROKEN_SPELL = true,
};

-- Timer for reaper function to remove inactive enemies.
local reaperTimer = nil;
local REAP_INTERVAL = 3;
--</private-static-properties>

--<private-static-methods>
local function wipeData()
	for spellID, value in pairs(CLEU_TRACK_SPELLID) do
		tableList[spellID] = {};
		auraTargetCount[spellID] = 0;
	end
end

-- Functions to check Unit Info
local function isPlayer(unitFlags)
	local returnValue = false;
	
	if bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 then
		returnValue = true;
	end
	
	return returnValue;
end
--</private-static-methods>

--<public-static-methods>
function DOTTracker:OnInitialize()
	-- This function can be used to setup the tables as well as wiping them.
	wipeData();
end

function DOTTracker:OnEnable()
	playerGUID = Ovale.playerGUID;

	if not reaperTimer then
		reaperTimer = self:ScheduleRepeatingTimer("RemoveInactiveEnemies", REAP_INTERVAL);
	end
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
end

function DOTTracker:OnDisable()
	if reaperTimer then
		self:CancelTimer(reaperTimer);
		reaperTimer = nil;
	end
	
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:UnregisterEvent("PLAYER_REGEN_DISABLED");
end

function DOTTracker:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
	local currentTime = GetTime();
	local sourceIsPlayer = isPlayer(sourceFlags);
	
	if CLEU_UNIT_REMOVED[combatEvent] then
		self:RemoveEnemy(destGUID);
	elseif sourceIsPlayer and CLEU_TRACK_SPELLID[spellID] then
		if CLEU_DOT_ADDED[combatEvent] or CLEU_DOT_DAMAGE[combatEvent] then
			self:AddEnemy(destGUID, spellID, currentTime);
		elseif CLEU_DOT_REMOVED[combatEvent] then
			self:RemoveEnemy(destGUID, spellID);
		end
	end
end

function DOTTracker:PLAYER_REGEN_DISABLED()
	-- Reset enemy tracking when combat starts.
	wipeData();
end

function DOTTracker:AddEnemy(GUID, spellID, timeStamp)
	if spellID then
		local tableUpdate = tableList[spellID];
	    	
	    	if tableUpdate then
			if not tableUpdate[GUID] then
				auraTargetCount[spellID] = auraTargetCount[spellID] + 1;			
				tableUpdate[GUID] = timeStamp;
				tableList[spellID] = tableUpdate;
				Ovale.refreshNeeded[playerGUID] = true;
			else
				tableUpdate[GUID] = timeStamp;
				tableList[spellID] = tableUpdate;
			end
		end
	end
end

function DOTTracker:RemoveEnemy(GUID, spellID)
	local refreshNeeded = false;
	local unitDied = not spellID;

	if not spellID then
		for spellID, tableUpdate in pairs(tableList) do
			if tableUpdate[GUID] ~= nil then
				auraTargetCount[spellID] = max(0, auraTargetCount[spellID] - 1);			
				tableUpdate[GUID] = nil;
				tableList[spellID] = tableUpdate;
				refreshNeeded = true;
			end
		end
	else
		local tableUpdate = tableList[spellID];
	    	
	    	if tableUpdate then
			if tableUpdate[GUID] ~= nil then
				auraTargetCount[spellID] = max(0, auraTargetCount[spellID] - 1);			
				tableUpdate[GUID] = nil;
				tableList[spellID] = tableUpdate;
				refreshNeeded = true;
			end
		end
	end

	if refreshNeeded then
		Ovale.refreshNeeded[playerGUID] = true;
		self:SendMessage("Ovale_InactiveUnit", GUID, unitDied);
	end
end

--[[
	Remove enemies that have been inactive for at least REAP_INTERVAL seconds.
	These enemies are not in combat with your group, out of range, or
	incapacitated and shouldn't count toward the number of active enemies.
]]
function DOTTracker:RemoveInactiveEnemies()
	local currentTime = GetTime();

	for spellID, tableUpdate in pairs(tableList) do
		for GUID, timeStamp in pairs(tableUpdate) do
			if currentTime - timeStamp > REAP_INTERVAL then
				self:RemoveEnemy(GUID, spellID);
			end
		end
	end
end

-- This returns the count for the SpellID passed to it
function DOTTracker:TargetCount(spellID)
	if spellID and CLEU_TRACK_SPELLID[spellID] then
		return auraTargetCount[spellID];
	else
		return;
	end
end
--</public-static-methods>