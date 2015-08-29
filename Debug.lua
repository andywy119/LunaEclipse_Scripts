local moduleName = "Debug";
local Debug = LunaEclipseScripts:NewModule(moduleName, "AceConsole-3.0", "AceEvent-3.0");
LunaEclipseScripts.Debug = Debug;

local ADDON_DEBUG = false;
local MESSAGE_INDENT = "     ";

local function debugVariables(index, value, indent, showCounter)
		if showCounter then
			print(string.format("%s%s[%i]|r %s", MESSAGE_INDENT, "|cff1784d1", index, tostring(message)));		
		else
			print(string.join("", indent, tostring(value)));		
		end
end

local function debugTable(table, indent, showCounter)
	if showCounter then
		print(string.format("%s%s[%i]|r %s", indent, "|cff1784d1", argumentCounter, "Table with the following contents:"));		
	else
		print(string.join("", indent, "Table with the following contents:"));		
	end
					
	for index, value in pairs(message) do
		if type(value) == "table" then
			debugTable(value, string.join("", indent, MESSAGE_INDENT), showCounter); 
		else
			debugVariables(index, value, string.join("", indent, MESSAGE_INDENT), true);
		end		
	end
end

function Debug:DebugMode(enableDebug)
	ADDON_DEBUG = enableDebug or false;
	Debug:Debug_Status();
end

function Debug:Debug_Status()
	local addonInfo = LunaEclipseScripts:AddonInfo();

	print(string.join(" - ", addonInfo.title, (ADDON_DEBUG and "Debugging: On") or "Debugging: Off"));
end

function Debug:ShowMessage(event, force, showCounter, functionName, ...)
	if ADDON_DEBUG or force then
		local message;

		print(string.join("", "|cffffd700", tostring(functionName), TEXT_COLOR_TAG_END));

		for argumentCounter = 1, select("#", ...) do
			message = select(argumentCounter, ...);

			if type(message) == "table" then
				debugTable(message, MESSAGE_INDENT, showCounter);				
			else
				debugVariables(argumentCounter, message, MESSAGE_INDENT, showCounter);
			end
		end
	end
end


function Debug:OnEnable()
	self:RegisterMessage(LEOS_DEBUG, "ShowMessage");
end

function Debug:OnDisable()
	self:UnregisterMessage(LEOS_DEBUG);
end