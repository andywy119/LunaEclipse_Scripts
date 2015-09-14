local addonName = "LunaEclipseScripts";
local LunaEclipseScripts = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0");
_G[addonName] = LunaEclipseScripts;

local FORCE_DEBUG = false;

local Ovale = LibStub("AceAddon-3.0"):GetAddon("Ovale");
local Debug, ScriptInfo;

LunaEclipseScripts.Ovale = Ovale;

local OvaleVersion = Ovale.OvaleVersion;

local ADDON_NAME = "LunaEclipse_Scripts";
local ADDON_TITLE = GetAddOnMetadata(ADDON_NAME, "Title");
local ADDON_AUTHOR = GetAddOnMetadata(ADDON_NAME, "Author");
local ADDON_VERSION = GetAddOnMetadata(ADDON_NAME, "Version");

local previousSpec;

function LunaEclipseScripts:OnInitialize()
    Debug = self.Debug;
    ScriptInfo = self.ScriptInfo;
	
    self:AddonInfo_Display();
end

function LunaEclipseScripts:OnEnable()
    self:RegisterEvent("PLAYER_LOGIN");
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
end

function LunaEclipseScripts:OnDisable()
    self:UnregisterEvent("PLAYER_LOGIN");
    self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
end

function LunaEclipseScripts:AddonInfo(stripTags)
    if not stripTags then
        return string.join("", "|c", "FF", "17", "84", "D1", ADDON_TITLE, "|r"), string.join("", "|c", "FF", "FF", "D7", "00", ADDON_AUTHOR, "|r"), string.join("", "|c", "FF", "17", "84", "D1", ADDON_VERSION, "|r");
    else
        return ADDON_TITLE, ADDON_AUTHOR, ADDON_VERSION;
    end
end

function LunaEclipseScripts:AddonInfo_Display()
    local addonTitle, addonAuthor, addonVersion = LunaEclipseScripts:AddonInfo();
	
    print(string.join(" ", addonTitle, "Version:", addonVersion, "loaded!"));
end

function LunaEclipseScripts:Keybind(ID)	
    Ovale:ToggleCheckBox(ID);
end

function LunaEclipseScripts:GetOvaleVersionInfo()
    local ovaleVersionString = Ovale.version or OvaleVersion.version;
    local alphaPosition, betaPosition, ovaleVersion, versionType;

    alphaPosition = string.find(ovaleVersionString, "alpha");
    betaPosition = string.find(ovaleVersionString, "beta");
	
    if alphaPosition then
        ovaleVersion = string.sub(ovaleVersionString, 1, alphaPosition - 1);
        versionType = OVALE_ALPHA;
    elseif betaPosition then
        ovaleVersion = string.sub(ovaleVersionString, 1, betaPosition - 1);
        versionType = OVALE_BETA;
    else
        ovaleVersion = ovaleVersionString;
        versionType = OVALE_RELEASE;
    end
	
    local majorVersion, minorVersion, revisionVersion = string.split(".", ovaleVersion);
	
    return versionType, tonumber(majorVersion), tonumber(minorVersion), tonumber(revisionVersion);
end

function LunaEclipseScripts:isRequiredVersion(requiredMajorVersion, requiredMinorVersion, requiredRevisionVersion)
    local versionType, majorVersion, minorVersion, revisionVersion = LunaEclipseScripts:GetOvaleVersionInfo();

    return majorVersion > requiredMajorVersion
            or (majorVersion == requiredMajorVersion and minorVersion > requiredMinorVersion)
            or (majorVersion == requiredMajorVersion and minorVersion == requiredMinorVersion and revisionVersion >= requiredRevisionVersion)
end

function LunaEclipseScripts:PLAYER_LOGIN(event, ...)
    local specIndex = GetSpecialization();
	
    if specIndex then 
        local currentSpec = GetSpecializationInfo(specIndex);

        if not previousSpec or currentSpec ~= previousSpec then 
            previousSpec = currentSpec;
            ScriptInfo:ShowScriptMessage(currentSpec);
        end
    end
end

function LunaEclipseScripts:PLAYER_SPECIALIZATION_CHANGED(event, ...)
    local eventUnit = select(1, ...);

    if eventUnit == "player" then
        local specIndex = GetSpecialization();
		
        if specIndex then 
            local currentSpec = GetSpecializationInfo(specIndex);

            if not previousSpec or currentSpec ~= previousSpec then 
                previousSpec = currentSpec;
                ScriptInfo:ShowScriptMessage(currentSpec);
            end
        end
    end
end