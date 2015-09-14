local FORCE_DEBUG = false;
local Debug = LunaEclipseScripts.Debug;

if not LunaEclipseScripts:isRequiredVersion(10, 0, 0) then
    local Ovale = LunaEclipseScripts.Ovale;

    --<private-static-properties>
    local OvaleEnemies = Ovale.OvaleEnemies;

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

    -- Player's GUID.
    local playerGUID = nil;

    -- targets[GUID] = timestamp;
    local targets = {};
    -- myTargets[GUID] = timestamp;
    -- GUIDs used as keys for this table are a subset of the GUIDs used for targets.
    local myTargets = {};

    -- Timer for reaper function to remove inactive enemies.
    local reaperTimer = nil;
    local REAP_INTERVAL = 3;

    -- Events
    -- Table of CLEU events for when a unit is removed from combat.
    local CLEU_UNIT_REMOVED = {
        UNIT_DESTROYED = true,
        UNIT_DIED = true,
        UNIT_DISSIPATES = true,
    };

    --[[
        List of CLEU event suffixes that can correspond to the player damaging or try to
        damage (tag) an enemy, or vice versa.
    ]]
    local CLEU_TAG_SUFFIXES = {
        "_CAST_START",
        "_DAMAGE",
        "_MISSED",
        "_DRAIN",
        "_LEECH",
        "_INTERRUPT",
        "_DISPEL",
        "_DISPEL_FAILED",
        "_STOLEN",
        "_AURA_APPLIED",
        "_AURA_APPLIED_DOSE",
        "_AURA_REFRESH",
    };
    --</private-static-properties>

    --<public-static-properties>
    -- Total number of active enemies.
    OvaleEnemies.activeEnemies = 0;
    -- Total number of tagged enemies.
    OvaleEnemies.taggedEnemies = 0;
    --</public-static-properties>

    --<private-static-methods>
    local function wipeData()
        targets = {};
        OvaleEnemies.activeEnemies = 0;

        myTargets = {};
        OvaleEnemies.taggedEnemies = 0;
    end

    -- Functions to check Unit Info
    local function isPlayer(unitFlags)
        return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
    end

    local function isGroupMember(unitFlags)
        return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0
            or bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0 
            or bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0;
    end

    local function isEnemy(unitFlags)
        return bit.band(unitFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0;
    end

    local function isValid(GUID, unitName, unitFlags)
        return (GUID and GUID ~= "") 
           and unitName ~= nil
           and (bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0
                or bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
                or bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0);
    end

    local function getUnitInfo(GUID, unitName, unitFlags)
    return isPlayer(unitFlags), isGroupMember(unitFlags), isEnemy(unitFlags), isValid(GUID, unitName, unitFlags);
    end

    -- Functions to check events
    local function isTagEvent(combatEvent)
        local returnValue = false;

        for _, eventSuffix in ipairs(CLEU_TAG_SUFFIXES) do
            if string.find(combatEvent, eventSuffix .. "$") then
                returnValue = true;
            end
        end

        return returnValue;
    end

    local function isValidEvent(combatEvent, sourceIsGroupMember, destIsGroupMember)
        return (sourceIsGroupMember or destIsGroupMember)
           and isTagEvent(combatEvent)
           and (sourceIsGroupMember
                or (not sourceIsGroupMember and combatEvent ~= "SPELL_PERIODIC_DAMAGE"));
    end
    --</private-static-methods>

    --<public-static-methods>
    function OvaleEnemies:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags = ...;
        local currentTime = GetTime();

        local sourceIsPlayer, sourceIsGroupMember, sourceIsEnemy, sourceIsValid = getUnitInfo(sourceGUID, sourceName, sourceFlags);
        local destIsPlayer, destIsGroupMember, destIsEnemy, destIsValid = getUnitInfo(destGUID, destName, destFlags);

        if CLEU_UNIT_REMOVED[combatEvent] then
            self:RemoveEnemy(destGUID);
        elseif isValidEvent(combatEvent, sourceIsGroupMember, destIsGroupMember) then
            if sourceIsGroupMember and destIsValid and destIsEnemy then
                self:AddEnemy(destGUID, currentTime, sourceIsPlayer);
            elseif destIsGroupMember and sourceIsValid and sourceIsEnemy then
                self:AddEnemy(sourceGUID, currentTime);
            end
        end
    end

    function OvaleEnemies:PLAYER_REGEN_DISABLED()
        -- Reset enemy tracking when combat starts.
        wipeData();
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    end

    function OvaleEnemies:PLAYER_REGEN_ENABLED()
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    end

    function OvaleEnemies:AddEnemy(GUID, timeStamp, playerTarget)
        if not targets[GUID] then
            self.activeEnemies = self.activeEnemies + 1;
            targets[GUID] = timeStamp;
            Ovale.refreshNeeded[playerGUID] = true;
        else
            targets[GUID] = timeStamp;
        end

        if playerTarget then
            if not myTargets[GUID] then
                self.taggedEnemies = self.taggedEnemies + 1;
                myTargets[GUID] = timeStamp;
                Ovale.refreshNeeded[playerGUID] = true;
            else
                myTargets[GUID] = timeStamp;
            end
        end 
    end

    function OvaleEnemies:RemoveEnemy(GUID, deathEvent)
        local refreshNeeded = false;
        local unitDied = deathEvent and (deathEvent == true);

        if targets[GUID] ~= nil then
            self.activeEnemies = max(0, self.activeEnemies - 1);
            targets[GUID] = nil;
            refreshNeeded = true;
        end

        if myTargets[GUID] ~= nil then
            self.taggedEnemies = max(0, self.taggedEnemies - 1);
            myTargets[GUID] = nil;
            refreshNeeded = true;
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
    function OvaleEnemies:RemoveInactiveEnemies()
        local currentTime = GetTime();

        for GUID, timeStamp in pairs(targets) do
            if currentTime - timeStamp > REAP_INTERVAL then
                self:RemoveEnemy(GUID);
            end
        end
    end

    function OvaleEnemies:DebugEnemies()
        for GUID, lastSeen in pairs(targets) do
            local taggedTarget = myTargets[GUID];

            if taggedTarget then
                self:Print("Tagged enemy %s last seen at %f", GUID, taggedTarget);
            else
                self:Print("Enemy %s last seen at %f", GUID, lastSeen);
            end
        end

        self:Print("Total enemies: %d", self.activeEnemies);
        self:Print("Total tagged enemies: %d", self.taggedEnemies);
    end

    function OvaleEnemies:OnEnable()
        playerGUID = Ovale.playerGUID;
		
        if not reaperTimer then
            reaperTimer = self:ScheduleRepeatingTimer("RemoveInactiveEnemies", REAP_INTERVAL);
        end

        self:RegisterEvent("PLAYER_REGEN_ENABLED");
        self:RegisterEvent("PLAYER_REGEN_DISABLED");
        OvaleState:RegisterState(self, self.statePrototype);
    end

    function OvaleEnemies:OnDisable()
        OvaleState:UnregisterState(self);

        if reaperTimer then
            self:CancelTimer(reaperTimer);
            reaperTimer = nil;
        end

        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");
        self:UnregisterEvent("PLAYER_REGEN_DISABLED");
    end
    --</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]

    --<public-static-properties>
    OvaleEnemies.statePrototype = {}
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = OvaleEnemies.statePrototype;
    --</private-static-properties>

    --<state-properties>
    -- Total number of active enemies.
    statePrototype.activeEnemies = nil;
    -- Total number of tagged enemies.
    statePrototype.taggedEnemies = nil;
    -- Requested number of enemies.
    statePrototype.enemies = nil;
    --</state-properties>

    --<public-static-methods>
    -- Initialize the state.
    function OvaleEnemies:InitializeState(state)
        state.enemies = nil;
    end

    -- Reset the state to the current conditions.
    function OvaleEnemies:ResetState(state)
        state.activeEnemies = self.activeEnemies;
        state.taggedEnemies = self.taggedEnemies;
    end

    -- Release state resources prior to removing from the simulator.
    function OvaleEnemies:CleanState(state)
        state.activeEnemies = nil;
        state.taggedEnemies = nil;
        state.enemies = nil;
    end
    --</public-static-methods>
end