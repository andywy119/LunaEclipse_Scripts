local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "lunaeclipse_common";
    local desc = "[6.2] LunaEclipse: Common Death Knight Functions";
    local code = [[
# Death Knight rotation functions based on Skullflowers Guide:  http://summonstone.com/

Include(ovale_deathknight_spells)

Include(lunaeclipse_global)
Include(lunaeclipse_frost)
Include(lunaeclipse_unholy)

AddCheckBox(opt_melee_range "Show: Not in Melee Range")
AddCheckBox(opt_unholy_blight "Main Icons: Show Unholy Blight")

###
### Disease Functions
###
AddFunction Diseases_Expiring
{
        { 
                Talent(necrotic_plague_talent) 
            and target.DebuffRemaining(necrotic_plague_debuff) <= GCD()
        }
     or { 
                not Talent(necrotic_plague_talent) 
            and { 
                        target.DebuffRemaining(blood_plague_debuff) <= GCD() 
                     or target.DebuffRemaining(frost_fever_debuff) <= GCD()
                }
        }
}

AddFunction Diseases_Missing
{
        { 
                Talent(necrotic_plague_talent) 
            and target.DebuffStacks(necrotic_plague_debuff) < 15
        }
     or { 
                not Talent(necrotic_plague_talent) 
            and { 
                        not target.DebuffPresent(blood_plague_debuff) 
                     or not target.DebuffPresent(frost_fever_debuff) 
                }
        }
}

AddFunction Diseases_Missing_UnholyBlight
{
        { 
                Talent(necrotic_plague_talent) 
            and target.DebuffStacks(necrotic_plague_debuff) <= 5
        }
     or { 
                not Talent(necrotic_plague_talent) 
            and { 
                        not target.DebuffPresent(blood_plague_debuff) 
                     or not target.DebuffPresent(frost_fever_debuff) 
                }
        }
}

AddFunction Diseases_Outbreak_Use
{
        UnholyBlight_NotActive()
    and Diseases_Missing()
}

AddFunction UnholyBlight_NotActive
{
        not Talent(unholy_blight_talent)
     or {
                Talent(unholy_blight_talent)
            and TimeSincePreviousSpell(unholy_blight) >= 10
        }
}

AddFunction Diseases_UnholyBlight_Use
{
        CheckBoxOn(opt_unholy_blight)
    and Diseases_Missing_UnholyBlight()
}

###
### Rune Functions
###
AddFunction Runes_Available
{
        RuneCount(blood) + RuneCount(frost) + RuneCount(unholy)
}

AddFunction Runes_Available_PlagueLeech
{
        {
                Rune(blood) < 1 
            and Rune(frost) < 1
        }
     or {
                Rune(blood) < 1 
            and Rune(unholy) < 1
        }
     or {
                Rune(frost) < 1 
            and Rune(unholy) < 1
        }
}

AddFunction Runes_RechargeDeath_Blood
{
        Rune(blood death=0) < Rune(blood)
}

###
### Spell Functions
###
AddFunction BloodBoil_Use
{
        target.DiseasesTicking() 
    and { 
                not Talent(unholy_blight_talent) 
             or SpellCooldown(unholy_blight) < 49
        }
    and {
                { 
                        Talent(necrotic_plague_talent) 
                    and DOTTargetCount(necrotic_plague_debuff) < Enemies()
                }
             or { 
                        not Talent(necrotic_plague_talent) 
                    and { 
                                DOTTargetCount(blood_plague_debuff) < Enemies()
                             or DOTTargetCount(frost_fever_debuff) < Enemies()
                        }
                }
        }
    and TimeSincePreviousSpell(blood_boil) >= 28
}

AddFunction Defile_Use
{
        target.TimeToDie() >= 10
}

AddFunction EmpowerRuneWeapon_Use
{
        Runes_Available() == 0 
    and RunicPower() < 25
}

AddFunction HornOfWinter_Use
{
        BuffExpires(attack_power_multiplier_buff any=1)
}

AddFunction PlagueLeech_Use
{
        Runes_Available_PlagueLeech()
    and target.DiseasesTicking()
}

###
### Rotation Functions
###
AddFunction BreathOfSindragosa_Rotation_Use
{
        Talent(breath_of_sindragosa_talent)
    and BuffPresent(breath_of_sindragosa_buff)
}

###
### General Functions
###
AddFunction InterruptActions_Use
{
    if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
    {
        if target.InRange(mind_freeze) Spell(mind_freeze)
        if not target.Classification(worldboss)
        {
            if target.InRange(asphyxiate) Spell(asphyxiate)
            if target.InRange(strangulate) Spell(strangulate)
            Spell(arcane_torrent_runicpower)
            if target.InRange(quaking_palm) Spell(quaking_palm)
            Spell(war_stomp)
        }
    }
}

AddFunction MeleeRange_Use
{
    if CheckBoxOn(opt_melee_range) and not target.InRange(plague_strike) Texture(misc_arrowlup help=L(not_in_melee_range))
}
]];

    OvaleScripts:RegisterScript("DEATHKNIGHT", nil, name, desc, code, "include");
end