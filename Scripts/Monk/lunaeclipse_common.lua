local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "lunaeclipse_common";
    local desc = "[6.1] LunaEclipse: Common Monk Functions";
    local code = [[
# Monk rotation functions based on the guides on SummonStone:  http://summonstone.com/

Include(ovale_monk_spells)

Include(lunaeclipse_global)
Include(lunaeclipse_windwalker)
	
AddCheckBox(opt_melee_range "Show: Not in Melee Range")
AddCheckBox(opt_chi_burst "Main Icons: Show Chi Burst" default)
AddCheckBox(opt_brews "Main Icons: Show DPS Brews" default)
AddCheckBox(opt_xuen "Main Icons: Show Invoke Xuen" default)

###
### Chi and Energy Functions
###
AddFunction Chi_Unactivated
{
        MaxChi() - Chi()
}

AddFunction Energy_Starved
{
        Energy() + EnergyRegenRate() < 50
}

###
### General Functions
###
AddFunction MeleeRange_Use
{
    if CheckBoxOn(opt_melee_range) and not target.InRange(jab) Texture(misc_arrowlup help=L(not_in_melee_range))
}

AddFunction InterruptActions_Use
{
    if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
    {
        if target.InRange(spear_hand_strike) Spell(spear_hand_strike)
        if not target.Classification(worldboss)
        {
            if target.InRange(paralysis) Spell(paralysis)
            Spell(arcane_torrent_chi)
            if target.InRange(quaking_palm) Spell(quaking_palm)
            Spell(war_stomp)
        }
    }
}
]];

    OvaleScripts:RegisterScript("MONK", nil, name, desc, code, "include");
end