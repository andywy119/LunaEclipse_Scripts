local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
	local name = "lunaeclipse_global";
	local desc = "[6.1] LunaEclipse: Global Functions";
	local code = [[
# Global functions shared by all classes and specializations.

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)

AddCheckBox(opt_single_target "Display: Single Target Icon")
AddCheckBox(opt_enemies_tagged "Tagged Enemies Only")
AddCheckBox(opt_potion "Show: Potions" default)
AddCheckBox(opt_interrupt "Show: Interrupts" default)

Define(exhaustion_debuff 57723)
Define(fatigued_debuff 160455)
Define(insanity_debuff 95809)
Define(sated_debuff 57724)
Define(temporal_displacement_debuff 80354)

SpellList(burst_haste_debuff exhaustion_debuff fatigued_debuff insanity_debuff sated_debuff temporal_displacement_debuff)

###
### Potion Functions
###
AddFunction LunaEclipse_Potion_Agility_Use
{
	if CheckBoxOn(opt_potion) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction LunaEclipse_Potion_Intellect_Use
{
	if CheckBoxOn(opt_potion) and target.Classification(worldboss) Item(draenic_intellect_potion usable=1)
}

AddFunction LunaEclipse_Potion_Strength_Use
{
	if CheckBoxOn(opt_potion) and target.Classification(worldboss) Item(draenic_strength_potion usable=1)
}

###
### Item Functions
###
AddFunction LunaEclipse_LegendaryRing_Buff_Present
{
	   BuffPresent(archmages_greater_incandescence_agi_buff)
	or BuffPresent(archmages_greater_incandescence_int_buff)
	or BuffPresent(archmages_greater_incandescence_str_buff)
	or BuffPresent(archmages_incandescence_agi_buff)
	or BuffPresent(archmages_incandescence_int_buff)
	or BuffPresent(archmages_incandescence_str_buff)
}

AddFunction LunaEclipse_Rotation_ItemActions_Use
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}
]];

	OvaleScripts:RegisterScript(nil, nil, name, desc, code, "include");
end


