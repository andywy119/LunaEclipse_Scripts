local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_unholy";
	local desc = "[6.2] LunaEclipse: Skullflower's Unholy Rotations";
	local code = [[
# Death Knight rotation functions based on Skullflowers Guide:  http://summonstone.com/deathknight/unholy/

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
		and target.DebuffRemaining(necrotic_plague_debuff) <= 15
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
		    BuffStacks(blood_charge_buff) >= 5
		and {
			    Rune(unholy) == 0
			 or {
			 	    Rune(blood) <= 1
			 	and Rune(frost) <= 1
			    }
		    }
	    }
}

AddFunction Unholy_BloodTap_Use_SoulReaper
{
	    BuffStacks(blood_charge_buff) >= 5
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

AddFunction Unholy_DarkTransformation_Use
{
	    BuffStacks(shadow_infusion_buff) >= 5
}		

AddFunction Unholy_DeathAndDecay_Use
{
	    Enemies() >= 2 
	and target.TimeToDie() >= 5
	and Rune(unholy) >= 2
}

AddFunction Unholy_DeathCoil_CrazedMonstrosity
{
	    ArmorSetBonus(T18 4)
	and not BuffPresent(crazed_monstrosity_buff)
}
		
AddFunction Unholy_DeathCoil_Use
{
	    BuffStacks(blood_charge_buff) <= 10
	and {
		    BuffPresent(sudden_doom_buff)
		 or {
			    ArmorSetBonus(T18 4)
			and {
				    {
					    BuffPresent(crazed_monstrosity_buff)
					and BuffRemaining(crazed_monstrosity_buff) <= 5
					and RunicPower() > 95
				    }
		 		 or {
					    BuffPresent(crazed_monstrosity_buff)
					and BuffRemaining(crazed_monstrosity_buff) > 5
					and RunicPower() > 80
				    }
				 or {
					    not BuffPresent(crazed_monstrosity_buff)
					and RunicPower() > 80
		    		    }
		    	    }
	    	    }
		 or {
			    not ArmorSetBonus(T18 4)
			and RunicPower() > 80
		    }
	    }
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
	 or target.HealthPercent() - 5 * { target.HealthPercent() / target.TimeToDie() } <= 45
}

###
### Breath of Sindragosa Rotation
###
AddFunction Unholy_Rotation_BreathOfSindragosa
{
	if Unholy_DarkTransformation_Use() Spell(dark_transformation)
	if Diseases_Missing() Unholy_Rotation_Diseases_Apply()
	if Unholy_FesteringStrike_Use() Spell(festering_strike)
	Spell(scourge_strike)
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
	if Diseases_UnholyBlight_Use() Spell(unholy_blight)
	if Diseases_Outbreak_Use() Spell(outbreak)
	if Unholy_PlagueStrike_Use_Diseases() Spell(plague_strike)
}

AddFunction Unholy_Rotation_SingleTarget
{
	if Unholy_DarkTransformation_Use() Spell(dark_transformation)
	if Unholy_DeathCoil_CrazedMonstrosity() Spell(death_coil)
	if Diseases_UnholyBlight_Use() Spell(unholy_blight)
	if Diseases_Outbreak_Use() Spell(outbreak)
	if Unholy_BreathOfSindragosa_Use() Spell(breath_of_sindragosa)
	if Unholy_PlagueLeech_Use_Outbreak() Spell(plague_leech)
	if Unholy_BloodTap_Use_SoulReaper() Spell(blood_tap)
	if Unholy_SoulReaper_Use() Spell(soul_reaper_unholy)
	if Unholy_Gargoyle_Use() Spell(summon_gargoyle)
	if Diseases_Missing() Unholy_Rotation_Diseases_Apply()
	if Unholy_FesteringStrike_Use_NecroticPlague() Spell(festering_strike text=extend)
	if Unholy_FesteringStrike_Use() Spell(festering_strike)
	Spell(scourge_strike)
	if Unholy_BloodTap_Use() Spell(blood_tap)
	if Unholy_DeathCoil_Use() Spell(death_coil)
}

AddFunction Unholy_Rotation_DualTarget
{
	if Unholy_DarkTransformation_Use() Spell(dark_transformation)
	if Unholy_DeathCoil_CrazedMonstrosity() Spell(death_coil)
	if Diseases_UnholyBlight_Use() Spell(unholy_blight)
	if Diseases_Outbreak_Use() Spell(outbreak)
	if Unholy_BreathOfSindragosa_Use() Spell(breath_of_sindragosa)
	if Unholy_PlagueLeech_Use_Outbreak() Spell(plague_leech)
	if Unholy_BloodTap_Use_SoulReaper() Spell(blood_tap)
	if Unholy_SoulReaper_Use() Spell(soul_reaper_unholy)
	if Unholy_Gargoyle_Use() Spell(summon_gargoyle)
	if Diseases_Missing() Unholy_Rotation_Diseases_Apply()
	if Unholy_FesteringStrike_Use_NecroticPlague() Spell(festering_strike text=extend)
	if Unholy_FesteringStrike_Use() Spell(festering_strike)
	if BloodBoil_Use() Spell(blood_boil)
	Spell(scourge_strike)
	if Unholy_BloodTap_Use() Spell(blood_tap)
	if Unholy_DeathCoil_Use() Spell(death_coil)
}

AddFunction Unholy_Rotation_AOE
{
	if Unholy_DarkTransformation_Use() Spell(dark_transformation)
	if Unholy_DeathCoil_CrazedMonstrosity() Spell(death_coil)
	if Diseases_UnholyBlight_Use() Spell(unholy_blight)
	if Diseases_Outbreak_Use() Spell(outbreak)
	if Unholy_BreathOfSindragosa_Use() Spell(breath_of_sindragosa)
	if PlagueLeech_Use() Spell(plague_leech)
	if Unholy_BloodTap_Use_SoulReaper() Spell(blood_tap)
	if Unholy_SoulReaper_Use() Spell(soul_reaper_unholy)
	if Unholy_Gargoyle_Use() Spell(summon_gargoyle)
	if Diseases_Missing() Unholy_Rotation_Diseases_Apply()
	if Unholy_FesteringStrike_Use_NecroticPlague() Spell(festering_strike text=extend)
	if Unholy_FesteringStrike_Use() Spell(festering_strike)
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
		if Enemies() == 2 Unholy_Rotation_DualTarget()
		if Enemies() >= 3 Unholy_Rotation_AOE()
	}
}

AddFunction Unholy_CD
{
	InterruptActions_Use()
	if Potion_Use() LunaEclipse_Potion_Strength_Use()
	Spell(blood_fury_ap)
	Spell(berserking)
	Spell(arcane_torrent_runicpower)
	LunaEclipse_Rotation_ItemActions_Use()
	if EmpowerRuneWeapon_Use() Spell(empower_rune_weapon)
}

###
### Unholy - Precombat
###
AddFunction Unholy_PrecombatShortCD
{
	MeleeRange_Use()
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
	LunaEclipse_Potion_Strength_Use()
}
]];

	OvaleScripts:RegisterScript("DEATHKNIGHT", "unholy", name, desc, code, "include");
end
