local FORCE_DEBUG = false;
local Debug = LunaEclipseScripts.Debug;

local Ovale = LunaEclipseScripts.Ovale;
local OvaleEnemies = Ovale.OvaleEnemies;
local DOTTracker = Ovale.DOTTracker;

local OvaleCondition = Ovale.OvaleCondition;
local Compare = OvaleCondition.Compare;
local TestBoolean = OvaleCondition.TestBoolean;
local TestValue = OvaleCondition.TestValue;

do
	local function DOTTargetCount(positionalParams, namedParams, state, atTime)
		local auraID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
		local value = DOTTracker:TargetCount(auraID);

		if not value then
			value = 0;
		end

		return Compare(value, comparator, limit);
	end

	OvaleCondition:RegisterCondition("dottargetcount", false, DOTTargetCount);
end

do
	local function Enemies(positionalParams, namedParams, state, atTime)
		local comparator, limit = positionalParams[1], positionalParams[2];
		local value = state.enemies;
		
		if not value then
			-- Use the profile's tagged enemies option or "opt_enemies_tagged" checkbox value as the default.
			local useTagged = Ovale.db.profile.apparence.taggedEnemies or Ovale:IsChecked("opt_enemies_tagged");
			
			-- Override the default if "tagged" is explicitly given.
			if namedParams.tagged == 0 then
				useTagged = false;
			elseif namedParams.tagged == 1 then
				useTagged = true;
			end
			
			value = (useTagged and state.taggedEnemies) or state.activeEnemies;
		end
		
		-- This ensures scripts have a value if not in combat or if in combat but nothing has been attacked.
		if value < 1 then
			value = 1;
		end
		
		return Compare(value, comparator, limit);
	end

	OvaleCondition:RegisterCondition("enemies", false, Enemies);
end

do
	local function PotionCombatLockdown(positionalParams, namedParams, state, atTime)
		local itemID = positionalParams[1];
		local returnValue = false;
		
		if itemID and type(itemID) ~= "number" then
			itemID = OvaleEquipment:GetEquippedItem(itemID);
		end
		
		if itemID then
			local _, _, enable = GetItemCooldown(itemID);
			
			if enable and enable == 0 then
				returnValue = true;
			else
				returnValue = false;
			end
		end

		return TestBoolean(returnValue);
	end

	OvaleCondition:RegisterCondition("potioncombatlockdown", false, PotionCombatLockdown);
end