local FORCE_DEBUG = false;
local Debug = LunaEclipseScripts.Debug;

local Ovale = LunaEclipseScripts.Ovale;
local OvaleEnemies = Ovale.OvaleEnemies;
local DOTTracker = Ovale.DOTTracker;
local OvaleData = Ovale.OvaleData;
local OvaleHealth = Ovale.OvaleHealth;

local OvaleCondition = Ovale.OvaleCondition;
local Compare = OvaleCondition.Compare;
local ParseCondition = OvaleCondition.ParseCondition;
local TestBoolean = OvaleCondition.TestBoolean;
local TestValue = OvaleCondition.TestValue;

do
    --- Get the number of targets affected by a tracked DOT.
    -- @name DOTTargetCount
    -- @paramsig number or boolean
    -- @param auraID - The aura spell ID.
    -- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
    -- @param number Optional. The number to compare against.
    -- @return The count of the targets affected by the DOT.
    -- @return A boolean value for the result of the comparison.
    local function DOTTargetCount(positionalParams, namedParams, state, atTime)
        local auraID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
        local returnValue = DOTTracker:TargetCount(auraID);

        if not returnValue then
            returnValue = 0;
        end

        return Compare(returnValue, comparator, limit);
    end

    OvaleCondition:RegisterCondition("dottargetcount", false, DOTTargetCount);
end

do
    --- Get the number of hostile enemies on the battlefield.
    -- The minimum value returned is 1.
    -- @name Enemies
    -- @paramsig number or boolean
    -- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
    -- @param number Optional. The number to compare against.
    -- @param tagged Optional. By default, all enemies are counted. To count only enemies directly tagged by the player, set tagged=1.
    --     Defaults to tagged=0.
    --     Valid values: 0, 1.
    -- @return The number of enemies.
    -- @return A boolean value for the result of the comparison.
    local function Enemies(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2];
        local returnValue = state.enemies;
		
        if not returnValue then
            -- Use the profile's tagged enemies option or "opt_enemies_tagged" checkbox value as the default.
            local useTagged = Ovale.db.profile.apparence.taggedEnemies or Ovale:IsChecked("opt_enemies_tagged");
			
            -- Override the default if "tagged" is explicitly given.
            if namedParams.tagged == 0 then
                useTagged = false;
            elseif namedParams.tagged == 1 then
                useTagged = true;
            end
			
            returnValue = (useTagged and state.taggedEnemies) or state.activeEnemies;
        end
		
        -- This ensures scripts have a value if not in combat or if in combat but nothing has been attacked.
        if returnValue < 1 then
            returnValue = 1;
        end
		
        return Compare(returnValue, comparator, limit);
    end

    OvaleCondition:RegisterCondition("enemies", false, Enemies);
end

do
    --- Returns whether an aura has less then 30% time left, accounting for travel time.
    -- @name InPandemicRange
    -- @paramsig number or boolean
    -- @param auraID The aura spell ID.
    -- @param spellID Optional. The base spell ID to calculate travel time.
    --     Travel time defaults to 0 seconds if no spell is specified.
	-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
	--     Defaults to target=player.
	--     Valid values: player, target, focus, pet.
    -- @return A boolean value based on if the aura has less then 30% time remaining.
    local function InPandemicRange(positionalParams, namedParams, state, atTime)
        local auraID, spellID = positionalParams[1], positionalParams[2];
 		local target, filter, mine = ParseCondition(positionalParams, namedParams, state);
        local spellInfo = spellID and OvaleData.spellInfo[spellID];
        local auraInfo = state:GetAura(target, auraID, filter, mine);
        local returnValue = false;
        
        if auraInfo then
            local auraGain, auraStart, auraEnding = auraInfo.gain, auraInfo.start, auraInfo.ending;
            local baseDuration = OvaleData:GetBaseDuration(auraID, state);
            local travelTime = (spellInfo and (spellInfo.travel_time or spellInfo.max_travel_time)) or 0;

            travelTime = ((travelTime > 0 and travelTime < 1) and 1) or travelTime;           
            returnValue = GetTime() >= auraEnding - (baseDuration * 0.3) - travelTime and GetTime() <= auraEnding;
        end
		
        return TestBoolean(returnValue);
    end

    OvaleCondition:RegisterCondition("inpandemicrange", false, InPandemicRange);
end

do
    --- Get the number of seconds before the aura reaches pandemic range.
    -- @name TimeToPandemicRange
    -- @paramsig number or boolean
    -- @param auraID The aura spell ID.
    -- @param spellID The base spell ID.
    -- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
    -- @param number Optional. The number to compare against.
	-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
	--     Defaults to target=player.
	--     Valid values: player, target, focus, pet.
    -- @param base Optional. By default, will use the time remaining on the current debuff. To estimate how long to pandemic if you were to apply now set base=1.
    --     Defaults to base=0.
    --     Valid values: 0, 1.
	-- @return The number of seconds.
    -- @return A boolean value for the result of the comparison.
    local function TimeToPandemicRange(positionalParams, namedParams, state, atTime)
        local auraID, spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3], positionalParams[4];
 		local target, filter, mine = ParseCondition(positionalParams, namedParams, state);
        local spellInfo = spellID and OvaleData.spellInfo[spellID];
        local auraInfo = state:GetAura(target, auraID, filter, mine);
        local returnValue = 0;
        
        if namedParams.base == 1 and auraID then
            local baseDuration = OvaleData:GetBaseDuration(auraID, state);
            local travelTime = (spellInfo and (spellInfo.travel_time or spellInfo.max_travel_time)) or 0;

            travelTime = ((travelTime > 0 and travelTime < 1) and 1) or travelTime;           
            returnValue = baseDuration - (baseDuration * 0.3) - travelTime;            
        elseif auraInfo then
            local auraGain, auraStart, auraEnding = auraInfo.gain, auraInfo.start, auraInfo.ending;
            local baseDuration = OvaleData:GetBaseDuration(auraID, state);
            local travelTime = (spellInfo and (spellInfo.travel_time or spellInfo.max_travel_time)) or 0;

            travelTime = ((travelTime > 0 and travelTime < 1) and 1) or travelTime;           
            returnValue = auraEnding - (baseDuration * 0.3) - travelTime - GetTime();
        end
		
        if returnValue < 0 then
            returnValue = 0;
        end

        return Compare(returnValue, comparator, limit);
    end

    OvaleCondition:RegisterCondition("timetopandemicrange", false, TimeToPandemicRange);
end

do
    --- Get whether a potion is on combat lockdown.
    -- @name PotionCombatLockdown
	-- @paramsig boolean
    -- @param itemID - The potions item ID.
	-- @return A boolean value based on if the potion is on combat lockdown.
    local function PotionCombatLockdown(positionalParams, namedParams, state, atTime)
        local itemID = positionalParams[1];
        local returnValue = false;
		
        if itemID and type(itemID) ~= "number" then
            itemID = OvaleEquipment:GetEquippedItem(itemID);
        end
		
        if itemID then
            local _, _, enable = GetItemCooldown(itemID);
			
            returnValue = enable and enable == 0
		end

        return TestBoolean(returnValue);
    end

    OvaleCondition:RegisterCondition("potioncombatlockdown", false, PotionCombatLockdown);
end

do
    --- Get whether the regenerating runes of the given type for death knights is a death rune.
    -- @name RechargeAsDeathRune
    -- @paramsig boolean
    -- @param type The type of rune.
    --     Valid values: blood, frost, unholy
    -- @return The number of runes.
    -- @return A boolean value expressing if the rune is a death rune.
    local function RegeneratingAsDeathRune(positionalParams, namedParams, state, atTime)
        local name = positionalParams[1];
        local count, startCooldown, endCooldown = state:DeathRuneCount(name, atTime);
		
        return TestBoolean(startCooldown < math.huge and endCooldown < math.huge);
    end

    OvaleCondition:RegisterCondition("regeneratingasdeathrune", false, RegeneratingAsDeathRune);
end