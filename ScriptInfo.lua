local FORCE_DEBUG = false;
local Debug = LunaEclipseScripts.Debug;

local moduleName = "ScriptInfo";
local ScriptInfo = LunaEclipseScripts:NewModule(moduleName);
LunaEclipseScripts.ScriptInfo = ScriptInfo;

-- Current WOW Version
local CURRENT_WOW_VERSION = select(4, GetBuildInfo());

-- ClassID's
local CLASS_WARRIOR = 1;
local CLASS_PALADIN = 2;
local CLASS_HUNTER = 3;
local CLASS_ROGUE = 4;
local CLASS_PRIEST = 5;
local CLASS_DEATHKNIGHT = 6;
local CLASS_SHAMAN = 7;
local CLASS_MAGE = 8;
local CLASS_WARLOCK = 9;
local CLASS_MONK = 10;
local CLASS_DRUID = 11;

-- Death Knight SpecializationID's
local DEATHKNIGHT_BLOOD = 250;
local DEATHKNIGHT_FROST = 251;
local DEATHKNIGHT_UNHOLY = 252;

-- Druid SpecializationID's
local DRUID_BALANCE = 102;
local DRUID_FERAL = 103;
local DRUID_GUARDIAN = 104;
local DRUID_RESTORATION = 105;

-- Hunter SpecializationID's
local HUNTER_BEASTMASTERY = 253;
local HUNTER_MARKSMANSHIP = 254;
local HUNTER_SURVIVAL = 255;

-- Mage SpecializationID's
local MAGE_ARCANE = 62;
local MAGE_FIRE = 63;
local MAGE_FROST = 64;

-- Monk SpecializationID's
local MONK_BREWMASTER = 268;
local MONK_WINDWALKER = 269;
local MONK_MISTWEAVER = 270;

-- Paladin SpecializationID's
local PALADIN_HOLY = 65;
local PALADIN_PROTECTION = 66;
local PALADIN_RETRIBUTION = 70;

-- Priest SpecializationID's
local PRIEST_DISCIPLINE = 256;
local PRIEST_HOLY = 257;
local PRIEST_SHADOW = 258;

-- Rogue SpecializationID's
local ROGUE_ASSASSINATION = 259;
local ROGUE_COMBAT = 260;
local ROGUE_SUBTLETY = 261;

-- Shaman SpecializationID's
local SHAMAN_ELEMENTAL = 262;
local SHAMAN_ENHANCEMENT = 263;
local SHAMAN_RESTORATION = 264;

-- Warlock SpecializationID's
local WARLOCK_AFFLICTION = 265;
local WARLOCK_DEMONOLOGY = 266;
local WARLOCK_DESTRUCTION = 267;

-- Warrior SpecializationID's
local WARRIOR_ARMS = 71;
local WARRIOR_FURY = 72;
local WARRIOR_PROTECTION = 73;

-- Colour Codes
local COLOUR_CODE_MESSAGE = string.join("", "|c", "FF", "FF", "FF", "00");
local COLOUR_CODE_INVALID = string.join("", "|c", "FF", "FF", "00", "00");
local COLOUR_CODE_VALID = string.join("", "|c", "FF", "00", "FF", "00");

-- Class Hex Colours
local CLASS_COLOUR_CODES = {};

CLASS_COLOUR_CODES[CLASS_WARRIOR] = string.join("", "|c", "FF", "C7", "9C", "6E");
CLASS_COLOUR_CODES[CLASS_PALADIN] = string.join("", "|c", "FF", "F5", "8C", "BA");
CLASS_COLOUR_CODES[CLASS_HUNTER] = string.join("", "|c", "FF", "AB", "D4", "73");
CLASS_COLOUR_CODES[CLASS_ROGUE] = string.join("", "|c", "FF", "FF", "F5", "69");
CLASS_COLOUR_CODES[CLASS_PRIEST] = string.join("", "|c", "FF", "FF", "FF", "FF");
CLASS_COLOUR_CODES[CLASS_DEATHKNIGHT] = string.join("", "|c", "FF", "C4", "1F", "3B");
CLASS_COLOUR_CODES[CLASS_SHAMAN] = string.join("", "|c", "FF", "00", "70", "DE");
CLASS_COLOUR_CODES[CLASS_MAGE] = string.join("", "|c", "FF", "69", "CC", "F0");
CLASS_COLOUR_CODES[CLASS_WARLOCK] = string.join("", "|c", "FF", "94", "82", "C9");
CLASS_COLOUR_CODES[CLASS_MONK] = string.join("", "|c", "FF", "00", "FF", "96");
CLASS_COLOUR_CODES[CLASS_DRUID] = string.join("", "|c", "FF", "FF", "7D", "0A");

-- Guide Authors
local GUIDE_AUTHOR = {};

-- Death Knight Guide Authors
GUIDE_AUTHOR[DEATHKNIGHT_FROST] = "Tegu";
GUIDE_AUTHOR[DEATHKNIGHT_UNHOLY] = "Tegu";

-- Hunter Guide Authors
GUIDE_AUTHOR[HUNTER_BEASTMASTERY] = "Azortharion";
GUIDE_AUTHOR[HUNTER_MARKSMANSHIP] = "Azortharion";
GUIDE_AUTHOR[HUNTER_SURVIVAL] = "Azortharion";

-- Monk Guide Authors
GUIDE_AUTHOR[MONK_WINDWALKER] = "Maximize";

-- Warlock Guide Authors
GUIDE_AUTHOR[WARLOCK_DEMONOLOGY] = "Zagam";

-- Guide Links
local GUIDE_LINK = {};

-- Death Knight Guide Links
GUIDE_LINK[DEATHKNIGHT_FROST] = "http://www.icy-veins.com/wow/frost-death-knight-pve-dps-guide";
GUIDE_LINK[DEATHKNIGHT_UNHOLY] = "http://www.icy-veins.com/wow/unholy-death-knight-pve-dps-guide";

-- Hunter Guide Links
GUIDE_LINK[HUNTER_BEASTMASTERY] = "https://goo.gl/Ks7kPX";
GUIDE_LINK[HUNTER_MARKSMANSHIP] = "https://goo.gl/Ks7kPX";
GUIDE_LINK[HUNTER_SURVIVAL] = "https://goo.gl/Ks7kPX";

-- Monk Guide Links
GUIDE_LINK[MONK_WINDWALKER] = "http://summonstone.com/monk/windwalker/";

-- Warlock Guide Links
GUIDE_LINK[WARLOCK_DEMONOLOGY] = "http://www.darkintentions.net/61-demonology-warlock-guide.html";

-- Guide Version
local GUIDE_VERSION = {};

-- Death Knight Guide Interface Numbers
GUIDE_VERSION[DEATHKNIGHT_FROST] = 60200;
GUIDE_VERSION[DEATHKNIGHT_UNHOLY] = 60200;

-- Hunter Guide Interface Numbers
GUIDE_VERSION[HUNTER_BEASTMASTERY] = 60200;
GUIDE_VERSION[HUNTER_MARKSMANSHIP] = 60200;
GUIDE_VERSION[HUNTER_SURVIVAL] = 60200;

-- Monk Guide Interface Numbers
GUIDE_VERSION[MONK_WINDWALKER] = 60100;

-- Warlock Guide Interface Numbers
GUIDE_VERSION[WARLOCK_DEMONOLOGY] = 60100;

local function ConvertVersionNumber(versionNumber)
    if versionNumber then
        local majorVersion, minorVersion, revisionNumber;

        majorVersion = tonumber(string.sub(versionNumber, 1, 1));
        minorVersion = tonumber(string.sub(versionNumber, 2, 3));
        revisionNumber = tonumber(string.sub(versionNumber, 4, 5));

        if revisionNumber == 0 then
            return string.join(".", tostring(majorVersion), tostring(minorVersion));
        else
            return string.join(".", tostring(majorVersion), tostring(minorVersion), tostring(revisionNumber));
        end
    else
        return nil;
    end
end

local function FormatVersion(versionNumber)
    if versionNumber then
        local versionString = ConvertVersionNumber(versionNumber);

        if versionNumber ~= CURRENT_WOW_VERSION then
            return string.join("", COLOUR_CODE_INVALID, tostring(versionString), TEXT_COLOR_TAG_END);
        else
            return string.join("", COLOUR_CODE_VALID, tostring(versionString), TEXT_COLOR_TAG_END);
        end
    else
        return nil;
    end
end

local function FormatURL(URL)
    local _, _, classID = UnitClass("player");

    return string.join("", CLASS_COLOUR_CODES[classID], "[", "|Hurl:", URL, "|h", URL, "|h", "]", TEXT_COLOR_TAG_END);
end

function ScriptInfo:ShowScriptMessage(currentSpec)
    if currentSpec then
        local addonTitle = LunaEclipseScripts:AddonInfo();
        local _, currentSpecName = GetSpecializationInfoByID(currentSpec);
        local scriptGuideAuthor = GUIDE_AUTHOR[currentSpec];
        local scriptGuideLink = GUIDE_LINK[currentSpec];
        local scriptGuideVersion = GUIDE_VERSION[currentSpec];
        local specMessage, specMessageExtra;

        if not scriptGuideAuthor and not scriptGuideLink then
            if currentSpec ~= DRUID_BALANCE then
                specMessage = string.format("%sThe %q rotation is not currently supported by this addon!|r", COLOUR_CODE_INVALID, currentSpecName);
                specMessageExtra = "Sorry for any inconvience, please use the Default Ovale script package.";
            else
                specMessage = string.format("%sThe %q rotation is not currently supported by this addon!|r", COLOUR_CODE_INVALID, currentSpecName);
                specMessageExtra = string.format("Sorry for any inconvience, please note that %q rotation support is not currently in Ovale.", currentSpecName);
            end

            LunaEclipseScripts:SendMessage(LEOS_DEBUG, true, false, addonTitle..":", specMessage, specMessageExtra);
        else
            specMessage = string.format("%sThe %q rotation is based on %s's guide:|r", COLOUR_CODE_MESSAGE, currentSpecName, scriptGuideAuthor);		
            specGuideVersion = string.join(" ", "WoW Version of Script:", FormatVersion(scriptGuideVersion));
            specMessageExtra = "Please check it out for information on best talent choices to work with this script!";
            LunaEclipseScripts:SendMessage(LEOS_DEBUG, true, false, addonTitle..":", specMessage, FormatURL(scriptGuideLink), specGuideVersion, specMessageExtra);
        end
    end
end