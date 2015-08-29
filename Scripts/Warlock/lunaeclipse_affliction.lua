local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_affliction";
	local desc = "[6.1] LunaEclipse: Zagam's Affliction Rotation";
	local code = [[
# Warlock rotation functions based on Zagams Guide:  http://www.darkintentions.net/

###
### Affliction - Main
###
AddFunction Affliction_ShortCD
{
}

AddFunction Affliction_Main
{
}

AddFunction Affliction_CD
{
}

###
### Affliction - Precombat
###
AddFunction Affliction_PrecombatShortCD
{
	Demon_Summon()
}

AddFunction Affliction_Precombat
{
	if not BuffPresent(spell_power_multiplier_buff any=1) Spell(dark_intent)
	if Talent(grimoire_of_sacrifice_talent) and not Talent(demonic_servitude_talent) and pet.Present() Spell(grimoire_of_sacrifice)
	Spell(agony)
}

AddFunction Affliction_PrecombatCD
{
	LunaEclipse_Potion_Intellect_Use()
}
]];

	OvaleScripts:RegisterScript("WARLOCK", "affliction", name, desc, code, "include");
end
