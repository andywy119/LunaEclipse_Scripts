local FORCE_DEBUG = false;
local Debug = LunaEclipseScripts.Debug;

local Ovale = LunaEclipseScripts.Ovale;

local function OnDropDownValueChanged(widget)
	-- Reflect the value change into the profile (model).
	local id = widget:GetUserData("name");
	
	Ovale.db.profile.list[id] = widget:GetValue();
	Ovale:SendMessage("Ovale_ListValueChanged", id);
end

function Ovale:SetListValue(id, newState)
	-- New check I added to determine if id is a string
	if type(id) == "string" then
		local ovaleProfile = Ovale.db.profile;
		local ovaleWidget = Ovale.listWidget[id];

		ovaleWidget:SetValue(newState);
		ovaleProfile.list[id] = newState;

		OnDropDownValueChanged(ovaleWidget)
	end
end

if not LunaEclipseScripts:isRequiredVersion(6, 2, 8) then
	local function OnCheckBoxValueChanged(widget)
		-- Reflect the value change into the profile (model).
		local id = widget:GetUserData("name");
		
		Ovale.db.profile.check[id] = widget:GetValue();
		Ovale:SendMessage("Ovale_CheckBoxValueChanged", id);
	end

	function Ovale:GetCheckBox(id)
		local ovaleWidget;
		
		if type(id) == "string" then
			ovaleWidget = self.checkBoxWidget[id];
		elseif type(id) == "number" then
			-- "id" is a number, so count checkboxes until we reach the correct one (indexed from 0).
			local counter = 0;
			
			for _, checkBox in pairs(self.checkBoxWidget) do
				if counter == id then
					ovaleWidget = checkBox;
					break;
				end
				
				counter = counter + 1;
			end
		end
		
		return ovaleWidget;
	end
	
	-- Set the checkbox control to the specified on/off (true/false) value.
	function Ovale:SetCheckBox(id, newState)
		local ovaleWidget = self:GetCheckBox(id);
		
		if ovaleWidget then
			local oldValue = ovaleWidget:GetValue();
			
			if oldValue ~= newState then
				ovaleWidget:SetValue(newState);
				OnCheckBoxValueChanged(ovaleWidget);
			end
		end
	end

	-- Toggle the checkbox control.
	function Ovale:ToggleCheckBox(id)
		local ovaleWidget = self:GetCheckBox(id);
		
		if ovaleWidget then
			local newState = not widget:GetValue();
			
			ovaleWidget:SetValue(newState);
			OnCheckBoxValueChanged(ovaleWidget);
		end
	end
end