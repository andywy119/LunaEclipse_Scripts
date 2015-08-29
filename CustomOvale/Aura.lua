local FORCE_DEBUG = false;
local Debug = LunaEclipseScripts.Debug;

if not LunaEclipseScripts:isRequiredVersion(6, 2, 10) then
	local Ovale = LunaEclipseScripts.Ovale;

	local moduleName = "CustomOvaleAura";
	local CustomOvaleAura = LunaEclipseScripts:NewModule(moduleName, "AceEvent-3.0");
	LunaEclipseScripts.CustomOvaleAura = CustomOvaleAura;

	local OvaleAura = Ovale.OvaleAura;
	local OvaleGUID = Ovale.OvaleGUID;

	local petGUID = nil;

	local function myGetGUID(unitID)
		return OvaleGUID:UnitGUID(unitID) or OvaleGUID:GetGUID(unitID);
	end

	function CustomOvaleAura:OnEnable()
		self:RegisterEvent("PLAYER_ENTERING_WORLD");
		self:RegisterEvent("UNIT_PET");
	end

	function CustomOvaleAura:OnDisable()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD");
		self:UnregisterEvent("UNIT_PET");
	end

	function CustomOvaleAura:PLAYER_ENTERING_WORLD(event, ...)
		petGUID = myGetGUID("pet")
	end

	function CustomOvaleAura:UNIT_PET(event, ...)
		local eventUnit = select(1, ...);

		if eventUnit == "player" then
			local newPetGUID = myGetGUID("pet");

			if not newPetGUID or newPetGUID ~= petGUID then 
				petGUID = newPetGUID;

				OvaleAura:CleanState(OvaleAura);
				OvaleAura:ScanAllUnitAuras();
			end
		end
	end
end