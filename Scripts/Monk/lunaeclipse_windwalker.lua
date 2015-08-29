local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_windwalker";
	local desc = "[6.1] LunaEclipse: Maximize's Windwalker Rotation";
	local code = [[
# Monk rotation based on Maximizes Guide:  http://summonstone.com/monk/windwalker/

AddCheckBox(opt_sef "Main Icons: Show Storm, Earth and Fire" specialization=windwalker)

###
### WindWalker - Brew Functions
###
AddFunction WindWalker_Brew_Chi_Use
{
	    Chi_Unactivated() >= 2
}

AddFunction WindWalker_Brew_Energizing_Use
{
	    SpellCooldown(fists_of_fury) > 6 
	and {
		    not Talent(serenity_talent) 
		 or {
		 	    Talent(serenity_talent) 
		 	and not BuffPresent(serenity_buff)
			and SpellCooldown(serenity) > 4
	    	    }
	    }
	and Energy_Starved()
}

AddFunction WindWalker_Brew_Fortifying_Use
{
	    target.Classification(worldboss)
	and WindWalker_TouchOfDeath_Use()
}

AddFunction WindWalker_Brew_Nimble_Use
{
	    IsFeared()
	 or IsRooted()
	 or IsStunned()
}

AddFunction WindWalker_Brew_TigerEye_Use
{
	    BuffExpires(tigereye_brew_use_buff) 
	and {
		    BuffStacks(tigereye_brew_buff) == 20
	 	 or {
			    {
				    BuffPresent(serenity_buff)
			    	 or {
					    BuffPresent(tiger_power_buff)
					and target.DebuffPresent(rising_sun_kick_debuff)
					and {
						    {
							    not SpellCooldown(fists_of_fury) > 0
							and Chi() >= 3
						    }
				 		 or {
							    Talent(hurricane_strike_talent) 
							and not SpellCooldown(hurricane_strike) > 0
							and Chi() >= 3
					    	    }
				    	    }
		    	    	    }
		    	    }
			and BuffStacks(tigereye_brew_buff) >= 9
	    	    }
		 or {
			    BuffPresent(tiger_power_buff)
			and target.DebuffPresent(rising_sun_kick_debuff)
			and Chi() >= 2
			and BuffStacks(tigereye_brew_buff) >= 16
	    	    }
    	    }	
}

###
### WindWalker - Spell Functions
###
AddFunction WindWalker_ChiBurst_Use
{
	    {
		    not Talent(serenity)
		 or {
			    Talent(serenity)
			and {
				    BuffExpires(serenity_buff)
				 or not BuffPresent(serenity_buff)
			    }
		    }
	    }
	and TimeToMaxEnergy() > 2
}

AddFunction WindWalker_ChiExplosion_Use
{
	    {
		    Enemies() <= 1
		and Chi() >= 3
    	    }
    	 or {
		    Enemies() >= 2
		and Chi() >= 4
	    }
}

AddFunction WindWalker_ChiTorpedo_Use
{
	    BuffPresent(burst_haste_buff any=1)
	 or {
		    {
			    BuffPresent(serenity_buff) 
			 or not Talent(serenity_talent)
		    }
		and {
			    BuffPresent(trinket_proc_agility_buff)
			 or BuffPresent(trinket_proc_multistrike_buff)
			 or LunaEclipse_LegendaryRing_Buff_Present()
		    }
	    }
}

AddFunction WindWalker_ExpelHarm_Use
{
	    player.HealthPercent() < 80
}

AddFunction WindWalker_FistsOfFury_Use
{
	    not BuffPresent(serenity_buff)
	and BuffRemaining(tiger_power_buff) > CastTime(fists_of_fury) 
	and target.DebuffRemaining(rising_sun_kick_debuff) > CastTime(fists_of_fury) 
	and TimeToMaxEnergy() > CastTime(fists_of_fury)
}

AddFunction WindWalker_RisingSunKick_Refresh
{
	    BuffRemaining(tiger_power_buff) < 3
}

AddFunction WindWalker_Serenity_Use
{
	    BuffPresent(tiger_power_buff)
	and target.DebuffPresent(rising_sun_kick_debuff)
	and Chi() >= 3 
	and Energy_Starved()
}

AddFunction WindWalker_StormEarthFire_Use
{
	    target.DebuffExpires(storm_earth_and_fire_target_debuff) 
	and { 
		    {
			    Enemies() == 2 
			and BuffStacks(storm_earth_and_fire_buff) < 1 
		    }
		 or {
			    Enemies() >= 3 
			and BuffStacks(storm_earth_and_fire_buff) < 2
		    }
    	    }
}

AddFunction WindWalker_TigersPalm_Refresh
{
	    BuffRemaining(tiger_power_buff) < 3
}

AddFunction WindWalker_TouchOfDeath_Use
{
	    not SpellCooldown(touch_of_death) > 0 
	and {
		   Glyph(glyph_of_touch_of_death)
		or Chi() >= 3
	    }
	and {
		   target.Health() < player.Health()
		or target.HealthPercent() < 10
    	    }
}

AddFunction WindWalker_ZenSphere_Use
{
	    not BuffPresent(zen_sphere_buff)
	and TimeToMaxEnergy() > 2
}

###
### Item Functions
###
AddFunction WindWalker_Potion_Use
{
	    not PotionCombatLockdown(draenic_agility_potion)
	and {
		    BuffPresent(burst_haste_buff any=1)
		 or {
			    DebuffPresent(burst_haste_debuff)
			and {
				    {
					    BuffPresent(serenity_buff) 
					 or not Talent(serenity_talent)
			    	    }
				 or {
					    BuffPresent(trinket_proc_agility_buff)
					 or BuffPresent(trinket_proc_multistrike_buff)
					 or LunaEclipse_LegendaryRing_Buff_Present()
				    }
			    }
		    }
		 or {
			    target.HealthPercent() <= 20
			 or target.TimeToDie() <= 25
		    }
	    }
}

AddFunction WindWalker_Racials_Use
{
	    BuffPresent(tigereye_brew_use_buff)
	 or target.TimeToDie() < 20
}

###
### WindWalker - Serenity Rotations
###
AddFunction WindWalker_Rotation_Serenity
{
	if target.Classification(worldboss) and WindWalker_TouchOfDeath_Use() Spell(touch_of_death)
	if CheckBoxOn(opt_sef) and WindWalker_StormEarthFire_Use() Spell(storm_earth_and_fire text=other)
	if CheckBoxOn(opt_xuen) and target.Classification(worldboss) Spell(invoke_xuen)
	if WindWalker_TigersPalm_Refresh() Spell(tiger_palm)
	if WindWalker_Brew_Chi_Use() Spell(chi_brew)
	if WindWalker_Serenity_Use() Spell(serenity)
	if CheckBoxOn(opt_brews) and WindWalker_Brew_TigerEye_Use() Spell(tigereye_brew)
	if WindWalker_FistsOfFury_Use() Spell(fists_of_fury)
	Spell(rising_sun_kick)
	Spell(blackout_kick)
	if WindWalker_ZenSphere_Use() Spell(zen_sphere)
	if Energy_Starved() Spell(chi_torpedo)
	if CheckBoxOn(opt_brews) and WindWalker_Brew_Energizing_Use() Spell(energizing_brew)
	if WindWalker_ExpelHarm_Use() Spell(expel_harm)
	Spell(jab)
}

###
### WindWalker - Standard Rotations
###
AddFunction WindWalker_Rotation_SingleTarget
{
	if target.Classification(worldboss) and WindWalker_TouchOfDeath_Use() Spell(touch_of_death)
	if CheckBoxOn(opt_xuen) and target.Classification(worldboss) Spell(invoke_xuen)
	if WindWalker_TigersPalm_Refresh() Spell(tiger_palm)
	if CheckBoxOn(opt_brews) and WindWalker_Brew_TigerEye_Use() Spell(tigereye_brew)
	if WindWalker_FistsOfFury_Use() Spell(fists_of_fury)
	Spell(rising_sun_kick)
	if WindWalker_ChiExplosion_Use() Spell(chi_explosion_melee)
	if CheckBoxOn(opt_brews) and WindWalker_Brew_Energizing_Use() Spell(energizing_brew)
	if WindWalker_ExpelHarm_Use() Spell(expel_harm)
	Spell(jab)	
}

AddFunction WindWalker_Rotation_Cleave
{
	if target.Classification(worldboss) and WindWalker_TouchOfDeath_Use() Spell(touch_of_death)
	if CheckBoxOn(opt_sef) and WindWalker_StormEarthFire_Use() Spell(storm_earth_and_fire text=other)
	if CheckBoxOn(opt_xuen) and target.Classification(worldboss) Spell(invoke_xuen)
	if WindWalker_TigersPalm_Refresh() Spell(tiger_palm)
	if WindWalker_RisingSunKick_Refresh() Spell(rising_sun_kick)
	if CheckBoxOn(opt_brews) and WindWalker_Brew_TigerEye_Use() Spell(tigereye_brew)
	if WindWalker_FistsOfFury_Use() Spell(fists_of_fury)
	if WindWalker_ChiExplosion_Use() Spell(chi_explosion_melee)
	if CheckBoxOn(opt_chi_burst) and WindWalker_ChiBurst_Use() Spell(chi_burst)
	if Energy_Starved() Spell(chi_torpedo)
	if CheckBoxOn(opt_brews) and WindWalker_Brew_Energizing_Use() Spell(energizing_brew)
	if WindWalker_ExpelHarm_Use() Spell(expel_harm)
	Spell(jab)
}

AddFunction WindWalker_Rotation_AOE
{
	if target.Classification(worldboss) and WindWalker_TouchOfDeath_Use() Spell(touch_of_death)
	if CheckBoxOn(opt_sef) and WindWalker_StormEarthFire_Use() Spell(storm_earth_and_fire text=other)
	if CheckBoxOn(opt_xuen) and target.Classification(worldboss) Spell(invoke_xuen)
	if WindWalker_TigersPalm_Refresh() Spell(tiger_palm)
	if WindWalker_RisingSunKick_Refresh() Spell(rising_sun_kick)
	if WindWalker_ChiTorpedo_Use() Spell(chi_torpedo)
	if not Energy_Starved() Spell(spinning_crane_kick)
	if CheckBoxOn(opt_brews) and WindWalker_Brew_TigerEye_Use() Spell(tigereye_brew)
	if WindWalker_FistsOfFury_Use() Spell(fists_of_fury)
	if WindWalker_ChiExplosion_Use() Spell(chi_explosion_melee)
	if CheckBoxOn(opt_chi_burst) and WindWalker_ChiBurst_Use() Spell(chi_burst)
	if Energy_Starved() Spell(chi_torpedo)
	if CheckBoxOn(opt_brews) and WindWalker_Brew_Energizing_Use() Spell(energizing_brew)
	if WindWalker_ExpelHarm_Use() Spell(expel_harm)
	Spell(jab)
}

###
### WindWalker - Main
###
AddFunction WindWalker_ShortCD
{
	if Enemies() >= 2 and WindWalker_StormEarthFire_Use() Spell(storm_earth_and_fire text=other)
	if WindWalker_Brew_TigerEye_Use() Spell(tigereye_brew)
	if WindWalker_Serenity_Use() Spell(serenity)
	if Enemies() >= 2 and WindWalker_ChiBurst_Use() Spell(chi_burst)
	if WindWalker_Brew_Energizing_Use() Spell(energizing_brew)
}

AddFunction WindWalker_Main
{
	if Talent(serenity) WindWalker_Rotation_Serenity()
	if not Talent(serenity)
	{
		if Enemies() <= 1 WindWalker_Rotation_SingleTarget()
		if Enemies() >= 2 and Enemies() < 5 WindWalker_Rotation_Cleave()
		if Enemies() >= 5 WindWalker_Rotation_AOE()
	}
}

AddFunction WindWalker_CD
{
 	InterruptActions_Use()
	if WindWalker_Brew_Nimble_Use() Spell(nimble_brew)
	if WindWalker_Potion_Use() LunaEclipse_Potion_Agility_Use()
	if WindWalker_Racials_Use()
	{
		LunaEclipse_Rotation_ItemActions_Use()
		Spell(blood_fury_apsp)
		Spell(berserking)
		if Chi_Unactivated() >= 1 Spell(arcane_torrent_chi)
	}
	if WindWalker_Brew_Fortifying_Use() Spell(fortifying_brew)
	if WindWalker_TouchOfDeath_Use() Spell(touch_of_death)
	Spell(invoke_xuen)
}

###
### WindWalker - Precombat
###
AddFunction WindWalker_PrecombatShortCD
{
	MeleeRange_Use()
	if WindWalker_Brew_TigerEye_Use() Spell(tigereye_brew)
	if WindWalker_Serenity_Use() Spell(serenity)
	if WindWalker_Brew_Energizing_Use() Spell(energizing_brew)
}

AddFunction WindWalker_Precombat
{
	if not BuffPresent(str_agi_int_buff any=1) Spell(legacy_of_the_white_tiger)
	Spell(stance_of_the_fierce_tiger)
	if CheckBoxOn(opt_xuen) and target.Classification(worldboss) Spell(invoke_xuen)
	Spell(tiger_palm)
	Spell(jab)	
}

AddFunction WindWalker_PrecombatCD
{
	LunaEclipse_Potion_Agility_Use()
	Spell(invoke_xuen)
}
]];

	OvaleScripts:RegisterScript("MONK", "windwalker", name, desc, code, "include");
end
