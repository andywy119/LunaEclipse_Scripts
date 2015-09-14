local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "lunaeclipse_survival";
    local desc = "[6.2] LunaEclipse: Azortharion's Survival Rotation";
    local code = [[
# Hunter rotation functions based on Azortharions Hunter Guide:  https://goo.gl/Ks7kPX

###
### Spell Functions
###
AddFunction Survival_Stampede_Use
{
        BuffPresent(burst_haste_buff any=1) 
     or {
                {
                        { 
                                Talent(stampede_talent) 
                            and SpellCooldown(stampede) < GCD()
                        }
                     or {
                                BuffPresent(trinket_stat_any_buff)
 					         or BuffPresent(legendary_ring_buff)
                             or BuffStacks(trinket_stacking_proc_any_buff) > 6
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
AddFunction Survival_SerpentSting_Apply
{
    target.DebuffRemaining(serpent_sting_debuff) < 3
}

###
### Item Functions
###
AddFunction Survival_Potion_Use
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
                                {
                                        BuffPresent(trinket_stat_any_buff)
 					                 or BuffPresent(legendary_ring_buff)
                                     or BuffStacks(trinket_stacking_proc_any_buff) > 6
                                }
                            and target.HealthPercent() <= 20
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
### Survival - Rotations
###
AddFunction Survival_Rotation_Priority
{
    if CheckBoxOn(opt_stampede) and target.Classification(worldboss) and Survival_Stampede_Use() Spell(stampede)
}

AddFunction Survival_Rotation_SingleTarget
{
    Spell(black_arrow)
    Spell(explosive_shot)
    if ArcaneShot_Use_ThrillOfTheHunt() Spell(arcane_shot) 		
    if PowerShot_Use() Spell(powershot)
    Spell(a_murder_of_crows)
    Spell(dire_beast)
    if ArcaneShot_Use() Spell(arcane_shot)
}

AddFunction Survival_Rotation_DualTarget
{
    if Survival_SerpentSting_Apply() Spell(multishot)
    Spell(barrage)	
    Spell(black_arrow)
    Spell(explosive_shot)
    if PowerShot_Use() Spell(powershot)
    Spell(a_murder_of_crows)
    Spell(dire_beast)
    if ArcaneShot_Use() Spell(arcane_shot)
}

AddFunction Survival_Rotation_AOE
{
    if Survival_SerpentSting_Apply() Spell(multishot)
    Spell(barrage)	
    Spell(black_arrow)
    Spell(explosive_shot)
    if PowerShot_Use() Spell(powershot)
    Spell(a_murder_of_crows)
    Spell(dire_beast)
    if Multishot_Use() Spell(multishot)
}

###
### Survival - Main
###
AddFunction Survival_ShortCD
{
    if Trap_Explosive_Use() Spell(explosive_trap)
}

AddFunction Survival_Main
{
    Survival_Rotation_Priority()
    if Enemies() == 1 Survival_Rotation_SingleTarget()
    if Enemies() == 2 Survival_Rotation_DualTarget()
    if Enemies() >= 3 Survival_Rotation_AOE()
    Rotation_Focus_Build()
}

AddFunction Survival_CD
{
    InterruptActions_Use()
    if LunaEclipse_Potion_Agility_Use() and Survival_Potion_Use() Item(draenic_agility_potion) 
    LunaEclipse_Rotation_ItemActions_Use()
    if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
    Spell(blood_fury_ap)
    Spell(berserking)
    if Survival_Stampede_Use() Spell(stampede)
}

###
### Survival - Precombat
###
AddFunction Survival_PrecombatShortCD
{
    if not Talent(lone_wolf_talent) Pet_Summon()
}

AddFunction Survival_Precombat
{
    if ExoticAmmunition_Poison_Use() Spell(poisoned_ammo)
    if ExoticAmmunition_Incendiary_Use() < 1200 Spell(incendiary_ammo)
    if CheckBoxOn(opt_stampede) and target.Classification(worldboss) and Survival_Stampede_Use() Spell(stampede)
    Spell(explosive_shot)
    Spell(black_arrow)
    Spell(powershot)
    Spell(barrage)	
}

AddFunction Survival_PrecombatCD
{
    if LunaEclipse_Potion_Agility_Use() Item(draenic_agility_potion)
    Spell(stampede)
}
]];

    OvaleScripts:RegisterScript("HUNTER", "survival", name, desc, code, "include");
end