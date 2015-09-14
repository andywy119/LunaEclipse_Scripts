local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "LunaEclipse";
    local desc = "[6.1] LunaEclipse: Zagam's Warlock Rotations";
    local code = [[
# Warlock rotation functions based on Zagams Warlock Guide:  http://www.darkintentions.net/

Include(lunaeclipse_common)

### Affliction icons.
AddIcon help=shortcd specialization=affliction
{
    if not InCombat() Affliction_PrecombatShortCD()
    Affliction_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=affliction
{
    if not InCombat() Affliction_Precombat()
    Affliction_Main()
}

AddIcon help=aoe specialization=affliction
{
    if not InCombat() Affliction_Precombat()
    Affliction_Main()
}

AddIcon help=cd specialization=affliction
{
    if not InCombat() Affliction_PrecombatCD()
    Affliction_CD()
}

### Demonology icons.
AddIcon help=shortcd specialization=demonology
{
    if not InCombat() Demonology_PrecombatShortCD()
    Demonology_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=demonology
{
    if not InCombat() Demonology_Precombat()
    Demonology_Main()
}

AddIcon help=aoe specialization=demonology
{
    if not InCombat() Demonology_Precombat()
    Demonology_Main()
}

AddIcon help=cd specialization=demonology
{
    if not InCombat() Demonology_PrecombatCD()
    Demonology_CD()
}

### Destruction icons.
AddIcon help=shortcd specialization=destruction
{
    if not InCombat() Destruction_PrecombatShortCD()
    Destruction_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=destruction
{
    if not InCombat() Destruction_Precombat()
    Destruction_Main()
}

AddIcon help=aoe specialization=destruction
{
    if not InCombat() Destruction_Precombat()
    Destruction_Main()
}

AddIcon help=cd specialization=destruction
{
    if not InCombat() Destruction_PrecombatCD()
    Destruction_CD()
}
]];

    OvaleScripts:RegisterScript("WARLOCK", nil, name, desc, code, "script");
end