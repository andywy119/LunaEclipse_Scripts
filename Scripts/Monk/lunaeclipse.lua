local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "LunaEclipse";
	local desc = "[6.1] LunaEclipse: SummonStone Monk Rotations";
	local code = [[
# Monk rotation functions based on the guides on SummonStone:  http://summonstone.com/

Include(lunaeclipse_common)

### WindWalker icons.
AddIcon help=shortcd specialization=windwalker
{
	if not InCombat() WindWalker_PrecombatShortCD()
	WindWalker_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=windwalker
{
	if not InCombat() WindWalker_Precombat()
	WindWalker_Main()
}

AddIcon help=aoe specialization=windwalker
{
	if not InCombat() WindWalker_Precombat()
	WindWalker_Main()
}

AddIcon help=cd specialization=windwalker
{
	if not InCombat() WindWalker_PrecombatCD()
	WindWalker_CD()
}
]];

	OvaleScripts:RegisterScript("MONK", nil, name, desc, code, "script");
end
