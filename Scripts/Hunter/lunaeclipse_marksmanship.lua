local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_marksmanship";
	local desc = "[6.2] LunaEclipse: Azortharion's Marksmanship Rotation";
	local code = [[
# Hunter rotation functions based on Azortharions Hunter Guide:  https://goo.gl/Ks7kPX

###
### Shot Functions
###
AddFunction Marksmanship_CarefulAim_Active
{
	    BuffPresent(rapid_fire_buff)
	 or target.HealthPercent() > 80 
}

AddFunction Marksmanship_AimedShot_Use
{
	    { 
	    	    BuffPresent(thrill_of_the_hunt_buff)
	    	and Focus() + FocusCastingRegen(aimed_shot) > 45
	    }
	 or Focus() >= 70
}

###
### Marksmanship - Rotations
###
AddFunction Marksmanship_Rotation_Priority
{
 	if CheckBoxOn(opt_stampede) and target.Classification(worldboss) and Stampede_Use() Spell(stampede)
}

AddFunction Marksmanship_Rotation_General
{
	Spell(chimaera_shot)
    	Spell(kill_shot)    
        Spell(a_murder_of_crows)	
	Spell(glaive_toss)
	Spell(powershot)
	if Enemies() >= 2 Spell(barrage)
	if Marksmanship_CarefulAim_Active() or Marksmanship_AimedShot_Use() Spell(aimed_shot)
}

AddFunction Marksmanship_Rotation_AOE
{
	Spell(chimaera_shot)
    	Spell(kill_shot)    
        Spell(a_murder_of_crows)	
	Spell(glaive_toss)
	Spell(powershot)
	Spell(barrage)
	if Multishot_Use() Spell(multishot)
}

###
### Marksmanship - Main
###
AddFunction Marksmanship_ShortCD
{
        if Marksmanship_AimedShot_Use() Spell(rapid_fire)
	if Trap_Explosive_Use() Spell(explosive_trap)
}

AddFunction Marksmanship_Main
{
	Marksmanship_Rotation_Priority()
	if Enemies() < 7 Marksmanship_Rotation_General()
	if Enemies() >= 7 Marksmanship_Rotation_AOE()
	Rotation_Focus_Build()
}

AddFunction Marksmanship_CD
{
 	InterruptActions_Use()
	if Potion_Use() LunaEclipse_Potion_Agility_Use()
	LunaEclipse_Rotation_ItemActions_Use()
	if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
	Spell(blood_fury_ap)
	Spell(berserking)
        if Stampede_Use() Spell(stampede)
}

###
### Marksmanship - Precombat
###
AddFunction Marksmanship_PrecombatShortCD
{
	if not Talent(lone_wolf_talent) Pet_Summon()
}

AddFunction Marksmanship_Precombat
{
	if ExoticAmmunition_Poison_Use() Spell(poisoned_ammo)
	if ExoticAmmunition_Incendiary_Use() < 1200 Spell(incendiary_ammo)
	Spell(glaive_toss)
 	if CheckBoxOn(opt_stampede) and target.Classification(worldboss) and Stampede_Use() Spell(stampede)
	Spell(chimaera_shot)
}

AddFunction Marksmanship_PrecombatCD
{
	LunaEclipse_Potion_Agility_Use()
	Spell(stampede)
}
]];

	OvaleScripts:RegisterScript("HUNTER", "marksmanship", name, desc, code, "include");
end
