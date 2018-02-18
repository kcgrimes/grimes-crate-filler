/*
--Author: KC Grimes

--Script: Grimes' Crate Filler
--Version: V1.0

--Description: Old-fashioned Ammo Crate Refill script for ArmA 3, including all weapons, magazines, items, clothing, and bags.

--Instruction: 
1. Move/Copy file "G_crate.sqf" from this mission folder or the zip file into your mission folder
2. In the ArmA 3 editor, place the Supply Box (NATO) ammo crate found in the Empty -> Ammo section. 
3. In the crate's Init field, type the following command:
nul = [this] execVM "G_crate.sqf";

--Tips: 
-To keep an entity from spawning, simply comment it out by adding // at the beginning of the line (comment out)
-Read the extra comments if you are confused about something, or contact me on the forums or via e-mail
-Unfortunately as of the release of this script the crate sorting system in A3 isn't so great. Here's what you need to know.
All - Displays all items spawned into the crate
Weapons - Only weapons, launchers, and all bags (not vests)
Magazines - Only magazines, throwables, launchable, plantables, and all bags (not vests)
Items - Only attachments, gadgets, items, kits, hat/helmets, uniforms, vests, and all bags
This is why I suggest you keep the bag/uniform/vest/hat count low, as it is very cluttery. Sorry!
-Uniforms and vests have a commented number to the right of the classname. This indicates their capacity. Capacity for all bags was said to me 1 weapon, 13 magazines.
-Players can only wear uniforms of their faction
*/

if (!isServer) exitWith {};

//Begin Basic Parameters (edit these as described in the comments, defaults already chosen and active)
_Wpncount                = 10;   //Quantity of each weapon/launcher to be spawned
_Ammocount               = 50;   //Quantity of each type of ammunition/explosive to be spawned
_Itemcount               = 10;   //Quantity of each type of item (gadgets, attachments, etc)
_Clothingcount           = 3;   //Quantity of each type of uniform/hat/helmet/glasses (suggested to keep small due to not being stackable)
_Bagcount                = 3;   //Quantity of each type of bag/vest item (suggested to keep small due to not being stackable)
_Refresh                 = 600; //Amount of time until crate empties/refills (seconds)
//End Basic Parameters

//Begin Advanced Settings
//In the following options, enter 0 to exclude the items from the script, and enter 1 to include them, thus spawning them in the crate. Scroll to their section for more specific information.
//Default: All included except Preset bags, Glasses/Goggles, hats/helmets Uniforms
_NATO_Weapons              = 1; //All weapons seen as BLUFOR weapons
_OPFOR_Ind_Weapons         = 1; //All weapons seen as OPFOR and Independent weapons
_Mixed_Weapons             = 1; //All weapons found in BLUFOR, OPFOR, and Independent arsenals
_NATO_Ammo                 = 1; //All ammunition used by BLUFOR-specific weapons
_OPFOR_Ind_Ammo            = 1; //All ammunition used by OPFOR and Independent-specific weapons
_Mixed_Ammo                = 1; //All ammunition used by weapons found in BLUFOR, OPFOR, and Independent arsenals
_NATO_Launchers            = 1; //All rocket/missile launchers seen as BLUFOR launchers
_OPFOR_Ind_Launchers       = 1; //All rocket/missile launchers seen as OPFOR and Independent launchers
_NATO_Launcher_Ammo        = 1; //All ammunition used by BLUFOR rocket/missile launchers
_OPFOR_Ind_Launcher_Ammo   = 1; //All ammunition used by OPFOR and Independent rocket/missile launchers
_Plantable_Explosives      = 1; //All plantable explosive devices (mines, charges, etc.) (not sorted by faction)
_Grenade_Launcher_Ammo     = 1; //All grenade launcher ammo
_Throwables                = 1; //All throwable munitions (smokes, grenades, chemlights)
_Attachments               = 1; //All weapon attachments (not sorted by faction)
_Items                     = 1; //All items (gadgets, kits, binocs, rangefinder, laser designator, anything else on player that is not a bag or weapon)
_Hats_Helmets              = 0; //All hats and helmets
_Glasses_Goggles           = 0; //All glasses and goggles (currently doesn't show)
_BLUFOR_Uniforms           = 0; //All BLUFOR uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_OPFOR_Uniforms            = 0; //All OPFOR uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_Independent_Uniforms      = 0; //All Independent uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_Civilian_Uniforms         = 0; //All Civilian uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_Guerilla_Uniforms         = 0; //All "OG" uniforms, which are hit and miss for who can wear them, but mostly follow the name's indication (too many exceptions to split)
_Other_Uniforms            = 0; //All Other uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_Vests                     = 1; //All vests and chest rigs
_Bags                      = 1; //All bags
_Preset_Bags               = 0; //All preset bags (normal bags containing a preset of items, such as First Aid Kits and Explosives, which are already found elsewhere in the crate)
_Test_bed                  = 0; //Location to place any items to be tested for dev purposes (Keep off unless in specific use)
//End Advanced Settings

_crate = _this select 0;

while {alive _crate} do
{

clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

//NATO Weapons
if (_NATO_Weapons == 1) then {
_crate addWeaponCargoGlobal ["arifle_MX_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_MX_GL_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_MXC_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_MXM_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_MX_SW_F", _Wpncount];
_crate addWeaponCargoGlobal ["srifle_EBR_F", _Wpncount];
_crate addWeaponCargoGlobal ["srifle_LRR_F", _Wpncount];
_crate addWeaponCargoGlobal ["SMG_01_F", _Wpncount];
_crate addWeaponCargoGlobal ["hgun_P07_F", _Wpncount];
_crate addWeaponCargoGlobal ["hgun_Pistol_heavy_01_F", _Wpncount];
};

//OPFOR/Independent Weapons
if (_OPFOR_Ind_Weapons == 1) then {
_crate addWeaponCargoGlobal ["arifle_Katiba_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_Katiba_C_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_Katiba_GL_F", _Wpncount];
_crate addWeaponCargoGlobal ["srifle_GM6_F", _Wpncount];
_crate addWeaponCargoGlobal ["srifle_DMR_01_F", _Wpncount];
_crate addWeaponCargoGlobal ["LMG_Zafir_F", _Wpncount];
_crate addWeaponCargoGlobal ["SMG_02_F", _Wpncount];
_crate addWeaponCargoGlobal ["hgun_PDW2000_F", _Wpncount];
_crate addWeaponCargoGlobal ["hgun_rook40_F", _Wpncount];
_crate addWeaponCargoGlobal ["hgun_Pistol_heavy_02_F", _Wpncount];
};

//Mixed B/O weapons
if (_Mixed_Weapons == 1) then {
_crate addWeaponCargoGlobal ["LMG_Mk200_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_TRG20_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_TRG21_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_TRG21_GL_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_Mk20_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_Mk20_plain_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_Mk20C_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_Mk20C_plain_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_Mk20_GL_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_Mk20_GL_plain_F", _Wpncount];
_crate addWeaponCargoGlobal ["arifle_SDAR_F", _Wpncount];
_crate addWeaponCargoGlobal ["hgun_ACPC2_F", _Wpncount];
};

//NATO Ammo
if (_NATO_Ammo == 1) then {
_crate addMagazineCargoGlobal ["30Rnd_65x39_Caseless_mag", _Ammocount];
_crate addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag_Tracer", _Ammocount];
_crate addMagazineCargoGlobal ["100Rnd_65x39_Caseless_mag", _Ammocount];
_crate addMagazineCargoGlobal ["100Rnd_65x39_caseless_mag_Tracer", _Ammocount];
_crate addMagazineCargoGlobal ["20Rnd_762x51_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["7Rnd_408_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["30Rnd_45ACP_Mag_SMG_01", _Ammocount];
_crate addMagazineCargoGlobal ["30Rnd_45ACP_Mag_SMG_01_tracer_green", _Ammocount];
_crate addMagazineCargoGlobal ["11Rnd_45ACP_Mag", _Ammocount];
};

//OPFOR/Independent Ammo
if (_OPFOR_Ind_Ammo == 1) then {
_crate addMagazineCargoGlobal ["30Rnd_65x39_caseless_green", _Ammocount];
_crate addMagazineCargoGlobal ["30Rnd_65x39_caseless_green_mag_Tracer", _Ammocount];
_crate addMagazineCargoGlobal ["150Rnd_762x51_Box", _Ammocount];
_crate addMagazineCargoGlobal ["150Rnd_762x51_Box_Tracer", _Ammocount];
_crate addMagazineCargoGlobal ["5Rnd_127x108_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", _Ammocount];
_crate addMagazineCargoGlobal ["10Rnd_762x51_Mag", _Ammocount];
};

//Mixed B/O Ammo
if (_Mixed_Ammo == 1) then {
_crate addMagazineCargoGlobal ["200Rnd_65x39_cased_Box", _Ammocount];
_crate addMagazineCargoGlobal ["200RND_65x39_Cased_box_Tracer", _Ammocount];
_crate addMagazineCargoGlobal ["30RND_556x45_Stanag", _Ammocount];
_crate addMagazineCargoGlobal ["30Rnd_556x45_Stanag_Tracer_Red", _Ammocount];
_crate addMagazineCargoGlobal ["30Rnd_556x45_Stanag_Tracer_Green", _Ammocount];
_crate addMagazineCargoGlobal ["30Rnd_556x45_Stanag_Tracer_Yellow", _Ammocount];
_crate addMagazineCargoGlobal ["20Rnd_556x45_UW_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["9Rnd_45ACP_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["16Rnd_9x21_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["30Rnd_9x21_Mag", _Ammocount];
};

//NATO Launchers
if (_NATO_Launchers == 1) then {
_crate addWeaponCargoGlobal ["launch_NLAW_F", _Wpncount];
_crate addWeaponCargoGlobal ["launch_B_Titan_F", _Wpncount];
_crate addWeaponCargoGlobal ["launch_I_Titan_F", _Wpncount];
_crate addWeaponCargoGlobal ["launch_O_Titan_F", _Wpncount];
_crate addWeaponCargoGlobal ["launch_Titan_F", _Wpncount];
_crate addWeaponCargoGlobal ["launch_B_Titan_short_F", _Wpncount];
_crate addWeaponCargoGlobal ["launch_I_Titan_short_F", _Wpncount];
_crate addWeaponCargoGlobal ["launch_O_Titan_short_F", _Wpncount];
_crate addWeaponCargoGlobal ["launch_Titan_short_F", _Wpncount];
};

//OPFOR Launchers
if (_OPFOR_Ind_Launchers == 1) then {
_crate addWeaponCargoGlobal ["launch_RPG32_F", _Wpncount];
};

//NATO Launcher Ammo
if (_NATO_Launcher_Ammo == 1) then {
_crate addMagazineCargoGlobal ["NLAW_F", _Ammocount];
_crate addMagazineCargoGlobal ["Titan_AA", _Ammocount];
_crate addMagazineCargoGlobal ["Titan_AP", _Ammocount];
_crate addMagazineCargoGlobal ["Titan_AT", _Ammocount];
};

//OPFOR Launcher Ammo
if (_OPFOR_Ind_Launcher_Ammo == 1) then {
_crate addMagazineCargoGlobal ["RPG32_F", _Ammocount];
_crate addMagazineCargoGlobal ["RPG32_HE_F", _Ammocount];
};

//Plantable Explosives
if (_Plantable_Explosives == 1) then {
_crate addMagazineCargoGlobal ["ATMine_Range_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["APERSMine_Range_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["ClaymoreDirectionalMine_Remote_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["DemoCharge_Remote_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["APERSBoundingMine_Range_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["SLAMDirectionalMine_Wire_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["APERSTripMine_Wire_Mag", _Ammocount];
_crate addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", _Ammocount];
};

//Grenade launcher rounds
if (_Grenade_Launcher_Ammo == 1) then {
_crate addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["UGL_FlareWhite_F", _Ammocount];
_crate addMagazineCargoGlobal ["UGL_FlareGreen_F", _Ammocount];
_crate addMagazineCargoGlobal ["UGL_FlareRed_F", _Ammocount];
_crate addMagazineCargoGlobal ["UGL_FlareYellow_F", _Ammocount];
_crate addMagazineCargoGlobal ["UGL_FlareCIR_F", _Ammocount];
_crate addMagazineCargoGlobal ["1Rnd_Smoke_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["1Rnd_SmokeGreen_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["1Rnd_SmokeRed_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["1Rnd_SmokeYellow_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["1Rnd_SmokePurple_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["1Rnd_SmokeBlue_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["1Rnd_SmokeOrange_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_UGL_FlareWhite_F", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_UGL_FlareGreen_F", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_UGL_FlareRed_F", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_UGL_FlareYellow_F", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_UGL_FlareCIR_F", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_Smoke_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_SmokeRed_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_SmokeGreen_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_SmokeYellow_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_SmokePurple_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_SmokeBlue_Grenade_shell", _Ammocount];
_crate addMagazineCargoGlobal ["3Rnd_SmokeOrange_Grenade_shell", _Ammocount];
};

//Throwable grenades, smokes, chemlights
if (_Throwables == 1) then {
_crate addMagazineCargoGlobal ["SmokeShellRed", _Ammocount];
_crate addMagazineCargoGlobal ["SmokeShell", _Ammocount];
_crate addMagazineCargoGlobal ["SmokeShellGreen", _Ammocount];
_crate addMagazineCargoGlobal ["SmokeShellYellow", _Ammocount];
_crate addMagazineCargoGlobal ["SmokeShellPurple", _Ammocount];
_crate addMagazineCargoGlobal ["SmokeShellBlue", _Ammocount];
_crate addMagazineCargoGlobal ["SmokeShellOrange", _Ammocount];
_crate addMagazineCargoGlobal ["Chemlight_blue", _Ammocount];
_crate addMagazineCargoGlobal ["Chemlight_green", _Ammocount];
_crate addMagazineCargoGlobal ["Chemlight_red", _Ammocount];
_crate addMagazineCargoGlobal ["Chemlight_yellow", _Ammocount];
_crate addMagazineCargoGlobal ["HandGrenade", _Ammocount];
_crate addMagazineCargoGlobal ["HandGrenade_Stone", _Ammocount];
_crate addMagazineCargoGlobal ["MiniGrenade", _Ammocount];
_crate addMagazineCargoGlobal ["B_IR_Grenade", _Ammocount];
_crate addMagazineCargoGlobal ["O_IR_Grenade", _Ammocount];
_crate addMagazineCargoGlobal ["I_IR_Grenade", _Ammocount];
};

//Attachments
if (_Attachments == 1) then {
_crate addItemCargoGlobal ["muzzle_snds_H", _Itemcount]; 
_crate addItemCargoGlobal ["muzzle_snds_L", _Itemcount]; 
_crate addItemCargoGlobal ["muzzle_snds_B", _Itemcount]; 
_crate addItemCargoGlobal ["muzzle_snds_H_MG", _Itemcount]; 
_crate addItemCargoGlobal ["optic_Arco", _Itemcount]; 
_crate addItemCargoGlobal ["optic_Hamr", _Itemcount]; 
_crate addItemCargoGlobal ["optic_Aco", _Itemcount]; 
_crate addItemCargoGlobal ["optic_ACO_grn", _Itemcount]; 
_crate addItemCargoGlobal ["optic_Holosight", _Itemcount]; 
_crate addItemCargoGlobal ["acc_flashlight", _Itemcount]; 
_crate addItemCargoGlobal ["acc_pointer_IR", _Itemcount];
_crate addItemCargoGlobal ["optic_Aco_smg", _Itemcount];
_crate addItemCargoGlobal ["optic_ACO_grn_smg", _Itemcount];
_crate addItemCargoGlobal ["optic_Holosight_smg", _Itemcount];
_crate addItemCargoGlobal ["optic_SOS", _Itemcount];
_crate addItemCargoGlobal ["optic_MRCO", _Itemcount];
_crate addItemCargoGlobal ["muzzle_snds_M", _Itemcount];
_crate addItemCargoGlobal ["muzzle_snds_acp", _Itemcount];
_crate addItemCargoGlobal ["optic_tws", _Itemcount];
_crate addItemCargoGlobal ["optic_Nightstalker", _Itemcount];
_crate addItemCargoGlobal ["optic_NVS", _Itemcount];
_crate addItemCargoGlobal ["optic_LRPS", _Itemcount];
_crate addItemCargoGlobal ["optic_MRD", _Itemcount];
_crate addItemCargoGlobal ["optic_Yorris", _Itemcount];
_crate addItemCargoGlobal ["optic_DMS", _Itemcount];
};

//Items
if (_Items == 1) then {
_crate addWeaponCargoGlobal ["Binocular", _Itemcount];
_crate addItemCargoGlobal ["FirstAidKit", _Itemcount];
_crate addItemCargoGlobal ["ItemCompass", _Itemcount];
_crate addItemCargoGlobal ["ItemGPS", _Itemcount];
_crate addItemCargoGlobal ["ItemMap", _Itemcount];
_crate addItemCargoGlobal ["ItemRadio", _Itemcount];
_crate addItemCargoGlobal ["ItemWatch", _Itemcount];
_crate addItemCargoGlobal ["Medikit", _Itemcount];
_crate addItemCargoGlobal ["MineDetector", _Itemcount];
_crate addItemCargoGlobal ["NVGoggles", _Itemcount];
_crate addItemCargoGlobal ["ToolKit", _Itemcount];
_crate addItemCargoGlobal ["Rangefinder", _Itemcount];
_crate addItemCargoGlobal ["Laserdesignator", _Itemcount];
_crate addMagazineCargoGlobal ["Laserbatteries", _Itemcount];
};

//Helmets/hats
if (_Hats_Helmets == 1) then {
_crate addItemCargoGlobal ["H_HelmetB", _Clothingcount];
_crate addItemCargoGlobal ["H_Booniehat_khk", _Clothingcount];
_crate addItemCargoGlobal ["H_Booniehat_mcamo", _Clothingcount];
_crate addItemCargoGlobal ["H_Booniehat_ocamo", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_paint", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_light", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_red", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_brn_SERO", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_blu", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_headphones", _Clothingcount];
_crate addItemCargoGlobal ["H_PilotHelmetHeli_B", _Clothingcount];
_crate addItemCargoGlobal ["H_PilotHelmetHeli_O", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetO_ocamo", _Clothingcount];
_crate addItemCargoGlobal ["H_MilCap_ocamo", _Clothingcount];
_crate addItemCargoGlobal ["H_MilCap_mcamo", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetLeaderO_ocamo", _Clothingcount];
_crate addItemCargoGlobal ["H_Booniehat_grn", _Clothingcount];
_crate addItemCargoGlobal ["H_Booniehat_tan", _Clothingcount];
_crate addItemCargoGlobal ["H_Booniehat_dirty", _Clothingcount];
_crate addItemCargoGlobal ["H_Booniehat_dgtl", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_plain_mcamo", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_plain_blk", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetSpecB", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetSpecB_paint1", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetSpecB_paint2", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetSpecB_blk", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetIA", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetIA_net", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetIA_camo", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_tan", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_blk", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_blk_CMMG", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_brn_SPECOPS", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_tan_specops_US", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_khaki_specops_UK", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_grn", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_grn_BI", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_blk_Raven", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_blk_ION", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetCrew_B", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetCrew_O", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetCrew_I", _Clothingcount];
_crate addItemCargoGlobal ["H_PilotHelmetFighter_B", _Clothingcount];
_crate addItemCargoGlobal ["H_PilotHelmetFighter_O", _Clothingcount];
_crate addItemCargoGlobal ["H_PilotHelmetFighter_I", _Clothingcount];
_crate addItemCargoGlobal ["H_PilotHelmetHeli_I", _Clothingcount];
_crate addItemCargoGlobal ["H_CrewHelmetHeli_B", _Clothingcount];
_crate addItemCargoGlobal ["H_CrewHelmetHeli_O", _Clothingcount];
_crate addItemCargoGlobal ["H_CrewHelmetHeli_I", _Clothingcount];
_crate addItemCargoGlobal ["H_BandMask_blk", _Clothingcount];
_crate addItemCargoGlobal ["H_BandMask_khk", _Clothingcount];
_crate addItemCargoGlobal ["H_BandMask_reaper", _Clothingcount];
_crate addItemCargoGlobal ["H_BandMask_demon", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetO_oucamo", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetLeaderO_oucamo", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetSpecO_ocamo", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetSpecO_blk", _Clothingcount];
_crate addItemCargoGlobal ["H_MilCap_oucamo", _Clothingcount];
_crate addItemCargoGlobal ["H_MilCap_rucamo", _Clothingcount];
_crate addItemCargoGlobal ["H_MilCap_gry", _Clothingcount];
_crate addItemCargoGlobal ["H_MilCap_dgtl", _Clothingcount];
_crate addItemCargoGlobal ["H_MilCap_blue", _Clothingcount];
_crate addItemCargoGlobal ["H_Bandanna_surfer", _Clothingcount];
_crate addItemCargoGlobal ["H_Bandanna_khk", _Clothingcount];
_crate addItemCargoGlobal ["H_Bandanna_cbr", _Clothingcount];
_crate addItemCargoGlobal ["H_Bandanna_sgg", _Clothingcount];
_crate addItemCargoGlobal ["H_Bandanna_gry", _Clothingcount];
_crate addItemCargoGlobal ["H_Bandanna_camo", _Clothingcount];
_crate addItemCargoGlobal ["H_Bandanna_mcamo", _Clothingcount];
_crate addItemCargoGlobal ["H_Shemag_khk", _Clothingcount];
_crate addItemCargoGlobal ["H_Shemag_tan", _Clothingcount];
_crate addItemCargoGlobal ["H_Shemag_olive", _Clothingcount];
_crate addItemCargoGlobal ["H_ShemagOpen_khk", _Clothingcount];
_crate addItemCargoGlobal ["H_ShemagOpen_tan", _Clothingcount];
_crate addItemCargoGlobal ["H_Beret_blk", _Clothingcount];
_crate addItemCargoGlobal ["H_Beret_blk_POLICE", _Clothingcount];
_crate addItemCargoGlobal ["H_Beret_red", _Clothingcount];
_crate addItemCargoGlobal ["H_Beret_grn", _Clothingcount];
_crate addItemCargoGlobal ["H_Beret_grn_SF", _Clothingcount];
_crate addItemCargoGlobal ["H_Beret_brn_SF", _Clothingcount];
_crate addItemCargoGlobal ["H_Beret_ocamo", _Clothingcount];
_crate addItemCargoGlobal ["H_Watchcap_blk", _Clothingcount];
_crate addItemCargoGlobal ["H_Watchcap_khk", _Clothingcount];
_crate addItemCargoGlobal ["H_Watchcap_camo", _Clothingcount];
_crate addItemCargoGlobal ["H_Watchcap_sgg", _Clothingcount];
_crate addItemCargoGlobal ["H_TurbanO_blk", _Clothingcount];
_crate addItemCargoGlobal ["H_StrawHat", _Clothingcount];
_crate addItemCargoGlobal ["H_StrawHat_dark", _Clothingcount];
_crate addItemCargoGlobal ["H_Hat_blue", _Clothingcount];
_crate addItemCargoGlobal ["H_Hat_brown", _Clothingcount];
_crate addItemCargoGlobal ["H_Hat_camo", _Clothingcount];
_crate addItemCargoGlobal ["H_Hat_grey", _Clothingcount];
_crate addItemCargoGlobal ["H_Hat_checker", _Clothingcount];
_crate addItemCargoGlobal ["H_Hat_tan", _Clothingcount];
_crate addItemCargoGlobal ["H_Shemag_olive_hs", _Clothingcount];
_crate addItemCargoGlobal ["H_Cap_oli_hs", _Clothingcount];
_crate addItemCargoGlobal ["H_Bandanna_khk_hs", _Clothingcount];
_crate addItemCargoGlobal ["H_Booniehat_khk_hs", _Clothingcount];
_crate addItemCargoGlobal ["H_Beret_02", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_light_sand", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_light_black", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_light_desert", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_light_snakeskin", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_light_grass", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_sand", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_black", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_desert", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_snakeskin", _Clothingcount];
_crate addItemCargoGlobal ["H_HelmetB_grass", _Clothingcount];
_crate addItemCargoGlobal ["H_Helmet_Kerry", _Clothingcount];
};

//Glasses/goggles
if (_Glasses_Goggles == 1) then {
_crate addItemCargoGlobal ["G_Diving", _Clothingcount];
_crate addItemCargoGlobal ["G_Shades_Black", _Clothingcount];
_crate addItemCargoGlobal ["G_Shades_Blue", _Clothingcount];
_crate addItemCargoGlobal ["G_Sport_Blackred", _Clothingcount];
_crate addItemCargoGlobal ["G_Tactical_Clear", _Clothingcount];
_crate addItemCargoGlobal ["G_Spectacles", _Clothingcount];
_crate addItemCargoGlobal ["G_Spectacles_Tinted", _Clothingcount];
_crate addItemCargoGlobal ["G_Combat", _Clothingcount];
_crate addItemCargoGlobal ["G_Lowprofile", _Clothingcount];
_crate addItemCargoGlobal ["G_Shades_Green", _Clothingcount];
_crate addItemCargoGlobal ["G_Shades_Red", _Clothingcount];
_crate addItemCargoGlobal ["G_Squares", _Clothingcount];
_crate addItemCargoGlobal ["G_Squares_Tinted", _Clothingcount];
_crate addItemCargoGlobal ["G_Sport_BlackWhite", _Clothingcount];
_crate addItemCargoGlobal ["G_Sport_Blackyellow", _Clothingcount];
_crate addItemCargoGlobal ["G_Sport_Greenblack", _Clothingcount];
_crate addItemCargoGlobal ["G_Sport_Checkered", _Clothingcount];
_crate addItemCargoGlobal ["G_Sport_Red", _Clothingcount];
_crate addItemCargoGlobal ["G_Tactical_Black", _Clothingcount];
};

//BLUFOR Uniforms
if (_BLUFOR_Uniforms == 1) then {
_crate addItemCargoGlobal ["U_Rangemaster", _Clothingcount];                  //20
_crate addItemCargoGlobal ["U_Competitor", _Clothingcount];                   //20
_crate addItemCargoGlobal ["U_BasicBody", _Clothingcount];                    //0
_crate addItemCargoGlobal ["U_B_CombatUniform_mcam", _Clothingcount];         //20
_crate addItemCargoGlobal ["U_B_CombatUniform_mcam_tshirt", _Clothingcount];  //20
_crate addItemCargoGlobal ["U_B_CombatUniform_mcam_vest", _Clothingcount];    //20
_crate addItemCargoGlobal ["U_B_HeliPilotCoveralls", _Clothingcount];         //50
_crate addItemCargoGlobal ["U_B_Wetsuit", _Clothingcount];                    //90
_crate addItemCargoGlobal ["U_B_GhillieSuit", _Clothingcount];                //20
_crate addItemCargoGlobal ["U_B_CombatUniform_mcam_worn", _Clothingcount];    //20
_crate addItemCargoGlobal ["U_B_SpecopsUniform_sgg", _Clothingcount];         //20
_crate addItemCargoGlobal ["U_B_PilotCoveralls", _Clothingcount];             //50
_crate addItemCargoGlobal ["U_B_survival_uniform", _Clothingcount];
_crate addItemCargoGlobal ["U_B_CTRG_3", _Clothingcount];
_crate addItemCargoGlobal ["U_B_CTRG_2", _Clothingcount];
_crate addItemCargoGlobal ["U_B_CTRG_1", _Clothingcount];
};

//OPFOR Uniforms
if (_OPFOR_Uniforms == 1) then {
_crate addItemCargoGlobal ["U_O_GhillieSuit", _Clothingcount];                //30 ovsoi
_crate addItemCargoGlobal ["U_O_CombatUniform_oucamo", _Clothingcount];       //20
_crate addItemCargoGlobal ["U_O_SpecopsUniform_ocamo", _Clothingcount];       //20
_crate addItemCargoGlobal ["U_O_SpecopsUniform_blk", _Clothingcount];         //20
_crate addItemCargoGlobal ["U_O_OfficerUniform_ocamo", _Clothingcount];       //20
_crate addItemCargoGlobal ["U_O_CombatUniform_ocamo", _Clothingcount];        //20 ovsoi
_crate addItemCargoGlobal ["U_O_PilotCoveralls", _Clothingcount];             //50 ovsoi
_crate addItemCargoGlobal ["U_O_Wetsuit", _Clothingcount];                    //90 ovsoi
};

//Independent Uniforms
if (_Independent_Uniforms == 1) then {
_crate addItemCargoGlobal ["U_I_CombatUniform", _Clothingcount];              //20
_crate addItemCargoGlobal ["U_I_CombatUniform_tshirt", _Clothingcount];       //20
_crate addItemCargoGlobal ["U_I_CombatUniform_shortsleeve", _Clothingcount];  //20
_crate addItemCargoGlobal ["U_I_pilotCoveralls", _Clothingcount];             //50
_crate addItemCargoGlobal ["U_I_HeliPilotCoveralls", _Clothingcount];         //50
_crate addItemCargoGlobal ["U_I_GhillieSuit", _Clothingcount];                //30
_crate addItemCargoGlobal ["U_I_OfficerUniform", _Clothingcount];             //20
_crate addItemCargoGlobal ["U_I_Wetsuit", _Clothingcount];                    //90
_crate addItemCargoGlobal ["U_I_G_resistanceLeader_F", _Clothingcount];
_crate addItemCargoGlobal ["U_I_G_Story_Protagonist_F", _Clothingcount];
};

//Civilian Uniforms
if (_Civilian_Uniforms == 1) then {
_crate addItemCargoGlobal ["U_C_Poloshirt_blue", _Clothingcount];             //10
_crate addItemCargoGlobal ["U_C_Poloshirt_burgundy", _Clothingcount];         //10
_crate addItemCargoGlobal ["U_C_Poloshirt_stripped", _Clothingcount];         //10
_crate addItemCargoGlobal ["U_C_Poloshirt_tricolour", _Clothingcount];        //10
_crate addItemCargoGlobal ["U_C_Poloshirt_salmon", _Clothingcount];           //10
_crate addItemCargoGlobal ["U_C_Poloshirt_redwhite", _Clothingcount];         //10
_crate addItemCargoGlobal ["U_C_Commoner1_1", _Clothingcount];                //10
_crate addItemCargoGlobal ["U_C_Commoner1_2", _Clothingcount];                //10
_crate addItemCargoGlobal ["U_C_Commoner1_3", _Clothingcount];                //10
_crate addItemCargoGlobal ["U_C_Novak", _Clothingcount];                      //20
_crate addItemCargoGlobal ["U_C_TeeSurfer_shorts_2", _Clothingcount];
_crate addItemCargoGlobal ["U_C_TeeSurfer_shorts_1", _Clothingcount];
_crate addItemCargoGlobal ["U_C_TeeSurfer_shorts", _Clothingcount];
_crate addItemCargoGlobal ["U_C_Commoner_shorts", _Clothingcount];
_crate addItemCargoGlobal ["U_C_Poor_shorts_1", _Clothingcount];
_crate addItemCargoGlobal ["U_C_HunterBody_grn", _Clothingcount];
_crate addItemCargoGlobal ["U_C_WorkerCoveralls", _Clothingcount];
_crate addItemCargoGlobal ["U_C_Poor_2", _Clothingcount];
_crate addItemCargoGlobal ["U_C_Poor_1", _Clothingcount];
};

//Guerilla Uniforms
if (_Guerilla_Uniforms == 1) then {
_crate addItemCargoGlobal ["U_OG_leader", _Clothingcount];
_crate addItemCargoGlobal ["U_OG_Guerilla3_2", _Clothingcount];
_crate addItemCargoGlobal ["U_OG_Guerilla3_1", _Clothingcount];
_crate addItemCargoGlobal ["U_OG_Guerilla2_3", _Clothingcount];
_crate addItemCargoGlobal ["U_OG_Guerilla2_2", _Clothingcount];
_crate addItemCargoGlobal ["U_OG_Guerilla2_1", _Clothingcount];
_crate addItemCargoGlobal ["U_OG_Guerilla1_1", _Clothingcount];
_crate addItemCargoGlobal ["U_BG_leader", _Clothingcount];
_crate addItemCargoGlobal ["U_BG_Guerilla3_2", _Clothingcount];
_crate addItemCargoGlobal ["U_BG_Guerilla3_1", _Clothingcount];
_crate addItemCargoGlobal ["U_BG_Guerilla2_3", _Clothingcount];
_crate addItemCargoGlobal ["U_BG_Guerilla2_2", _Clothingcount];
_crate addItemCargoGlobal ["U_BG_Guerilla2_1", _Clothingcount];
_crate addItemCargoGlobal ["U_BG_Guerilla1_1", _Clothingcount];
_crate addItemCargoGlobal ["U_IG_leader", _Clothingcount];
_crate addItemCargoGlobal ["U_IG_Guerilla3_2", _Clothingcount];
_crate addItemCargoGlobal ["U_IG_Guerilla3_1", _Clothingcount];
_crate addItemCargoGlobal ["U_IG_Guerilla2_3", _Clothingcount];
_crate addItemCargoGlobal ["U_IG_Guerilla2_2", _Clothingcount];
_crate addItemCargoGlobal ["U_IG_Guerilla2_1", _Clothingcount];
_crate addItemCargoGlobal ["U_IG_Guerilla1_1", _Clothingcount];
};

//Other Uniforms
if (_Other_Uniforms == 1) then {
_crate addItemCargoGlobal ["U_NikosBody", _Clothingcount];                    //0
_crate addItemCargoGlobal ["U_MillerBody", _Clothingcount];                   //0
_crate addItemCargoGlobal ["U_KerryBody", _Clothingcount];                    //0
_crate addItemCargoGlobal ["U_OrestesBody", _Clothingcount];                  //0
_crate addItemCargoGlobal ["U_AttisBody", _Clothingcount];                    //0
_crate addItemCargoGlobal ["U_AntigonaBody", _Clothingcount];                 //0
_crate addItemCargoGlobal ["U_IG_Menelaos", _Clothingcount];                  //20
_crate addItemCargoGlobal ["U_OI_Scientist", _Clothingcount];                 //20
};

//Vests
if (_Vests == 1) then {
_crate addItemCargoGlobal ["V_Rangemaster_belt", _Bagcount];      //20
_crate addItemCargoGlobal ["V_BandollierB_khk", _Bagcount];       //60
_crate addItemCargoGlobal ["V_BandollierB_rgr", _Bagcount];       //60
_crate addItemCargoGlobal ["V_BandollierB_cbr", _Bagcount];       //60
_crate addItemCargoGlobal ["V_BandollierB_oli", _Bagcount];       //60
_crate addItemCargoGlobal ["V_BandollierB_blk", _Bagcount];       //60
_crate addItemCargoGlobal ["V_PlateCarrier1_rgr", _Bagcount];     //120
_crate addItemCargoGlobal ["V_PlateCarrier1_cbr", _Bagcount];     //120
_crate addItemCargoGlobal ["V_PlateCarrier2_rgr", _Bagcount];     //140
_crate addItemCargoGlobal ["V_PlateCarrierGL_rgr", _Bagcount];    //140
_crate addItemCargoGlobal ["V_PlateCarrier1_blk", _Bagcount];     //120
_crate addItemCargoGlobal ["V_PlateCarrier2_cbr", _Bagcount];     //140
_crate addItemCargoGlobal ["V_PlateCarrier2_blk", _Bagcount];     //140
_crate addItemCargoGlobal ["V_PlateCarrierGL_cbr", _Bagcount];    //140
_crate addItemCargoGlobal ["V_PlateCarrierGL_blk", _Bagcount];    //140
_crate addItemCargoGlobal ["V_PlateCarrierSpec_rgr", _Bagcount];  //140
_crate addItemCargoGlobal ["V_PlateCarrierSpec_cbr", _Bagcount];  //140
_crate addItemCargoGlobal ["V_PlateCarrierIA1_dgtl", _Bagcount];  //100
_crate addItemCargoGlobal ["V_PlateCarrierIA2_dgtl", _Bagcount];  //140
_crate addItemCargoGlobal ["V_PlateCarrierIAGL_dgtl", _Bagcount]; //140
_crate addItemCargoGlobal ["V_Chestrig_khk", _Bagcount];          //100
_crate addItemCargoGlobal ["V_ChestrigB_rgr", _Bagcount];         //
_crate addItemCargoGlobal ["V_ChestrigF_oli", _Bagcount];         //100
_crate addItemCargoGlobal ["V_ChestrigF_blk", _Bagcount];         //100
_crate addItemCargoGlobal ["V_TacVest_khk", _Bagcount];           //120
_crate addItemCargoGlobal ["V_TacVest_brn", _Bagcount];           //120
_crate addItemCargoGlobal ["V_TacVest_oli", _Bagcount];           //120
_crate addItemCargoGlobal ["V_TacVest_camo", _Bagcount];          //120
_crate addItemCargoGlobal ["V_TacVest_blk_POLICE", _Bagcount];    //120
_crate addItemCargoGlobal ["V_TacVestIR_blk", _Bagcount];         //140
_crate addItemCargoGlobal ["V_TacVest_blk", _Bagcount];           //120
_crate addItemCargoGlobal ["V_TacVestCamo_khk", _Bagcount];       //100
_crate addItemCargoGlobal ["V_HarnessO_brn", _Bagcount];          //150
_crate addItemCargoGlobal ["V_HarnessOGL_brn", _Bagcount];        //150
_crate addItemCargoGlobal ["V_HarnessO_gry", _Bagcount];          //150
_crate addItemCargoGlobal ["V_HarnessOGL_gry", _Bagcount];        //150
_crate addItemCargoGlobal ["V_HarnessOSpec_brn", _Bagcount];      //150
_crate addItemCargoGlobal ["V_HarnessOSpec_gry", _Bagcount];      //150
_crate addItemCargoGlobal ["V_RebreatherB", _Bagcount];           //0
_crate addItemCargoGlobal ["V_RebreatherIR", _Bagcount];          //0
_crate addItemCargoGlobal ["V_RebreatherIA", _Bagcount];          //0
_crate addItemCargoGlobal ["V_I_G_resistanceLeader_F", _Bagcount];
_crate addItemCargoGlobal ["V_PlateCarrierH_CTRG", _Bagcount];
_crate addItemCargoGlobal ["V_PlateCarrierL_CTRG", _Bagcount];
_crate addItemCargoGlobal ["V_PlateCarrier_Kerry", _Bagcount];
};

//Bags
if (_Bags == 1) then {
_crate addBackpackCargoGlobal ["B_AssaultPack_Base", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_blk", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_cbr", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_dgtl", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_khk", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_mcamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_ocamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_rgr", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_sgg", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPackG", _Bagcount];
_crate addBackpackCargoGlobal ["B_Carryall_Base", _Bagcount];
_crate addBackpackCargoGlobal ["B_Carryall_ocamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_Carryall_oucamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_Carryall_mcamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_Carryall_oli", _Bagcount];
_crate addBackpackCargoGlobal ["B_Carryall_khk", _Bagcount];
_crate addBackpackCargoGlobal ["B_Carryall_cbr", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_Base", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_blk", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_cbr", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_ocamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_oucamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_khk", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_oli", _Bagcount];
_crate addBackpackCargoGlobal ["B_Kitbag_Base", _Bagcount];
_crate addBackpackCargoGlobal ["B_Kitbag_cbr", _Bagcount];
_crate addBackpackCargoGlobal ["B_Kitbag_mcamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_Kitbag_sgg", _Bagcount];
_crate addBackpackCargoGlobal ["Bag_Base", _Bagcount];
_crate addBackpackCargoGlobal ["B_Bergen_Base", _Bagcount];
_crate addBackpackCargoGlobal ["B_Bergen_sgg", _Bagcount];
_crate addBackpackCargoGlobal ["B_Bergen_mcamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_Bergen_rgr", _Bagcount];
_crate addBackpackCargoGlobal ["B_Bergen_blk", _Bagcount];
_crate addBackpackCargoGlobal ["B_BergenG", _Bagcount];
_crate addBackpackCargoGlobal ["B_BergenC_red", _Bagcount];
_crate addBackpackCargoGlobal ["B_BergenC_grn", _Bagcount];
_crate addBackpackCargoGlobal ["B_BergenC_blu", _Bagcount];
_crate addBackpackCargoGlobal ["B_TacticalPack_rgr", _Bagcount];
_crate addBackpackCargoGlobal ["B_TacticalPack_mcamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_TacticalPack_ocamo", _Bagcount];
_crate addBackpackCargoGlobal ["B_TacticalPack_blk", _Bagcount];
_crate addBackpackCargoGlobal ["B_TacticalPack_oli", _Bagcount];
_crate addBackpackCargoGlobal ["B_OutdoorPack_blk", _Bagcount];
_crate addBackpackCargoGlobal ["B_OutdoorPack_tan", _Bagcount];
_crate addBackpackCargoGlobal ["B_OutdoorPack_blu", _Bagcount];
_crate addBackpackCargoGlobal ["B_HuntingBackpack", _Bagcount];
_crate addBackpackCargoGlobal ["B_Parachute", _Bagcount];
};

//Preset bags
if (_Preset_Bags == 1) then {
_crate addBackpackCargoGlobal ["B_Mortar_01_support_F", _Bagcount];
_crate addBackpackCargoGlobal ["B_Mortar_01_weapon_F", _Bagcount];
_crate addBackpackCargoGlobal ["B_Carryall_oucamo_Exp", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_ocamo_Medic", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_cbr_AT", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_cbr_Repair", _Bagcount];
_crate addBackpackCargoGlobal ["B_FieldPack_blk_DiverExp", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_rgr_Medic", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_rgr_Repair", _Bagcount];
_crate addBackpackCargoGlobal ["B_AssaultPack_blk_DiverExp", _Bagcount];
//_crate addBackpackCargoGlobal ["B_AssaultPack_blk_DiverTL", _Bagcount];
//_crate addBackpackCargoGlobal ["B_AssaultPack_khk_holder", _Bagcount];
//_crate addBackpackCargoGlobal ["B_FieldPack_blk_DiverTL", _Bagcount];
//_crate addBackpackCargoGlobal ["B_Bergen_sgg_Exp", _Bagcount];
};

//Test bed
if (_Test_bed == 1) then {

};

sleep _Refresh;
};