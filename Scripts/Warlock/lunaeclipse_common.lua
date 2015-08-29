local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_common";
	local desc = "[6.1] LunaEclipse: Common Warlock Functions";
	local code = [[
# Warlock rotation functions based on Zagams Guide:  http://www.darkintentions.net/

Include(ovale_warlock_spells)

Include(lunaeclipse_global)
Include(lunaeclipse_affliction)
Include(lunaeclipse_demonology)
Include(lunaeclipse_destruction)

Define(dark_soul_knowledge_buff 113861)
	SpellInfo(dark_soul_knowledge_buff duration=20)
	SpellInfo(dark_soul_knowledge_buff duration=10 glyph=glyph_of_dark_soul)

Define(dark_soul_misery_buff 113860)
	SpellInfo(dark_soul_misery_buff duration=20)
	SpellInfo(dark_soul_misery_buff duration=10 glyph=glyph_of_dark_soul)

Define(service_doomguard 157900)
	SpellInfo(service_doomguard cd=120 sharedcd=service_pet)
	SpellInfo(service_doomguard unusable=1 talent=!demonic_servitude_talent)

Define(service_felguard 111898)
	SpellInfo(service_felguard cd=120 sharedcd=service_pet)

Define(service_felhunter 111897)
	SpellInfo(service_felhunter cd=120 sharedcd=service_pet)
	
AddCheckBox(opt_demons "Main Icons: Show Demon Summons" default)

###
### Demon Functions
###
AddFunction Demon_Summon
{
	if not Talent(demonic_servitude_talent) 
	{
		if not pet.Present() Spell(summon_felhunter)
		if Talent(grimoire_of_sacrifice_talent) and pet.Present() Spell(grimoire_of_sacrifice)
	}
	if Talent(demonic_servitude_talent) and not pet.Present() Spell(summon_doomguard)
}

AddFunction Demon_Major_Summon
{
	if not Talent(demonic_servitude_talent)
	{
		if Enemies() < 9 Spell(summon_doomguard)
		if Enemies() >= 9 Spell(summon_infernal)
	}
}

AddFunction Demon_Major_Use
{
	    BuffPresent(burst_haste_buff any=1)
	 or {
		    not DebuffPresent(burst_haste_debuff)
		and {
			    {
				    BuffPresent(dark_soul_instability_buff)
				 or BuffPresent(dark_soul_knowledge_buff)
				 or BuffPresent(dark_soul_misery_buff)
			    }
			and {
				    BuffPresent(trinket_stat_any_buff)
				 or BuffStacks(trinket_stacking_proc_any_buff) > 6
	 		 	 or LunaEclipse_LegendaryRing_Buff_Present()
			    }
		    }
		and target.TimeToDie() > 605
	    }
	 or {
		    DebuffPresent(burst_haste_debuff)
		and {
			    {
				    BuffPresent(dark_soul_instability_buff)
				 or BuffPresent(dark_soul_knowledge_buff)
				 or BuffPresent(dark_soul_misery_buff)
			    }
			and {
				    BuffPresent(trinket_stat_any_buff)
				 or BuffStacks(trinket_stacking_proc_any_buff) > 6
	 		 	 or LunaEclipse_LegendaryRing_Buff_Present()
			    }
		    }
	    }
	 or {
	 	    target.HealthPercent() <= 20
	 	 or target.TimeToDie() <= 25
	    }
}

AddFunction Demon_Service_Summon
{
	if not Talent(demonic_servitude_talent)
	{
		Spell(service_felguard)
		Spell(service_felhunter)
	}
	if Talent(demonic_servitude_talent) Spell(service_doomguard)
}

AddFunction Demon_Service_Use
{
	    Talent(grimoire_of_service_talent) 
	and {
		    BuffPresent(burst_haste_buff any=1)
		 or {
			    {
				    BuffPresent(dark_soul_instability_buff)
				 or BuffPresent(dark_soul_knowledge_buff)
				 or BuffPresent(dark_soul_misery_buff)
			    }
			and {
				    BuffPresent(trinket_stat_any_buff)
				 or BuffStacks(trinket_stacking_proc_any_buff) > 6
	 		 	 or LunaEclipse_LegendaryRing_Buff_Present()
			    }
			and target.TimeToDie() >= 120
		    }
		 or {
			    target.HealthPercent() <= 20
			 or target.TimeToDie() <= 25 
		    }
	    }
}

###
### Item Functions
###
AddFunction Potion_Use
{
		not PotionCombatLockdown(draenic_intellect_potion)
	and {
		    BuffPresent(burst_haste_buff any=1)
		 or {
			    DebuffPresent(burst_haste_debuff)
			and {
				    {
					    BuffPresent(dark_soul_instability_buff)
					 or BuffPresent(dark_soul_knowledge_buff)
					 or BuffPresent(dark_soul_misery_buff)
				    }
				 or {
					    BuffPresent(trinket_stat_any_buff)
					 or BuffStacks(trinket_stacking_proc_any_buff) > 6
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

###
### General Functions
###
AddFunction InterruptActions_Use
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_mana)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}
]];

	OvaleScripts:RegisterScript("WARLOCK", nil, name, desc, code, "include");
end
