local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_destruction";
	local desc = "[6.1] LunaEclipse: Zagam's Destruction Rotation";
	local code = [[
# Warlock rotation functions based on Zagams Guide:  http://www.darkintentions.net/

###
### Destruction - Main
###
AddFunction Destruction_ShortCD
{
}

AddFunction Destruction_Main
{
}

AddFunction Destruction_CD
{
}

###
### Destruction - Precombat
###
AddFunction Destruction_PrecombatShortCD
{
	Demon_Summon()
}

AddFunction Destruction_Precombat
{
	if not BuffPresent(spell_power_multiplier_buff any=1) Spell(dark_intent)
	if Talent(grimoire_of_sacrifice_talent) and not Talent(demonic_servitude_talent) and pet.Present() Spell(grimoire_of_sacrifice)
	Spell(incinerate)
}

AddFunction Destruction_PrecombatCD
{
	LunaEclipse_Potion_Intellect_Use()
}
]];

	OvaleScripts:RegisterScript("WARLOCK", "destruction", name, desc, code, "include");
end
