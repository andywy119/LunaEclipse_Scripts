local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_frost";
	local desc = "[6.2] LunaEclipse: Skullflower's Frost Rotations";
	local code = [[
# Death Knight rotation functions based on Skullflowers Guide:  http://summonstone.com/deathknight/frost/

###
### Disease Functions
###
AddFunction Frost_Diseases_Missing_BloodPlague
{
	    not Talent(necrotic_plague_talent) 
	and not target.DebuffPresent(blood_plague_debuff) 
}

AddFunction Frost_Diseases_Missing_FrostFever
{
	    { 
		    Talent(necrotic_plague_talent) 
		and SpellCooldown(unholy_blight) > GCD()
		and SpellCooldown(outbreak) > GCD()
		and not target.DebuffPresent(necrotic_plague_debuff) 
	    }
	 or { 
	 	    not Talent(necrotic_plague_talent) 
	 	and not target.DebuffPresent(frost_fever_debuff) 
	    }
}

AddFunction Frost_HowlingBlast_Use_Diseases
{
	    UnholyBlight_NotActive()
	and Frost_Diseases_Missing_FrostFever()
}

AddFunction Frost_PlagueStrike_Use_Diseases
{
	    UnholyBlight_NotActive()
	and Frost_Diseases_Missing_BloodPlague()
}

###
### Spell Functions
###
AddFunction Frost_BloodTap_Use
{
	    BuffStacks(blood_charge_buff) >= 10
}

AddFunction Frost_BloodTap_Use_Obliterate
{
	    BuffStacks(blood_charge_buff) >= 10
	 or {	
		    BuffStacks(blood_charge_buff) >= 5
		and Frost_Obliterate_Use()	
		and {
			    Rune(frost) < 1
			 or Rune(unholy) < 1
		    }
	    }
}

AddFunction Frost_BloodTap_Use_SoulReaper
{
	    BuffStacks(blood_charge_buff) >= 5
	and Frost_SoulReaper_Use()	
	and Rune(frost) < 1
}

AddFunction Frost_DeathAndDecay_Use
{
	    Enemies() >= 3 
	and HasWeapon(offhand)
}

AddFunction Frost_FrostStrike_Use
{
	    BuffPresent(killing_machine_buff) 
}

AddFunction Frost_HowlingBlast_Use
{
	    BuffPresent(rime_buff)
}

AddFunction Frost_Obliterate_Use
{
	    {
		    {
			    HasWeapon(offhand)
			and {
				    Rune(unholy) >= 2 
				 or {
					     BuffPresent(killing_machine_buff) 
					 and RunicPower() < 25
			            }
		    	    }
		    }
		 or {
			    not HasWeapon(offhand)
			and {
	    			    BuffPresent(killing_machine_buff) 
				 or Rune(unholy) >= 2
				 or {
					    { 
						     Rune(unholy) >= 1.8
						 and Rune(frost) >= 1.8
					    }
					 or Rune(death) >= 1.8
				    }
			    }
		    }
	    }
}

AddFunction Frost_PlagueLeech_Use
{
	    {
		    Runes_Available_PlagueLeech()
		and not BuffPresent(killing_machine_buff)
		and target.DiseasesTicking()
    	    }
    	 or {
		    Runes_Available_PlagueLeech()
		and BuffPresent(killing_machine_buff)
		and Diseases_Expiring()
	    } 
}

AddFunction Frost_SoulReaper_Use
{
	    target.HealthPercent() <= 35 
	 or target.HealthPercent() - 5 * { target.HealthPercent() / target.TimeToDie() } <= 35
}

###
### Frost Rotations
###
AddFunction Frost_Rotation_Diseases_Apply
{
	if Diseases_UnholyBlight_Use() Spell(unholy_blight)
	if Diseases_Outbreak_Use() Spell(outbreak)
	if Frost_PlagueStrike_Use_Diseases() Spell(plague_strike)
	if Frost_HowlingBlast_Use_Diseases() Spell(howling_blast)
}

###
### Dual Weild Rotations
###
AddFunction Frost_Rotation_DualWield_Normal
{
	if Frost_PlagueLeech_Use() Spell(plague_leech)
	if Frost_BloodTap_Use_SoulReaper() Spell(blood_tap)
	if Frost_SoulReaper_Use() Spell(soul_reaper_frost)
	if Diseases_Missing() Frost_Rotation_Diseases_Apply()
	if Frost_FrostStrike_Use() Spell(frost_strike)
	if Frost_Obliterate_Use() Spell(obliterate)
	Spell(howling_blast)
	if Frost_BloodTap_Use() Spell(blood_tap)
	Spell(frost_strike)
}

AddFunction Frost_Rotation_DualWield_Cleave
{
	if Frost_PlagueLeech_Use() Spell(plague_leech)
	if Diseases_Missing() Frost_Rotation_Diseases_Apply()
	if BloodBoil_Use() Spell(blood_boil)
	if Frost_FrostStrike_Use() Spell(frost_strike)
	if Frost_Obliterate_Use() Spell(obliterate)
	Spell(howling_blast)
	if Frost_BloodTap_Use() Spell(blood_tap)
	Spell(frost_strike)
}

###
### 2-Handed Rotations
###
AddFunction Frost_Rotation_TwoHanded_Normal
{
	if Frost_PlagueLeech_Use() Spell(plague_leech)
	if Frost_BloodTap_Use_SoulReaper() Spell(blood_tap)
	if Frost_SoulReaper_Use() Spell(soul_reaper_frost)
	if Frost_HowlingBlast_Use() Spell(howling_blast)
	if Frost_BloodTap_Use_Obliterate() Spell(blood_tap)
	if Frost_Obliterate_Use() Spell(obliterate)
	if Frost_BloodTap_Use() Spell(blood_tap)
	if Diseases_Missing() Frost_Rotation_Diseases_Apply()
	Spell(frost_strike)
	if PlagueLeech_Use() Spell(plague_leech)
}

AddFunction Frost_Rotation_TwoHanded_Cleave
{
	if PlagueLeech_Use() Spell(plague_leech)
	if Frost_BloodTap_Use_SoulReaper() Spell(blood_tap)
	if Frost_SoulReaper_Use() Spell(soul_reaper_frost)
	Spell(howling_blast)
	if Frost_BloodTap_Use_Obliterate() Spell(blood_tap)
	if Frost_Obliterate_Use() Spell(obliterate)
	if Frost_BloodTap_Use() Spell(blood_tap)
	if Diseases_Missing() Frost_Rotation_Diseases_Apply()
	if BloodBoil_Use() Spell(blood_boil)
	Spell(frost_strike)
	Spell(plague_leech)
}

###
### Frost - Main
###
AddFunction Frost_ShortCD
{
	MeleeRange_Use()
	Spell(pillar_of_frost)
	if Diseases_Missing() Spell(unholy_blight)
	if Defile_Use() Spell(defile)
	if Frost_DeathAndDecay_Use() Spell(death_and_decay)
}

AddFunction Frost_Main
{
	if HasWeapon(offhand)
	{
		if Enemies() >= 3 Frost_Rotation_DualWield_Cleave()
		if Enemies() < 3 Frost_Rotation_DualWield_Normal()
	}
	if not HasWeapon(offhand)
	{
		if Enemies() >= 4 Frost_Rotation_TwoHanded_Cleave()
		if Enemies() < 4 Frost_Rotation_TwoHanded_Normal()
	}
}

AddFunction Frost_CD
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
### Frost - Precombat
###
AddFunction Frost_PrecombatShortCD
{
	Spell(pillar_of_frost)
}

AddFunction Frost_Precombat
{
	if HornOfWinter_Use() Spell(horn_of_winter)
	Spell(frost_presence)
	if target.Classification(worldboss) Spell(army_of_the_dead)
}

AddFunction Frost_PrecombatCD
{
	Spell(army_of_the_dead)
	LunaEclipse_Potion_Strength_Use()
}
]];

	OvaleScripts:RegisterScript("DEATHKNIGHT", "frost", name, desc, code, "include");
end
