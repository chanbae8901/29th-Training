/**
 * DOTT_training_fnc_initDefaultLoadouts
 *
 * Registers default ACE Arsenal loadouts for each faction.
 * Loadouts are SOP-correct Rifleman kits plus a Parade kit.
 * Sorted alphabetically in the Arsenal UI regardless of
 * array order here.
 *
 * Loadout Notes:
 *     1. Earplugs, Medical (15 Bandages, 5 Morphine, 1 PAK),
 *        IR Strobe in Uniform.
 *     2. 6 Non-Tracer + 3 Tracer rifle mags (1 loaded),
 *        2 Pistol mags (1 loaded), grenades (6 Frag,
 *        2 White Smoke, 1 Colored Smoke) in Vest then
 *        overflow to Backpack.
 *     3. NVGs, Entrenching Tool in Backpack.
 *     4. Map, Compass, Binoculars, Watch in link slots.
 *     Remove Insignia and Radio.
 *     SOP Accurate as of 8/19/2025.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     true
 *
 * Example:
 *     call DOTT_training_fnc_initDefaultLoadouts;
 */

/*
For consistency:
1. 	Earplugs, Medical (15 Bandages, 5 Morphine, 1 Personal Aid Kit), IR Strobe in Uniform
2. 	6 Non-Tracer Mags (1 inside), 3 Tracer Mags for Rifle, 2 Pistol Magazines (1 inside)
    and Grenades (6 Fragmentation, 2 White Smoke, 1 Colored Smoke) in Vest until full,
   	Backpack after such that minimum required is left in Vest if possible.
3.  NVGs, Entrenching Tool in Backpack.
4.  Map, Compass, Binoculars, and Watch in link slots.
Remember to remove Insignia and Radio
SOP Accurate as of 8/19/2025
*/

//Order doesn't matter, will be sorted alphabetically
//[Loadout Name (String), Exported Loadout (Array)]
private _loadouts =
[
    [
        "Parade",
        [[["rhs_weap_m1garand_sa43","","","",["rhsgref_8Rnd_762x63_Tracer_M1T_M1rifle",8],[],""],[],[],["29th_rhs_combat_uniform_ocp_retex",[["ACE_EarPlugs",1],["ACE_fieldDressing",3],["ACE_morphine",1],["rhsgref_8Rnd_762x63_Tracer_M1T_M1rifle",3,8]]],["29th_rhs_iotv_ocp_base_retex",[]],[],"r_Garrison_cap_qtr_crp_en","",[],["ItemMap","","TFAR_anprc152_9","ItemCompass","",""]],[]]
    ],
    [
        "BLUFOR Rifleman",
        [[["rhs_weap_m4a1_d","","","rhsusf_acc_compm4",["rhs_mag_30Rnd_556x45_M855A1_PMAG",30],[],""],[],["rhsusf_weap_m9","","","",["rhsusf_mag_15Rnd_9x19_FMJ",15],[],""],["29th_rhs_combat_uniform_ocp_retex",[["ACE_EarPlugs",1],["ACE_fieldDressing",15],["ACE_morphine",5],["ACE_personalAidKit",1],["ACE_MapTools",1],["ACE_IR_Strobe_Item",1]]],["29th_rhs_spcs_ocp_riefleman_retex",[["HandGrenade",4,1],["SmokeShell",2,1],["rhs_mag_30Rnd_556x45_M855A1_PMAG_Tan_Tracer_Red",3,30],["rhs_mag_30Rnd_556x45_M855A1_PMAG_Tan",5,30],["SmokeShellRed",1,1],["rhsusf_mag_15Rnd_9x19_FMJ",1,15]]],["29th_rhs_assault_eagleaiii_ucp_retex",[["rhsusf_ANPVS_15",1],["ACE_EntrenchingTool",1],["HandGrenade",2,1]]],"29th_rhs_ach_helmet_opc_retex","",["Binocular","","","",[],[],""],["ItemMap","","","ItemCompass","ItemWatch",""]],[]]
    ],
    [
        "OPFOR Rifleman",
        [[["rhs_weap_ak74m_camo","rhs_acc_dtk","","rhs_acc_pkas",["rhs_30Rnd_545x39_7N22_camo_AK",30],[],""],[],["rhs_weap_pya","","","",["rhs_mag_9x19_7n31_17",17],[],""],["rhs_uniform_emr_patchless",[["ACE_EarPlugs",1],["ACE_fieldDressing",15],["ACE_morphine",5],["ACE_personalAidKit",1],["ACE_MapTools",1],["ACE_IR_Strobe_Item",1]]],["rhs_6b45_rifleman",[["rhs_mag_rgd5",3,1],["rhs_30Rnd_545x39_7N22_camo_AK",4,30],["rhs_30Rnd_545x39_AK_plum_green",3,30],["rhs_mag_rdg2_white",2,1],["rhs_mag_rdg2_black",1,1]]],["rhs_assault_umbts",[["rhs_1PN138",1],["ACE_EntrenchingTool",1],["rhs_mag_rgd5",3,1],["rhs_30Rnd_545x39_7N22_camo_AK",1,30],["rhs_mag_9x19_7n31_17",1,17]]],"rhs_6b47_emr","",["Binocular","","","",[],[],""],["ItemMap","","","ItemCompass","ItemWatch",""]],[]]
    ],
    [
        "GRNFOR Rifleman",
        [[["rhs_weap_ak74n_2_npz","rhs_acc_dtk1983","","rhsusf_acc_eotech_xps3",["rhs_30Rnd_545x39_7N22_plum_AK",30],[],""],[],["rhsusf_weap_glock17g4","","","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["rhsgref_uniform_para_ttsko_urban",[["ACE_EarPlugs",1],["ACE_fieldDressing",15],["ACE_morphine",5],["ACE_personalAidKit",1],["ACE_MapTools",1],["ACE_IR_Strobe_Item",1]]],["rhssaf_vest_md99_woodland_rifleman",[["rhs_30Rnd_545x39_7N22_plum_AK",3,30],["rhs_mag_f1",1,1],["rhs_30Rnd_545x39_AK_plum_green",2,30],["rhssaf_mag_brd_m83_white",2,1],["rhssaf_mag_brd_m83_red",1,1]]],["rhssaf_kitbag_digital",[["ACE_EntrenchingTool",1],["rhsusf_ANPVS_14",1],["rhs_mag_f1",5,1],["rhs_30Rnd_545x39_7N22_plum_AK",2,30],["rhs_30Rnd_545x39_AK_plum_green",1,30],["rhsusf_mag_17Rnd_9x19_FMJ",1,17]]],"rhssaf_helmet_m97_woodland","",["Binocular","","","",[],[],""],["ItemMap","","","ItemCompass","ItemWatch",""]],[]]
    ],
    [
        "Insurgent Rifleman",
        //Fragmentation grenades subbed for TNT Grenades
        [[["rhs_weap_ak74n_2","rhs_acc_dtk1983","","",["rhs_30Rnd_545x39_7N10_plum_AK",30],[],""],[],["rhsusf_weap_glock17g4","","","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["rhs_uniform_bdu_erdl",[["ACE_EarPlugs",1],["ACE_fieldDressing",15],["ACE_morphine",5],["ACE_personalAidKit",1],["ACE_MapTools",1],["ACE_IR_Strobe_Item",1]]],["rhsgref_TacVest_ERDL",[["rhs_charge_tnt_x2_mag",1,1],["rhs_30Rnd_545x39_7N10_plum_AK",3,30],["rhs_30Rnd_545x39_AK_plum_green",3,30],["rhssaf_mag_brd_m83_white",2,1],["rhssaf_mag_brd_m83_red",1,1]]],["rhssaf_kitbag_digital",[["ACE_EntrenchingTool",1],["rhs_charge_tnt_x2_mag",5,1],["rhs_30Rnd_545x39_7N10_plum_AK",2,30],["rhsusf_mag_17Rnd_9x19_FMJ",1,17]]],"H_Shemag_olive","",["Binocular","","","",[],[],""],["ItemMap","","","ItemCompass","ItemWatch",""]],[]]
    ]
];

{
    private _loadoutName = _x select 0;
    private _unitLoadoutArray = _x select 1;
    [_loadoutName, _unitLoadoutArray, false] call ACE_arsenal_fnc_addDefaultLoadout;
} forEach _loadouts;

true
