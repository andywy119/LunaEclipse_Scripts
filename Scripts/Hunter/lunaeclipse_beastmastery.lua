local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "lunaeclipse_beastmastery";
    local desc = "[6.2] LunaEclipse: Azortharion's Beast Mastery Rotation";
    local code = [[
# Hunter rotation functions based on Azortharions Hunter Guide:  https://goo.gl/Ks7kPX

###
### Pet Functions
###
AddFunction BeastMastery_BeastialWrath_Use
{
        not BuffPresent(bestial_wrath_buff) 
    and SpellCooldown(kill_command) < GCD()
    and Focus() > 60
}

AddFunction BeastMastery_KillCommand_Use
{
        pet.Present() 
    and not pet.IsIncapacitated() 
    and not pet.IsFeared() 
    and not pet.IsStunned()
}

###
### Spell Functions
###
AddFunction BeastMastery_Stampede_Use
{
        BuffPresent(burst_haste_buff any=1) 
     or {
                {
                        { 
                                Talent(stampede_talent) 
                            and SpellCooldown(stampede) < GCD()
                        }
                     or {
                                BuffPresent(bestial_wrath_buff) 
                            and {
                                        BuffPresent(focus_fire_buff)
                                     or BuffPresent(trinket_stat_any_buff)
 					                 or BuffPresent(legendary_ring_buff)
                                     or BuffStacks(trinket_stacking_proc_any_buff) > 6
                                }
                        }
                }
            and {
                        DebuffPresent(burst_haste_debuff)
                     or {
                                not DebuffPresent(burst_haste_debuff)
                            and target.TimeToDie() > 305
                        }
                }
        }
	 or target.TimeToDie() <= 40
}

###
### Shot Functions
###
AddFunction BeastMastery_FocusFire_Apply
{
        not BuffPresent(focus_fire_buff) 
    and {
                pet.BuffPresent(pet_frenzy_buff) 
            and {
                        pet.BuffRemaining(pet_frenzy_buff) <= 3
                     or { 
                                pet.BuffStacks(pet_frenzy_buff) == 5 
                            and not BuffPresent(bestial_wrath_buff) 
                            and { 
                                        SpellCooldown(bestial_wrath) <= 10
                                     or SpellCooldown(bestial_wrath) >= 20
                                }
                        }
                     or {
                                BuffPresent(bestial_wrath_buff)
                            and {
                                        BuffRemaining(bestial_wrath_buff) > 3
                                     or Focus() < 14
                                }
                        }	
                     or {
                                Talent(stampede_talent) 
                            and TimeSincePreviousSpell(stampede) < 40
                        }
                     or not SpellCooldown(bestial_wrath)
                }
        }	    	    
}

###
### Item Functions
###
AddFunction BeastMastery_Potion_Use
{
        BuffPresent(burst_haste_buff any=1) 
     or {
 			    DebuffPresent(burst_haste_debuff)
			and {
                        { 
                                Talent(stampede_talent) 
                            and SpellCooldown(stampede) < GCD()
                            and target.TimeToDie() < 300
                        }
                     or {
                                BuffPresent(bestial_wrath_buff) 
                            and {
                                        BuffPresent(focus_fire_buff)
                                     or BuffPresent(trinket_stat_any_buff)
 					                 or BuffPresent(legendary_ring_buff)
                                     or BuffStacks(trinket_stacking_proc_any_buff) > 6
                                }
                            and target.HealthPercent() <= 35
                        }
                     or target.TimeToDie() <= 25
                }
        }
     or {
                not DebuffPresent(burst_haste_debuff)
            and target.TimeToDie() <= 25
        }
}

###
### Beast Mastery - Rotations
###
AddFunction BeastMastery_Rotation_Priority
{
    if CheckBoxOn(opt_stampede) and target.Classification(worldboss) and BeastMastery_Stampede_Use() Spell(stampede)
}

AddFunction BeastMastery_Rotation_SingleTarget
{
    if BeastMastery_FocusFire_Apply() Spell(focus_fire)
    if CheckBoxOn(opt_beastial_wrath) and BeastMastery_BeastialWrath_Use() Spell(bestial_wrath)
    if BeastMastery_BeastialWrath_Use() or BeastMastery_KillCommand_Use Spell(kill_command)
    Spell(kill_shot)
    Spell(dire_beast)
    Spell(a_murder_of_crows)
    Spell(barrage)
    if SteadyFocus_Apply() Rotation_SteadyFocus_Build()
    if ArcaneShot_Use() Spell(arcane_shot)
}

AddFunction BeastMastery_Rotation_DualTarget
{
    Spell(barrage)
    if pet.BuffExpires(pet_beast_cleave_buff) Spell(multishot)
    if BeastMastery_FocusFire_Apply() Spell(focus_fire)
    if CheckBoxOn(opt_beastial_wrath) and BeastMastery_BeastialWrath_Use() Spell(bestial_wrath)
    if BeastMastery_BeastialWrath_Use() or BeastMastery_KillCommand_Use Spell(kill_command)
    Spell(kill_shot)
    Spell(dire_beast)
    Spell(a_murder_of_crows)
    if SteadyFocus_Apply() Rotation_SteadyFocus_Build()
    if ArcaneShot_Use() Spell(arcane_shot)
}

AddFunction BeastMastery_Rotation_AOE
{
    Spell(barrage)
    if pet.BuffExpires(pet_beast_cleave_buff) Spell(multishot)
    if BeastMastery_FocusFire_Apply() Spell(focus_fire)
    if CheckBoxOn(opt_beastial_wrath) and BeastMastery_BeastialWrath_Use() Spell(bestial_wrath)
    if BeastMastery_BeastialWrath_Use() or BeastMastery_KillCommand_Use Spell(kill_command)
    Spell(kill_shot)
    Spell(dire_beast)
    Spell(a_murder_of_crows)
    if SteadyFocus_Apply() Rotation_SteadyFocus_Build()
    if CheckBoxOn(opt_multishot) and Multishot_Use() Spell(multishot)
    if not CheckBoxOn(opt_multishot) and ArcaneShot_Use() Spell(arcane_shot)
}

###
### Beast Mastery - Main
###
AddFunction BeastMastery_ShortCD
{
    if BeastMastery_BeastialWrath_Use() Spell(bestial_wrath)
    if Trap_Explosive_Use() Spell(explosive_trap)
}

AddFunction BeastMastery_Main
{
    BeastMastery_Rotation_Priority()
    if Enemies() <= 1 BeastMastery_Rotation_SingleTarget()
    if Enemies() == 2 BeastMastery_Rotation_DualTarget()
    if Enemies() >= 3 BeastMastery_Rotation_AOE()
    Rotation_Focus_Build()
}

AddFunction BeastMastery_CD
{
    InterruptActions_Use()
    if LunaEclipse_Potion_Agility_Use() and BeastMastery_Potion_Use() Item(draenic_agility_potion)
    LunaEclipse_Rotation_ItemActions_Use()
    if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
    Spell(blood_fury_ap)
    Spell(berserking)
    if BeastMastery_Stampede_Use() Spell(stampede)
}

###
### Beast Mastery - Precombat
###
AddFunction BeastMastery_PrecombatShortCD
{
    Pet_Summon()
}

AddFunction BeastMastery_Precombat
{
    if ExoticAmmunition_Poison_Use() Spell(poisoned_ammo)
    if ExoticAmmunition_Incendiary_Use() < 1200 Spell(incendiary_ammo)
    if CheckBoxOn(opt_beastial_wrath) and BeastMastery_BeastialWrath_Use() Spell(bestial_wrath)
    if BeastMastery_BeastialWrath_Use() or BeastMastery_KillCommand_Use Spell(kill_command)
    if CheckBoxOn(opt_stampede) and target.Classification(worldboss) and BeastMastery_Stampede_Use() Spell(stampede)
    Spell(barrage)
}

AddFunction BeastMastery_PrecombatCD
{
    if LunaEclipse_Potion_Agility_Use() Item(draenic_agility_potion)
    Spell(stampede)
}
]];

    OvaleScripts:RegisterScript("HUNTER", "beast_mastery", name, desc, code, "include");
end