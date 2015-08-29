local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_demonology";
	local desc = "[6.1] LunaEclipse: Zagam's Demonology Rotation";
	local code = [[
# Warlock rotation functions based on Zagams Guide:  http://www.darkintentions.net/61-demonology-warlock-guide.html

###
### Demon Functions
###
AddFunction Demonology_Demon_AOE_Use
{
	    Enemies() >= 2
	and {
		    pet.Present() 
		and {
			    pet.CreatureFamily(Felguard)
			 or pet.CreatureFamily(Wrathguard)
		    }
	    }

}

AddFunction Demonology_Demon_Summon
{
	if not Talent(demonic_servitude_talent) and not pet.Present() Spell(summon_felguard)
	if Talent(demonic_servitude_talent) and not pet.Present() Spell(summon_doomguard)
}

AddFunction Demonology_ImpSwarm_Use
{
	    Glyph(glyph_of_imp_swarm) 
	and TimeInCombat() > 3 
	and { 
		   BuffPresent(dark_soul_knowledge_buff) 
		or SpellCooldown(dark_soul_knowledge) > 120 / { 1 / { 100 / { 100 + SpellHaste() } } } 
		or target.TimeToDie() < 32
	    }
}

###
### Metamorphosis Functions
###
AddFunction Demonology_Metamorphosis_Apply
{
	     { 
	     	    not Demonology_Corruption_Apply() 
	     	and not Demonology_HandOfGuldan_Apply()
	     }
	 and { 
	 	    { 
	 		    BuffPresent(dark_soul_knowledge_buff)
	 		and BuffRemaining(dark_soul_knowledge_buff) > 5
	 		and DemonicFury() >= Demonology_DarkSoul_DemonicFury_Remaining()
	 	    }
	 	 or Demonology_DarkSoul_Use()
	  	 or {
	  	 	    BuffPresent(trinket_proc_any_buff) 
	  	 	and DemonicFury() > 250 + { 20 * BaseDuration(dark_soul_knowledge_buff) } 
	  	    }
	  	 or { 
	  	 	    Talent(demonbolt_talent)
	  	 	and not BuffPresent(demonbolt_buff)
	  	 	and DemonicFury() > 500
	  	    }
	  	 or { 
	  	 	    Talent(cataclysm_talent)
	  	 	and Enemies() >= 2 
	  	 	and not SpellCooldown(cataclysm)
	  	    }
	  	 or {
	  	 	    not target.DebuffPresent(doom_debuff)
	  	 	and target.TimeToDie() >= 30 / { 1 / { 100 / { 100 + SpellHaste() } } } 
	  	 	and DemonicFury() > 300
	  	    }
	  	 or DemonicFury() / { 80 * ExecuteTime(soul_fire) } >= target.TimeToDie()
	  	 or DemonicFury() >= 950
	     }
}

AddFunction Demonology_Metamorphosis_Cancel
{
	    not Demonology_Doom_Apply()
	and not BuffPresent(dark_soul_knowledge_buff)
	and not BuffPresent(trinket_proc_any_buff) 
	and DemonicFury() / { 80 * ExecuteTime(soul_fire) } < target.TimeToDie()
	and {
		    {
	  	 	    Talent(demonbolt_talent)
	  	 	and BuffStacks(demonbolt_buff) >= 2
		 	and DemonicFury() < 200 + { 20 * BaseDuration(dark_soul_knowledge_buff) }
	  	    }
		 or {
	  	 	    not Talent(demonbolt_talent)
		 	and DemonicFury() < 200 + { 20 * BaseDuration(dark_soul_knowledge_buff) }
		    }
	    }		 	    
}

###
### Dark Soul Demonic Fury Functions
###
AddFunction Demonology_DarkSoul_DemonicFury_Remaining
{
	80 * BuffStacks(molten_core_buff) + { 40 * { BuffRemaining(dark_soul_knowledge_buff) - { ExecuteTime(soul_fire) * BuffStacks(molten_core_buff) } } / GCD() }	
}

AddFunction Demonology_DarkSoul_DemonicFury_Required
{
	80 * BuffStacks(molten_core_buff) + { 40 * { BaseDuration(dark_soul_knowledge_buff) - { ExecuteTime(soul_fire) * BuffStacks(molten_core_buff) } } / GCD() }
}

###
### Hand of Guldan Functions
###
AddFunction Demonology_HandOfGuldan_Apply
{
	   { 
	   	    not target.DebuffPresent(shadowflame_debuff)
	   	and Charges(hand_of_guldan) > 1
	   }
	or { 
		    not target.DebuffPresent(shadowflame_debuff) 
		and Charges(hand_of_guldan) == 1 
		and SpellChargeCooldown(hand_of_guldan) < { BaseDuration(shadowflame_debuff) - { 0.3 * BaseDuration(shadowflame_debuff) } - TravelTime(hand_of_guldan) }
	   }
}

AddFunction Demonology_HandOfGuldan_Refresh
{
	   { 
		    target.DebuffPresent(shadowflame_debuff)
		and target.DebuffRemaining(shadowflame_debuff) < { { 0.3 * BaseDuration(shadowflame_debuff) } + TravelTime(hand_of_guldan) } 
		and not InFlightToTarget(hand_of_guldan)
	   }
}

AddFunction Demonology_Rotation_HandOfGuldan_Use
{
	    target.DebuffPresent(shadowflame_debuff)
	and target.DebuffStacks(shadowflame_debuff) == 1
	and {
		Charges(hand_of_guldan) >= 1 
		or SpellChargeCooldown(hand_of_guldan) < { BaseDuration(shadowflame_debuff) - { 0.3 * BaseDuration(shadowflame_debuff) } - TravelTime(hand_of_guldan) }
	    }
}

###
### Spell Functions
###
AddFunction Demonology_ChaosWave_Use
{
	    { 
	   	    BuffPresent(dark_soul_knowledge_buff) 
	   	and Enemies() >= 2
	    } 
	 or { 
		    ArmorSetBonus(T17 4) == 0 
	        and Charges(chaos_wave) == 2
	   	and Enemies() >= 2
	    }
	 or {
	 	    Charges(chaos_wave) == 3 
	   	and Enemies() >= 2
	    }
}

AddFunction Demonology_Corruption_Apply
{
	    target.TimeToDie() >= 6 
	and target.DebuffRemaining(corruption_debuff) <= 0.3 * BaseDuration(corruption_debuff)
}

AddFunction Demonology_DarkSoul_Use
{
	    not BuffPresent(dark_soul_knowledge_buff) 
	and {
		   { 
		    	    { 
		    	            Charges(dark_soul_knowledge) == 1 
		    	    	 or { 
		    	    	 	    not Talent(archimondes_darkness_talent) 
		    	    	 	and SpellCooldown(dark_soul_knowledge) <= GCD()
		    		    } 
		    	    }
			and DemonicFury() >= Demonology_DarkSoul_DemonicFury_Required()
		   }
		or { 
			    Talent(archimondes_darkness_talent)
			and Charges(dark_soul_knowledge) == 2
			and DemonicFury() >= 300
		   }
	    }
}

AddFunction Demonology_DemonBolt_DemonicFury_Consume
{
	    BuffPresent(dark_soul_knowledge_buff)
	 or {
		    BuffStacks(demonbolt_buff) >= 2
		and DemonicFury() >= 200 + { 20 * BaseDuration(dark_soul_knowledge_buff) }
	    }
}

AddFunction Demonology_DemonBolt_Use
{
	    BuffStacks(demonbolt_buff) < 2 
}

AddFunction Demonology_Doom_Apply
{
	    not Casting(cataclysm)
	and target.TimeToDie() >= 30 * { 100 / { 100 + SpellHaste() } } 
	and target.DebuffRemaining(doom_debuff) <= 0.3 * BaseDuration(doom_debuff) 
	and DemonicFury() >= 60
}

AddFunction Demonology_ImmolationAura_Use
{
	    BuffPresent(metamorphosis_buff)
	and { 
	    	    {
	    	    	    not BuffPresent(immolation_aura_buff) 
	    	 	 or BuffExpires(immolation_aura_buff) 
	    	    }
	    	and Enemies() >= 3 
	    }
	and { 
		    {
		    	    not BuffPresent(dark_soul_knowledge_buff)
			and DemonicFury() > 250 + Demonology_DarkSoul_DemonicFury_Required()
	    	    }
	 	 or { 
	 	    	    BuffPresent(dark_soul_knowledge_buff) 
	 		and DemonicFury() > 250 + Demonology_DarkSoul_DemonicFury_Remaining()
	    	    }
	    }
}
AddFunction Demonology_LifeTap_Use
{
	    ManaPercent() < 40
	and BuffExpires(dark_soul_knowledge_buff)
}

AddFunction Demonology_SoulFire_Use
{
  	    { 
  	    	    not BuffPresent(metamorphosis_buff)
   		and { 
   			    BuffPresent(molten_core_buff) 
   			and { 
   			   	    BuffStacks(molten_core_buff) >= 8 
				 or { 
					    BuffPresent(demonic_synergy_buff) 
					and BuffRemaining(demonic_synergy_buff) > ExecuteTime(soul_fire)
				    }
				 or Talent(demonbolt_talent)
		    	    }
	    	    }
	    }
	 or { 
	 	    BuffPresent(metamorphosis_buff) 
	 	and {
	 		    BuffPresent(molten_core_buff)
	 		 or DemonicFury() / { 80 * ExecuteTime(soul_fire) } >= target.TimeToDie()
	 	    }
	    }
}

###
### Demonology - Rotations
###
AddFunction Demonology_Rotation_Demon_AOE
{
	if pet.Present() 
	{
		if pet.CreatureFamily(Felguard) Spell(felguard_felstorm)
		if pet.CreatureFamily(Wrathguard)
		{
			Spell(wrathguard_wrathstorm)
			if SpellCooldown(wrathguard_wrathstorm) > 5 Spell(wrathguard_mortal_cleave)
		}
	}
}

AddFunction Demonology_Rotation_HandOfGuldan
{
	if Demonology_HandOfGuldan_Refresh() Spell(hand_of_guldan)
	if Demonology_LifeTap_Use() Spell(life_tap)
	if Demonology_Corruption_Apply() Spell(corruption)
	Spell(shadow_bolt)
}

###
### Demonology - Demonbolt Consume Rotations
###
AddFunction Demonology_Rotation_DemonBolt_Consume
{
	if Demonology_ImpSwarm_Use() Spell(imp_swarm)
	if Demonology_Demon_AOE_Use() Demonology_Rotation_Demon_AOE()
	if CheckBoxOn(opt_demons) and Demon_Service_Use() Demon_Service_Summon()
	if target.Classification(worldboss) and CheckBoxOn(opt_demons) and Demon_Major_Use() Demon_Major_Summon()
	if Demonology_ImmolationAura_Use() Spell(immolation_aura)
	if Demonology_Doom_Apply() Spell(doom)
	if BuffPresent(metamorphosis_buff) and Demonology_Metamorphosis_Cancel() Spell(metamorphosis text=cancel)
	if Demonology_DarkSoul_Use() Spell(dark_soul_knowledge)
	if Demonology_DemonBolt_Use()  Spell(demonbolt)
	if Demonology_DemonBolt_DemonicFury_Consume()
	{
		if DemonicFury() >= 80 and Demonology_ChaosWave_Use() Spell(chaos_wave)
		if DemonicFury() >= 160 and Demonology_SoulFire_Use() Spell(soul_fire)
		if DemonicFury() >= 40 Spell(touch_of_chaos)
	}
	Spell(imp_swarm)
	if Demonology_LifeTap_Use() Spell(life_tap)
}

###
### Demonology - Standard Build and Consume Rotations
###
AddFunction Demonology_Rotation_Build
{
	if Demonology_Rotation_HandOfGuldan_Use() Demonology_Rotation_HandOfGuldan()
	if Demonology_ImpSwarm_Use() Spell(imp_swarm)
	if Demonology_Demon_AOE_Use() Demonology_Rotation_Demon_AOE()
	if Demonology_LifeTap_Use() Spell(life_tap)
	if CheckBoxOn(opt_demons) and Demon_Service_Use() Demon_Service_Summon()
	if target.Classification(worldboss) and CheckBoxOn(opt_demons) and Demon_Major_Use() Demon_Major_Summon()
	if Demonology_HandOfGuldan_Apply() Spell(hand_of_guldan)
	if Demonology_Corruption_Apply() Spell(corruption)
	if not BuffPresent(metamorphosis_buff) and Demonology_Metamorphosis_Apply() Spell(metamorphosis)
	Spell(imp_swarm)
	if Demonology_SoulFire_Use() Spell(soul_fire)
	Spell(shadow_bolt)
	Spell(life_tap)
}

AddFunction Demonology_Rotation_Consume
{
	if Demonology_ImpSwarm_Use() Spell(imp_swarm)
	if Demonology_Demon_AOE_Use() Demonology_Rotation_Demon_AOE()
	if CheckBoxOn(opt_demons) and Demon_Service_Use() Demon_Service_Summon()
	if target.Classification(worldboss) and CheckBoxOn(opt_demons) and Demon_Major_Use() Demon_Major_Summon()
	if Enemies() >= 2 Spell(cataclysm)
	if Demonology_ImmolationAura_Use() Spell(immolation_aura)
	if Demonology_Doom_Apply() Spell(doom)
	if BuffPresent(metamorphosis_buff) and Demonology_Metamorphosis_Cancel() Spell(metamorphosis text=cancel)
	if Demonology_DarkSoul_Use() Spell(dark_soul_knowledge)
	if DemonicFury() >= 80 and Demonology_ChaosWave_Use() Spell(chaos_wave)
	if DemonicFury() >= 160 and Demonology_SoulFire_Use() Spell(soul_fire)
	if DemonicFury() >= 40 Spell(touch_of_chaos)
	Spell(imp_swarm)
	if Demonology_LifeTap_Use() Spell(life_tap)
}

###
### Demonology - Main
###
AddFunction Demonology_ShortCD
{
	if Demon_Service_Use() Demon_Service_Summon()
	if Enemies() >= 2 Spell(mannoroths_fury)
	Spell(kiljaedens_cunning)
	Spell(dark_soul_knowledge)
}

AddFunction Demonology_Main
{
	if Talent(demonbolt_talent) and BuffPresent(metamorphosis_buff) Demonology_Rotation_DemonBolt_Consume()
	if not Talent(demonbolt_talent) and BuffPresent(metamorphosis_buff) Demonology_Rotation_Consume()
	if not BuffPresent(metamorphosis_buff) Demonology_Rotation_Build()
}

AddFunction Demonology_CD
{
 	InterruptActions_Use()
	if Potion_Use() LunaEclipse_Potion_Intellect_Use()
	LunaEclipse_Rotation_ItemActions_Use()
	Spell(berserking)
	Spell(blood_fury_sp)
	Spell(arcane_torrent_mana)
	if Demonology_ImpSwarm_Use() Spell(imp_swarm)
	if Demon_Major_Use() Demon_Major_Summon()
}

###
### Demonology - Precombat
###
AddFunction Demonology_PrecombatShortCD
{
	Demonology_Demon_Summon()
}

AddFunction Demonology_Precombat
{
	if not BuffPresent(spell_power_multiplier_buff any=1) Spell(dark_intent)
	Spell(soul_fire)
}

AddFunction Demonology_PrecombatCD
{
	LunaEclipse_Potion_Intellect_Use()
}
]];

	OvaleScripts:RegisterScript("WARLOCK", "demonology", name, desc, code, "include");
end
