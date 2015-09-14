local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "LunaEclipse";
    local desc = "[6.2] LunaEclipse: Azortharion's Hunter Rotations";
    local code = [[
# Hunter rotation functions based on Azortharions Hunter Guide:  https://goo.gl/Ks7kPX

Include(lunaeclipse_common)

### BeastMastery icons.
AddIcon help=shortcd specialization=beast_mastery
{
    if not InCombat() BeastMastery_PrecombatShortCD()
    BeastMastery_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=beast_mastery
{
    if not InCombat() BeastMastery_Precombat()
    BeastMastery_Main()
}

AddIcon help=aoe specialization=beast_mastery
{
    if not InCombat() BeastMastery_Precombat()
    BeastMastery_Main()
}

AddIcon help=cd specialization=beast_mastery
{
    if not InCombat() BeastMastery_PrecombatCD()
    BeastMastery_CD()
}

### Marksmanship icons.
AddIcon help=shortcd specialization=marksmanship
{
    if not InCombat() Marksmanship_PrecombatShortCD()
    Marksmanship_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=marksmanship
{
    if not InCombat() Marksmanship_Precombat()
    Marksmanship_Main()
}

AddIcon help=aoe specialization=marksmanship
{
    if not InCombat() Marksmanship_Precombat()
    Marksmanship_Main()
}

AddIcon help=cd specialization=marksmanship
{
    if not InCombat() Marksmanship_PrecombatCD()
    Marksmanship_CD()
}

### Survival icons.
AddIcon help=shortcd specialization=survival
{
    if not InCombat() Survival_PrecombatShortCD()
    Survival_ShortCD()
}

AddIcon checkbox=opt_single_target enemies=1 help=main specialization=survival
{
    if not InCombat() Survival_Precombat()
    Survival_Main()
}

AddIcon help=aoe specialization=survival
{
    if not InCombat() Survival_Precombat()
    Survival_Main()
}

AddIcon help=cd specialization=survival
{
    if not InCombat() Survival_PrecombatCD()
    Survival_CD()
}
]];

    OvaleScripts:RegisterScript("HUNTER", nil, name, desc, code, "script");
end
