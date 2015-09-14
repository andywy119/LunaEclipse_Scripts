local OvaleScripts = LunaEclipseScripts.Ovale.OvaleScripts;

do
    local name = "lunaeclipse_common";
    local desc = "[6.2] LunaEclipse: Common Hunter Functions";
    local code = [[
# Hunter rotation functions based on Azortharions Hunter Guide:  https://goo.gl/Ks7kPX

Include(ovale_hunter_spells)

Include(lunaeclipse_global)
Include(lunaeclipse_beastmastery)
Include(lunaeclipse_marksmanship)
Include(lunaeclipse_survival)

Define(focus_fire 82692)
    SpellRequire(focus_fire unusable 1=pet_buff,!pet_frenzy_buff 2=buff,focus_fire_buff)
    SpellAddBuff(focus_fire focus_fire_buff=1)
    SpellAddPetBuff(focus_fire pet_frenzy_buff=0)

Define(pet_frenzy_buff 19615)
    SpellInfo(pet_frenzy_buff duration=30 max_stacks=5)

Define(steady_shot 56641)
    SpellInfo(steady_shot focus=-14)
    SpellInfo(steady_shot replace=cobra_shot level=81 specialization=beast_mastery,survival)
    SpellInfo(steady_shot replace=focusing_shot_marksmanship talent=focusing_shot_talent specialization=marksmanship)
    SpellInfo(steady_shot replace=focusing_shot talent=focusing_shot_talent specialization=beast_mastery,survival)

Define(exotic_munitions_talent 19)
Define(steady_focus_talent 10)

AddCheckBox(opt_multishot "Multi-shot Focus Dump" specialization=beast_mastery)
AddCheckBox(opt_trap_launcher "Show: Trap Launcher" default)
AddCheckBox(opt_stampede "Main Icons: Show Stampede" default)
AddCheckBox(opt_beastial_wrath "Main Icons: Show Beastial Wrath" specialization=beast_mastery)

###
### Pet Functions
###
AddFunction Pet_Summon
{
    if pet.IsDead()
    {
        if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
        Spell(revive_pet)
    }
    if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
}

###
### Spell Functions
###
AddFunction ArcaneShot_Use
{
        ArcaneShot_Use_ThrillOfTheHunt()
     or BuffPresent(bestial_wrath_buff) 
     or Focus() >= 70
}

AddFunction ArcaneShot_Use_ThrillOfTheHunt
{
        BuffPresent(thrill_of_the_hunt_buff)
    and Focus() > 35
}

AddFunction Trap_Explosive_Use
{
        Enemies() > 1 
    and CheckBoxOn(opt_trap_launcher) 
    and not Glyph(glyph_of_explosive_trap)
}

AddFunction ExoticAmmunition_Incendiary_Use
{
        Talent(exotic_munitions_talent)
    and Enemies() < 3 
    and BuffRemaining(exotic_munitions_buff) < 1200
}

AddFunction ExoticAmmunition_Poison_Use
{
        Talent(exotic_munitions_talent)
    and Enemies() >= 3 
    and BuffRemaining(exotic_munitions_buff) < 1200
}

AddFunction Multishot_Use
{
        BuffPresent(bestial_wrath_buff) 
     or { 
                BuffPresent(thrill_of_the_hunt_buff)
            and Focus() > 40
        }
     or Focus() >= 70
}

AddFunction PowerShot_Use
{
        TimeToMaxFocus() > CastTime(powershot)
}

AddFunction SteadyFocus_Apply
{
        Talent(steady_focus_talent)
    and not Talent(focusing_shot_talent)
    and {
                PreviousSpell(cobra_shot)
             or PreviousSpell(steady_shot)
        }
    and {
                not BuffPresent(steady_focus_buff)
             or BuffRemaining(steady_focus_buff) <= CastTime(steady_shot)
        } 
    and 14 + FocusCastingRegen(steady_shot) <= FocusDeficit()
}

###
### General Functions
###
AddFunction Rotation_Focus_Build
{
    Spell(focusing_shot_marksmanship)
    Spell(focusing_shot)
    Spell(cobra_shot)
    Spell(steady_shot)
}

AddFunction Rotation_SteadyFocus_Build
{
    Spell(cobra_shot text=steady)
    Spell(steady_shot text=steady)
}

AddFunction InterruptActions_Use
{
    if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
    {
        Spell(counter_shot)
        if not target.Classification(worldboss)
        {
            Spell(arcane_torrent_focus)
            if target.InRange(quaking_palm) Spell(quaking_palm)
            Spell(war_stomp)
        }
    }
}
]];

    OvaleScripts:RegisterScript("HUNTER", nil, name, desc, code, "include");
end