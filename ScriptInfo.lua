local FORCE_DEBUG = false;
local Debug = LunaEclipseScripts.Debug;

local moduleName = "ScriptInfo";
local ScriptInfo = LunaEclipseScripts:NewModule(moduleName);
LunaEclipseScripts.ScriptInfo = ScriptInfo;

-- Current WOW Version
local CURRENT_WOW_VERSION = "6.2";

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
local COLOUR_CODE_MESSAGE = "|cFF".."FFFF00";
local COLOUR_CODE_INVALID = "|cFF".."FF0000";
local COLOUR_CODE_VALID = "|cFF".."00FF00";

-- Class Hex Colours
local CLASS_COLOUR_CODES = {};

CLASS_COLOUR_CODES[CLASS_WARRIOR] = "|cFF".."C79C6E";
CLASS_COLOUR_CODES[CLASS_PALADIN] = "|cFF".."F58CBA";
CLASS_COLOUR_CODES[CLASS_HUNTER] = "|cFF".."ABD473";
CLASS_COLOUR_CODES[CLASS_ROGUE] = "|cFF".."FFF569";
CLASS_COLOUR_CODES[CLASS_PRIEST] = "|cFF".."FFFFFF";
CLASS_COLOUR_CODES[CLASS_DEATHKNIGHT] = "|cFF".."C41F3B";
CLASS_COLOUR_CODES[CLASS_SHAMAN] = "|cFF".."0070DE";
CLASS_COLOUR_CODES[CLASS_MAGE] = "|cFF".."69CCF0";
CLASS_COLOUR_CODES[CLASS_WARLOCK] = "|cFF".."9482C9";
CLASS_COLOUR_CODES[CLASS_MONK] = "|cFF".."00FF96";
CLASS_COLOUR_CODES[CLASS_DRUID] = "|cFF".."FF7D0A";

-- Guide Authors
local GUIDE_AUTHOR = {};

-- Death Knight Guide Authors
GUIDE_AUTHOR[DEATHKNIGHT_FROST] = "Skullflower";
GUIDE_AUTHOR[DEATHKNIGHT_UNHOLY] = "Skullflower";

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
GUIDE_LINK[DEATHKNIGHT_FROST] = "http://summonstone.com/deathknight/frost/";
GUIDE_LINK[DEATHKNIGHT_UNHOLY] = "http://summonstone.com/deathknight/unholy/";

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

-- Death Knight Guide Versions
GUIDE_VERSION[DEATHKNIGHT_FROST] = "6.2";
GUIDE_VERSION[DEATHKNIGHT_UNHOLY] = "6.2";

-- Hunter Guide Versions
GUIDE_VERSION[HUNTER_BEASTMASTERY] = "6.2";
GUIDE_VERSION[HUNTER_MARKSMANSHIP] = "6.2";
GUIDE_VERSION[HUNTER_SURVIVAL] = "6.2";

-- Monk Guide Versions
GUIDE_VERSION[MONK_WINDWALKER] = "6.1";

-- Warlock Guide Versions
GUIDE_VERSION[WARLOCK_DEMONOLOGY] = "6.1";

local function FormatVersion(versionNumber)
	if versionNumber then
		if versionNumber ~= CURRENT_WOW_VERSION then
			return format("%s%s|r", COLOUR_CODE_INVALID, tostring(versionNumber));
		else
			return format("%s%s|r", COLOUR_CODE_VALID, tostring(versionNumber));
		end
	else
		return nil;
	end
end

local function FormatURL(URL)
	local _, _, classID = UnitClass("player");

	return format("%s[|Hurl:%s|h%s|h]|r", CLASS_COLOUR_CODES[classID], URL, URL)
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
				specMessage = format("%sThe %q rotation is not currently supported by this addon!|r", COLOUR_CODE_INVALID, currentSpecName);
				specMessageExtra = "Sorry for any inconvience, please use the Default Ovale script package.";
			else
				specMessage = format("%sThe %q rotation is not currently supported by this addon!|r", COLOUR_CODE_INVALID, currentSpecName);
				specMessageExtra = format("Sorry for any inconvience, please note that %q rotation support is not currently in Ovale.", currentSpecName);
			end

			LunaEclipseScripts:SendMessage(LEOS_DEBUG, true, false, addonTitle..":", specMessage, specMessageExtra);
		else
			specMessage = format("%sThe %q rotation is based on %s's guide:|r", COLOUR_CODE_MESSAGE, currentSpecName, scriptGuideAuthor);		
			specGuideVersion = format("WoW Version of Script: %s", FormatVersion(scriptGuideVersion));
			specMessageExtra = "Please check it out for information on best talent choices to work with this script!";
			LunaEclipseScripts:SendMessage(LEOS_DEBUG, true, false, addonTitle..":", specMessage, FormatURL(scriptGuideLink), specGuideVersion, specMessageExtra);
		end
	end
end