local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "LunaEclipse";
    local desc = "[6.2] LunaEclipse: Skullflower's Death Knight Rotations";
    local code = [[
# Death Knight rotation functions based on Icy-Veins Guide approved by Tegu:  http://www.icy-veins.com/wow/class-guides

Include(lunaeclipse_common)

### Frost icons.
AddIcon help=shortcd specialization=frost
{
    if not InCombat() Frost_PrecombatShortCD()
    Frost_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=frost
{
    if not InCombat() Frost_Precombat()
    Frost_Main()
}

AddIcon help=aoe specialization=frost
{
    if not InCombat() Frost_Precombat()
    Frost_Main()
}

AddIcon help=cd specialization=frost
{
    if not InCombat() Frost_PrecombatCD()
    Frost_CD()
}

### Unholy icons.
AddIcon help=shortcd specialization=unholy
{
    if not InCombat() Unholy_PrecombatShortCD()
    Unholy_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=unholy
{
    if not InCombat() Unholy_Precombat()
    Unholy_Main()
}

AddIcon help=aoe specialization=unholy
{
    if not InCombat() Unholy_Precombat()
    Unholy_Main()
}

AddIcon help=cd specialization=unholy
{
    if not InCombat() Unholy_PrecombatCD()
    Unholy_CD()
}
]];

    OvaleScripts:RegisterScript("DEATHKNIGHT", nil, name, desc, code, "script");
end