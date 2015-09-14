local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "lunaeclipse_unholy";
    local desc = "[6.2] LunaEclipse: Icy-Veins Unholy Rotations";
    local code = [[
# Death Knight rotation functions based on Icy-Veins Guide approved by Tegu:  http://www.icy-veins.com/wow/unholy-death-knight-pve-dps-guide

Define(crazed_monstrosity_buff 187981)
    SpellInfo(crazed_monstrosity_buff duration=30)

SpellList(pet_dark_transformation_buff dark_transformation_buff crazed_monstrosity_buff)

###
### Disease Functions
###
AddFunction Unholy_FesteringStrike_Use_NecroticPlague
{
        UnholyBlight_NotActive()
    and {
                Talent(necrotic_plague_talent)
            and target.DebuffPresent(necrotic_plague_debuff) 
        }
    and {
                target.DebuffRemaining(necrotic_plague_debuff) < SpellCooldown(unholy_blight)
            and target.TimeToPandemicRange(necrotic_plague_debuff) <= 6
            and target.DebuffRemaining(necrotic_plague_debuff) > GCD()
        }
}

AddFunction Unholy_PlagueStrike_Use_Diseases
{
        UnholyBlight_NotActive()
    and {
                {
                        Talent(necrotic_plague_talent)
                    and SpellCooldown(unholy_blight) > GCD()
                    and SpellCooldown(outbreak) > GCD()
                    and not target.DebuffPresent(necrotic_plague_debuff) 
                }
             or { 
                        not Talent(necrotic_plague_talent) 
                    and { 
                                not target.DebuffPresent(blood_plague_debuff) 
                             or not target.DebuffPresent(frost_fever_debuff) 
                        }
                }
        }
}

###
### Spell Functions
###
AddFunction Unholy_BloodTap_Use
{
        BuffStacks(blood_charge_buff) >= 10
     or {
                {
                        {
                                not RegeneratingAsDeathRune(blood)
                            and not RegeneratingAsDeathRune(frost)
                        }
                     or {
                                Rune(blood) == 2
                            and Rune(frost) == 2
                            and Rune(unholy) < 1
                        }
                }
            and BuffStacks(blood_charge_buff) >= 5
        }
}

AddFunction Unholy_BloodTap_Use_SoulReaper
{
        Unholy_SoulReaper_Use() 
    and BuffStacks(blood_charge_buff) >= 5
    and Rune(unholy) < 1
}

AddFunction Unholy_BreathOfSindragosa_Use
{
        Talent(breath_of_sindragosa_talent)
    and not BuffPresent(breath_of_sindragosa_buff)
    and {
                Rune(blood) >= 1
            and Rune(frost) >= 1
            and Rune(unholy) >= 1    	
	    }
    and RunicPower() > 75
}		

AddFunction Unholy_DeathAndDecay_Use
{
        Enemies() >= 2 
    and target.TimeToDie() >= 5
    and Rune(unholy) >= 2
}

AddFunction Unholy_DeathCoil_Use
{
        {
                pet.Present()
            and not BuffPresent(pet_dark_transformation_buff)
        }
     or {
                BuffPresent(pet_dark_transformation_buff)
            and BuffRemaining(pet_dark_transformation_buff) > 5
            and {
                        BuffPresent(sudden_doom_buff)
                     or RunicPower() > 80
                }
        }
     or RunicPower() > 80
}		

AddFunction Unholy_DeathCoil_Use_BreathOfSindragosa
{
        BuffPresent(sudden_doom_buff)
}		

AddFunction Unholy_FesteringStrike_Use
{
        Rune(blood death=0) >= 1
    and Rune(frost death=0) >= 1
}

AddFunction Unholy_Gargoyle_Use
{
	    target.TimeToDie() >= 40
}

AddFunction Unholy_PlagueLeech_Use_Outbreak
{
        Runes_Available_PlagueLeech()
    and {
                Diseases_Expiring()
             or SpellCooldown(outbreak) < GCD()
        }
}

AddFunction Unholy_SoulReaper_Use
{
        target.HealthPercent() <= 45 
     or target.TimeToHealthPercent(45) < BaseDuration(soul_reaper_unholy_debuff)
}

###
### Item Functions
###
AddFunction Unholy_Potion_Use
{
        BuffPresent(burst_haste_buff any=1)
     or {
                DebuffPresent(burst_haste_debuff)
            and {
                        {
                                BuffPresent(trinket_stat_any_buff)
                             or BuffPresent(legendary_ring_buff) 
                             or BuffStacks(trinket_stacking_proc_any_buff) > 6
                        }
                     or {
                                target.HealthPercent() <= 45
                             or target.TimeToDie() <= 25
                        }
                }
        }
     or {
                not DebuffPresent(burst_haste_debuff)
            and target.TimeToDie() <= 25
        }
}

###
### Breath of Sindragosa Rotation
###
AddFunction Unholy_Rotation_BreathOfSindragosa
{
    Spell(dark_transformation)
    if Diseases_Missing() Unholy_Rotation_Diseases_Apply()
    if Unholy_FesteringStrike_Use() and RunicPower() < 80 Spell(festering_strike)
    if RunicPower() < 70 Spell(arcane_torrent_runicpower)
    if RunicPower() < 88 Spell(scourge_strike)
    if Unholy_BloodTap_Use() Spell(blood_tap)
    if PlagueLeech_Use() Spell(plague_leech)
    if RunicPower() < 60 Spell(empower_rune_weapon)
    if Unholy_DeathCoil_Use_BreathOfSindragosa() Spell(death_coil)
}

###
### Unholy Rotations
###
AddFunction Unholy_Rotation_Diseases_Apply
{
    if Diseases_Outbreak_Use() Spell(outbreak)
    if Unholy_PlagueStrike_Use_Diseases() Spell(plague_strike)
}

AddFunction Unholy_Rotation_FesteringStrike_Use
{
    if Unholy_FesteringStrike_Use_NecroticPlague() Spell(festering_strike text=extend)
    if Unholy_FesteringStrike_Use() Spell(festering_strike)
}

AddFunction Unholy_Rotation_SoulReaper_Use
{
    if Unholy_BloodTap_Use_SoulReaper() Spell(blood_tap)
    if Unholy_SoulReaper_Use() Spell(soul_reaper_unholy)
}

AddFunction Unholy_Rotation_SingleTarget
{
    Spell(dark_transformation)
    if Diseases_UnholyBlight_Use() Spell(unholy_blight)
    if Unholy_BreathOfSindragosa_Use() Spell(breath_of_sindragosa)
    if Unholy_PlagueLeech_Use_Outbreak() Spell(plague_leech)
    if Unholy_SoulReaper_Use() Unholy_Rotation_SoulReaper_Use()
    if Unholy_Gargoyle_Use() Spell(summon_gargoyle)
    if Diseases_Missing() Unholy_Rotation_Diseases_Apply()
    if Unholy_FesteringStrike_Use() Unholy_Rotation_FesteringStrike_Use()
    Spell(scourge_strike)
    if Unholy_BloodTap_Use() Spell(blood_tap)
    if Unholy_DeathCoil_Use() Spell(death_coil)
}

AddFunction Unholy_Rotation_Cleave
{
    Spell(dark_transformation)
    if Diseases_UnholyBlight_Use() Spell(unholy_blight)
    if Unholy_BreathOfSindragosa_Use() Spell(breath_of_sindragosa)
    if Unholy_PlagueLeech_Use_Outbreak() Spell(plague_leech)
    if Unholy_SoulReaper_Use() Unholy_Rotation_SoulReaper_Use()
    if Unholy_Gargoyle_Use() Spell(summon_gargoyle)
    if Diseases_Missing() Unholy_Rotation_Diseases_Apply()
    if Unholy_FesteringStrike_Use() Unholy_Rotation_FesteringStrike_Use()
    if BloodBoil_Use() Spell(blood_boil)
    Spell(scourge_strike)
    if Unholy_BloodTap_Use() Spell(blood_tap)
    if Unholy_DeathCoil_Use() Spell(death_coil)
}

AddFunction Unholy_Rotation_AOE
{
    Spell(dark_transformation)
    if Diseases_UnholyBlight_Use() Spell(unholy_blight)
    if Unholy_BreathOfSindragosa_Use() Spell(breath_of_sindragosa)
    Spell(plague_leech)
    if Unholy_SoulReaper_Use() Unholy_Rotation_SoulReaper_Use()
    if Unholy_Gargoyle_Use() Spell(summon_gargoyle)
    if Diseases_Missing() Unholy_Rotation_Diseases_Apply()
    if Unholy_FesteringStrike_Use() Unholy_Rotation_FesteringStrike_Use()
    if BloodBoil_Use() Spell(blood_boil)
    Spell(blood_boil)
    if Unholy_BloodTap_Use() Spell(blood_tap)
    if Unholy_DeathCoil_Use() Spell(death_coil)
}

###
### Unholy - Main
###
AddFunction Unholy_ShortCD
{
    MeleeRange_Use()
    if Diseases_Missing() Spell(unholy_blight)
    if Defile_Use() Spell(defile)
    if Unholy_DeathAndDecay_Use() Spell(death_and_decay)
}

AddFunction Unholy_Main
{
    if Talent(breath_of_sindragosa_talent) and BreathOfSindragosa_Rotation_Use() Unholy_Rotation_BreathOfSindragosa()
    if not BreathOfSindragosa_Rotation_Use()
	{
        if Enemies() <= 1 Unholy_Rotation_SingleTarget()
        if Enemies() >= 2 and Enemies() < 4 Unholy_Rotation_Cleave()
        if Enemies() >= 4 Unholy_Rotation_AOE()
	}
}

AddFunction Unholy_CD
{
    InterruptActions_Use()
    if LunaEclipse_Potion_Strength_Use() and Unholy_Potion_Use() Item(draenic_strength_potion)
    Spell(blood_fury_ap)
    Spell(berserking)
    Spell(arcane_torrent_runicpower)
    LunaEclipse_Rotation_ItemActions_Use()
	if Unholy_Gargoyle_Use() Spell(summon_gargoyle)
    if EmpowerRuneWeapon_Use() Spell(empower_rune_weapon)
}

###
### Unholy - Precombat
###
AddFunction Unholy_PrecombatShortCD
{
    MeleeRange_Use()
    if Diseases_Missing() Spell(unholy_blight)
    Spell(summon_gargoyle)
    if Defile_Use() Spell(defile)
    if Unholy_DeathAndDecay_Use() Spell(death_and_decay)
}

AddFunction Unholy_Precombat
{
    if HornOfWinter_Use() Spell(horn_of_winter)
    Spell(unholy_presence)
    if target.Classification(worldboss) Spell(army_of_the_dead)
}

AddFunction Unholy_PrecombatCD
{
    Spell(army_of_the_dead)
    if LunaEclipse_Potion_Strength_Use() Item(draenic_strength_potion)
}
]];

    OvaleScripts:RegisterScript("DEATHKNIGHT", "unholy", name, desc, code, "include");
end