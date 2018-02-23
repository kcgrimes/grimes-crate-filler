/*
Author: KC Grimes
Script: Grimes Crate Filler
Version: V2.0
*/

if (!isServer) exitWith {};

//Begin Basic Parameters (edit these as described in the comments, defaults already chosen and active)
_weaponCount             = 10;   //Quantity of each weapon/launcher to be spawned
_ammoCount               = 50;   //Quantity of each type of ammunition/explosive to be spawned
_itemCount               = 10;   //Quantity of each type of item (gadgets, attachments, etc)
_uniformCount            = 3;    //Quantity of each type of uniform/hat/helmet/glasses (suggested to keep small due to not being stackable)
_bagCount                = 3;    //Quantity of each type of bag/vest item (suggested to keep small due to not being stackable)
_refreshTime             = 600;  //Amount of time until crate empties/refills (seconds), 0 is no refresh
//End Basic Parameters

//Begin Advanced Settings
//In the following options, enter 0 to exclude the items from the script, and enter 1 to include them, thus spawning them in the crate. Scroll to their section for more specific information.
//Default: All included except preset weapons (see _Base_Weapons), preset bags, assemblable bags, glasses/goggles, headgear, and uniforms
_NATO_Weapons              = 1; //All weapons seen as BLUFOR weapons
_OPFOR_Weapons             = 1; //All weapons seen as OPFOR weapons
_Ind_Weapons               = 1; //All weapons seen as Independent weapons
_Base_Weapons              = 1; //All weapons selected above will only be base/stock variants with no attachments (see attachments parameter)
_NATO_Launchers            = 1; //All rocket/missile launchers seen as BLUFOR launchers
_OPFOR_Launchers           = 1; //All rocket/missile launchers seen as OPFOR launchers
_Ind_Launchers             = 1; //All rocket/missile launchers seen as Independent launchers
_Weapon_Ammo               = 1; //All ammunition used by any weapons & launchers pulled from above parameters
_Plantable_Explosives      = 1; //All plantable explosive devices (mines, charges, etc.) (not sorted by faction)
_Grenade_Launcher_Ammo     = 1; //All grenade launcher ammo
_Throwables                = 1; //All throwable munitions (smokes, grenades, chemlights)
_Attachments               = 1; //All weapon attachments (not sorted by faction)
_Items                     = 1; //All items (gadgets, kits, binocs, rangefinder, laser designator, anything else on player that is not a bag or weapon)
_Headgear                  = 1; //All hats and helmets
_Glasses_Goggles           = 1; //All glasses and goggles (currently unsupported by BIS)
_BLUFOR_Uniforms           = 1; //All BLUFOR uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_OPFOR_Uniforms            = 1; //All OPFOR uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_Independent_Uniforms      = 1; //All Independent uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_Civilian_Uniforms         = 1; //All Civilian uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_Guerilla_Uniforms         = 1; //All Guerilla uniforms, which are hit and miss for who can wear them, but mostly follow the name's indication (too many exceptions to split)
_Other_Uniforms            = 1; //All Other uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)
_Vests                     = 1; //All vests and chest rigs
_Empty_Bags                = 1; //All empty, normal backpacks
_Preset_Bags               = 1; //All preset bags (normal bags containing a preset of items, such as First Aid Kits and Explosives, which are already found elsewhere in the crate)
_Assemble_Bags             = 1; //All backpacks that lack cargo but can be used or combined with another bag to assemble a static weapon

_Debug                     = 1; //Dump formatted return of all entities added to ammo box to .rpt
//End Advanced Settings

//Start debug timer if in use
private ["_timer"];
if (_Debug == 1) then {
	_timer = time;
	systemChat "G_Crate Debug Mode is enabled!";
};

//Define ammo crate object
_crate = _this select 0;

//Add all weapons in config to array
_cfgWeapons = configFile >> "CfgWeapons";
//Add all magazines in config to array
_cfgMagazines = configFile >> "CfgMagazines";
//Add all vehicles in config to array
_cfgVehicles = configFile >> "CfgVehicles";
//Add all glasses/goggles in config to array
_cfgGlasses = configFile >> "CfgGlasses";

//Create function for adding items from CfgWeapons to an array
_G_fnc_createItemsArray = {
	_cfgChoice = _this select 0;
	private ["_cfgTable"];
	//Define config table based on param
	switch (_cfgChoice) do {
		case 0: {_cfgTable = _cfgWeapons;};
		case 1: {_cfgTable = _cfgMagazines;};
		case 2: {_cfgTable = _cfgVehicles;};
		case 3: {_cfgTable = _cfgGlasses;};
	};
	_allowedType = _this select 1;
	//Type 1 = rifle, 2 = handgun, 4 = launcher, 131072 and 4096 = various items, "Backpacks" = bags, ""/0/undefined = glasses/goggles
	_allowedStrings = _this select 2;
	_customCheck = _this select 3;
	
	//Cycle through each item in config
	_itemsArrayReturn = [];
	for "_i" from 0 to (count _cfgTable)-1 do
	{
		//Select element from config, similar to array
		_curCfg = _cfgTable select _i;
		
		//Verify working with config class
		if (isClass _curCfg) then {
			//Define classname from config name
			_className = configName _curCfg;
			//By default, type is found as number here
			_type = getNumber (_curCfg >> "type");
			//Check if choice 2 so kind of bag can be determined			
			private ["_isEmptyBag", "_isAssembleBag"];
			if (_cfgChoice == 2) then {
				//Choice 2, so get type a different way
				_type = getText (_curCfg >> "vehicleClass");
				
				//Check for items, weapons, and magazines in subject bag
				if (((count (_cfgVehicles >> _className >> "TransportItems")) + (count (_cfgVehicles >> _className >> "TransportWeapons")) + (count (_cfgVehicles >> _className >> "TransportMagazines"))) == 0) then {
					//Nothing in bag
					_isEmptyBag = true;
				}
				else
				{
					//Something in bag
					_isEmptyBag = false;
				};
				
				//Check if bag has attributes of assemble bag
				_isAssembleBag = isClass (_cfgVehicles >> _className >> "assembleInfo");
			};
			//Check for faction- or item-specific strings in classname
			//By default, item is not included
			_stringIn = false;
			//Check if string limiter param is empty
			if ((count _allowedStrings) == 0) then {
				//No strings to limit by, so default true
				_stringIn = true;
			}
			else
			{
				{
					//Check if string is inside classname
					if ([_x, _className] call BIS_fnc_inString) then {
						//String is in classname, so allow it to be added
						_stringIn = true;
					};
				} forEach _allowedStrings;
			};
			//Check custom param
			//By default, custom check fails
			_customCheckReturn = false;
			//Check if custom check was defined
			if (!isNil "_customCheck") then {
				//Custom check defined
				call compile _customCheck;
			}
			else
			{
				//No custom check, so pass
				_customCheckReturn = true;
			};
			//Check item type, a picture path exists (is real), is not a private object, string limiters, not already in array, is base one way or another, and passes the custom check
			if ((_type in _allowedType) && (getText (_curCfg >> "picture") != "") && (getNumber (_curCfg >> "scope") != 0) && (_stringIn) && !(_className in _itemsArrayReturn) && (_customCheckReturn)) then {
				//Check if debug
				if (_Debug == 1) then {
					//For debug, output classname, type, and config path
					diag_log format ["Classname: %1 - Type: %2 - Cfg Dir: %3", _className, _type, _curCfg];
				};
				//Add item to items array
				_itemsArrayReturn pushBack _className;
			};
		};
	};
	
	//Return array of added items for later use
	_itemsArrayReturn;
};

//Function for adding previously defined arrays of items to the crate
_G_fnc_addToCrate = {
	//Add all "pulled" items to the crate in order
	//For each weapon in array, add it to the crate
	{
		_crate addItemCargoGlobal [_x, _weaponCount];
	} forEach _allWeaponsArray;
	
	//For each magazine in array, add it to the crate
	{
		_crate addMagazineCargoGlobal [_x, _ammoCount];
	} forEach _allMagazinesArray;
	
	//For each item in array, add it to the crate
	{
		_crate addItemCargoGlobal [_x, _itemCount];
	} forEach _allItemsArray;
	
	//For each uniform in array, add it to the crate
	{
		_crate addItemCargoGlobal [_x, _uniformCount];
	} forEach _allUniformsArray;
	
	//For each vest in array, add it to the crate
	{
		_crate addItemCargoGlobal [_x, _bagCount];
	} forEach _Vest_Array;
	
	//For each bag in array, add it to the crate
	{
		_crate addBackPackCargoGlobal [_x, _bagCount];
	} forEach _allBagsArray;
};

//NATO Weapons
_NATO_Weapon_Array = [];
if (_NATO_Weapons == 1) then {
	//CfgWeapons, primary or secondary, BLUFOR faction strings
	//For custom - Treat item as base by default; Check if only real base weapons allowed, if so, if LinkedItems does not exist, then this is a base weapon (or not a weapon), return true
	_NATO_Weapon_Array = [0, [1, 2], ["Mk20", "MX", "SDAR", "SPAR", "TRG2", "ACPC2", "P07", "PDW2000", "Pistol_heavy_01", "MMG_02", "SMG_01", "SMG_05", "DMR_02", "DMR_03", "DMR_06", "EBR", "LRR", "Pistol_Signal"], "if (_Base_Weapons == 1) then {_customCheckReturn = !isClass (_cfgWeapons >> _className >> ""LinkedItems"");}else{_customCheckReturn=true;};"] call _G_fnc_createItemsArray;
};

//OPFOR Weapons
_OPFOR_Weapon_Array = [];
if (_OPFOR_Weapons == 1) then {
	//CfgWeapons, primary or secondary, OPFOR faction strings
	//For custom - Treat item as base by default; Check if only real base weapons allowed, if so, if LinkedItems does not exist, then this is a base weapon (or not a weapon), return true
	_OPFOR_Weapon_Array = [0, [1, 2], ["ARX", "CTAR", "Katiba", "Mk20", "SDAR", "TRG2", "ACPC2", "Pistol_heavy_02", "rook40", "Zafir", "MMG_01", "SMG_02", "DMR_01", "DMR_04", "DMR_05", "DMR_06", "DMR_07", "GM6", "Pistol_Signal"], "if (_Base_Weapons == 1) then {_customCheckReturn = !isClass (_cfgWeapons >> _className >> ""LinkedItems"");}else{_customCheckReturn=true;};"] call _G_fnc_createItemsArray;
};

//Independent Weapons
_Ind_Weapon_Array = [];
if (_Ind_Weapons == 1) then {
	//CfgWeapons, primary or secondary, Independent faction strings
	//For custom - Treat item as base by default; Check if only real base weapons allowed, if so, if LinkedItems does not exist, then this is a base weapon (or not a weapon), return true
	_Ind_Weapon_Array = [0, [1, 2], ["AK12", "AKM", "AKS", "Mk20", "SDAR", "TRG2", "ACPC2", "PDW2000", "Pistol_01", "LMG_03", "DMR_06", "EBR", "GM6", "Pistol_Signal"], "if (_Base_Weapons == 1) then {_customCheckReturn = !isClass (_cfgWeapons >> _className >> ""LinkedItems"");}else{_customCheckReturn=true;};"] call _G_fnc_createItemsArray;
};

//NATO Launchers
_NATO_Launcher_Array = [];
if (_NATO_Launchers == 1) then {
	//CfgWeapons, launcher, BLUFOR faction strings
	_NATO_Launcher_Array = [0, [4], ["launch_b", "launch_nlaw", "launch_rpg32"]] call _G_fnc_createItemsArray;
};

//OPFOR Launchers
_OPFOR_Launcher_Array = [];
if (_OPFOR_Launchers == 1) then {
	//CfgWeapons, launcher, OPFOR faction strings
	_OPFOR_Launcher_Array = [0, [4], ["launch_o", "launch_rpg32"]] call _G_fnc_createItemsArray;
};

//Independent Launchers
_Ind_Launcher_Array = [];
if (_Ind_Launchers == 1) then {
	//CfgWeapons, launcher, Independent faction strings
	_Ind_Launcher_Array = [0, [4], ["launch_i", "launch_nlaw", "launch_rpg"]] call _G_fnc_createItemsArray;
};

//Make combined array of all weapons, which has duplicates
_allWeaponsArray_Dup = _NATO_Weapon_Array + _OPFOR_Weapon_Array + _Ind_Weapon_Array + _NATO_Launcher_Array + _OPFOR_Launcher_Array + _Ind_Launcher_Array;
//Make combined, unique array of all weapons
_allWeaponsArray = [];
{
	_allWeaponsArray pushBackUnique _x;
} forEach _allWeaponsArray_Dup;

//Weapon-specific ammo
_allMagazinesArray = [];
if (_Weapon_Ammo == 1) then {
	//Cycle through each weapon
	for "_i" from 0 to (count _allWeaponsArray)-1 do
	{
		_weaponClassName = _allWeaponsArray select _i;
		//Get array of compatible magazines for weapon
		_curCfgMagazines = getArray (_cfgWeapons >> _weaponClassName >> "magazines");
		//Cycle through array of compatible magazines
		{
			//Check if magazine is in the array yet
			if !(_x in _allMagazinesArray) then {
				//Check if debug
				if (_Debug == 1) then {
					//For debug, output classname, type, and config path
					diag_log format ["Classname: %1 - Type: %2 - Cfg Dir: %3", _x, "From Weapon-Specific", "From Weapon-Specific"];
				};
				//Add magazine to the array
				_allMagazinesArray pushBack _x;
			};
		} forEach _curCfgMagazines;
	};
};

//Plantable Explosives
_Plantable_Explosives_Array = [];
if (_Plantable_Explosives == 1) then {
	//CfgMagazines, explosives, plantable
	_Plantable_Explosives_Array = [1, [2*256], [], "if (getNumber (_curCfg >> ""useAction"") == 1) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Grenade launcher rounds
_Grenade_Launch_Ammo_Array = [];
if (_Grenade_Launcher_Ammo == 1) then {
	//CfgMagazines, GL rounds, GL rounds
	_Grenade_Launch_Ammo_Array = [1, [16], [], "if (getNumber (_curCfg >> ""count"") in [1,3,6]) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Throwable grenades, smokes, chemlights
_Throwable_Array = [];
if (_Throwables == 1) then {
	//CfgMagazines, explosives, like-grenade
	_Throwable_Array = [1, [256], [], "if (getNumber (_curCfg >> ""count"") == 1) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Make combined array of all magazines
_allMagazinesArray = _allMagazinesArray + _Plantable_Explosives_Array + _Grenade_Launch_Ammo_Array + _Throwable_Array;

//Attachments
_Attachment_Array = [];
if (_Attachments == 1) then {
	//CfgWeapons, item-type, "acc_" for flashlight, "bipod_" for bipod, "optic_" for optics, "muzzle_" for others
	_Attachment_Array = [0, [131072], ["acc_", "bipod_", "optic_", "muzzle_"]] call _G_fnc_createItemsArray;
};

//Items
_Item_Array = [];
if (_Items == 1) then {
	//CfgWeapons, item-type or binocular-like/NVG, must have display name to prevent error on inclusion of non-existent items, item/minedetector/kit/uavterminal for specific items, useAsBinocular for rangefinders/binoculars
	_Item_Array = [0, [131072, 4096], [], "if ((getText (_curCfg >> ""displayName"") != """") && (([""item"", _className] call BIS_fnc_inString) || ([""MineDetector"", _className] call BIS_fnc_inString) || ([""kit"", _className] call BIS_fnc_inString) || ([""uavterminal"", _className] call BIS_fnc_inString) || (getNumber (_curCfg >> ""useAsBinocular"") == 1))) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Make combined array of all actual items
_allItemsArray = _Attachment_Array + _Item_Array;

//Helmets/hats
_Headgear_Array = [];
if (_Headgear == 1) then {
	//CfgWeapons, item-type, "H_" for headgear, not "V_" to avoid vests, not "muzzle_" to avoid some muzzle items
	_Headgear_Array = [0, [131072], ["H_"], "if ((!([""V_"", _className] call BIS_fnc_inString)) && (!([""muzzle_"", _className] call BIS_fnc_inString))) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Glasses/goggles
_Glasses_Goggles_Array = [];
if (_Glasses_Goggles == 1) then {
	//CfgGlasses, no type, must have model to prevent error on inclusion of non-existent items
	_Glasses_Goggles_Array = [3, [0], [], "if (getText(_curCfg >> ""model"") != """") then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//BLUFOR Uniforms
_BLUFOR_Uniforms_Array = [];
if (_BLUFOR_Uniforms == 1) then {
	//CfgWeapons, item-type, BLUFOR faction string
	_BLUFOR_Uniforms_Array = [0, [131072], ["U_B_"]] call _G_fnc_createItemsArray;
};

//OPFOR Uniforms
_OPFOR_Uniforms_Array = [];
if (_OPFOR_Uniforms == 1) then {
	//CfgWeapons, item-type, OPFOR faction string
	_OPFOR_Uniforms_Array = [0, [131072], ["U_O_"]] call _G_fnc_createItemsArray;
};

//Independent Uniforms
_Independent_Uniforms_Array = [];
if (_Independent_Uniforms == 1) then {
	//CfgWeapons, item-type, Ind faction string
	_Independent_Uniforms_Array = [0, [131072], ["U_I_"]] call _G_fnc_createItemsArray;
};

//Civilian Uniforms
_Civilian_Uniforms_Array = [];
if (_Civilian_Uniforms == 1) then {
	//CfgWeapons, item-type, Civilian faction string
	_Civilian_Uniforms_Array = [0, [131072], ["U_C_"]] call _G_fnc_createItemsArray;
};

//Guerilla Uniforms
_Guerilla_Uniforms_Array = [];
if (_Guerilla_Uniforms == 1) then {
	//CfgWeapons, item-type, Guerilla faction strings
	_Guerilla_Uniforms_Array = [0, [131072], ["U_BG_", "U_OG_", "U_IG_"]] call _G_fnc_createItemsArray;
};

//Other Uniforms
_Other_Uniforms_Array = [];
if (_Other_Uniforms == 1) then {
	//CfgWeapons, item-type, Uniform string, not any faction's string
	_Other_Uniforms_Array = [0, [131072], ["U_"], "if (!([""U_B_"", _className] call BIS_fnc_inString) && !([""U_O_"", _className] call BIS_fnc_inString) && !([""U_I_"", _className] call BIS_fnc_inString) && !([""U_BG_"", _className] call BIS_fnc_inString) && !([""U_IG_"", _className] call BIS_fnc_inString) && !([""U_OG_"", _className] call BIS_fnc_inString) && !([""U_C_"", _className] call BIS_fnc_inString)) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Make combined array of all hats, helmets, glasses/goggles, and uniforms
_allUniformsArray = _Headgear_Array + _Glasses_Goggles_Array + _BLUFOR_Uniforms_Array + _OPFOR_Uniforms_Array + _Independent_Uniforms_Array + _Civilian_Uniforms_Array + _Guerilla_Uniforms_Array + _Other_Uniforms_Array;

//Vests
_Vest_Array = [];
if (_Vests == 1) then {
	//CfgWeapons, item-type, "V_" for vest
	_Vest_Array = [0, [131072], ["V_"]] call _G_fnc_createItemsArray;
};

//Bags
_Empty_Bag_Array = [];
if (_Empty_Bags == 1) then {
	//CfgVehicles, backpack-type, empty bag
	_Empty_Bag_Array = [2, ["Backpacks"], [], "if ((_isEmptyBag) && !(_isAssembleBag)) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Preset bags
_Preset_Bag_Array = [];
if (_Preset_Bags == 1) then {
	//CfgVehicles, backpack-type, preset bag
	_Preset_Bag_Array = [2, ["Backpacks"], [], "if (!(_isEmptyBag) && !(_isAssembleBag)) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Assemble bags
_Assemble_Bag_Array = [];
if (_Assemble_Bags == 1) then {
	//CfgVehicles, backpack-type, assemble bag
	_Assemble_Bag_Array = [2, ["Backpacks"], [], "if (_isAssembleBag) then {_customCheckReturn = true;};"] call _G_fnc_createItemsArray;
};

//Make combined array of all bags
_allBagsArray = _Empty_Bag_Array + _Preset_Bag_Array + _Assemble_Bag_Array;

while {alive _crate} do {
	//Empty the crate
	clearMagazineCargoGlobal _crate;
	clearWeaponCargoGlobal _crate;
	clearItemCargoGlobal _crate;
	clearBackpackCargoGlobal _crate;
	
	//Add items to crate
	[] call _G_fnc_addToCrate;
	
	//Output debug timer if in use
	if (_Debug == 1) then {
		systemChat format ["G_Crate Time: %1 seconds", (time - _timer)];
	};
	
	//If no refresh time, exit
	if (!(_refreshTime > 0)) exitWith {};
	
	//Wait for refresh time
	sleep _refreshTime;
};