/*
Author: KC Grimes
Script: Grimes Crate Filler
Version: V2.0
*/

if (!isServer) exitWith {};

//Begin Basic Parameters (edit these as described in the comments, defaults already chosen and active)
_Wpncount                = 10;   //Quantity of each weapon/launcher to be spawned
_Ammocount               = 50;   //Quantity of each type of ammunition/explosive to be spawned
_Itemcount               = 10;   //Quantity of each type of item (gadgets, attachments, etc)
_Clothingcount           = 3;    //Quantity of each type of uniform/hat/helmet/glasses (suggested to keep small due to not being stackable)
_Bagcount                = 3;    //Quantity of each type of bag/vest item (suggested to keep small due to not being stackable)
_Refresh                 = 600;  //Amount of time until crate empties/refills (seconds), 0 is no refresh
//End Basic Parameters

//Begin Advanced Settings
//In the following options, enter 0 to exclude the items from the script, and enter 1 to include them, thus spawning them in the crate. Scroll to their section for more specific information.
//Default: All included except preset weapons (see _Base_Weapons), preset bags, assemblable bags, glasses/goggles, headgear, and uniforms
_NATO_Weapons              = 1; //All weapons seen as BLUFOR weapons
_OPFOR_Ind_Weapons         = 1; //All weapons seen as OPFOR and Independent weapons
_Mixed_Weapons             = 1; //All weapons found in BLUFOR, OPFOR, and Independent arsenals
_Base_Weapons              = 1; //All weapons selected above will only be base/stock variants with no attachments (see attachments parameter)
_Weapon_Ammo               = 1; //All ammunition used by any weapons pulled from above parameters
_NATO_Launchers            = 1; //All rocket/missile launchers seen as BLUFOR launchers
_OPFOR_Ind_Launchers       = 1; //All rocket/missile launchers seen as OPFOR and Independent launchers
_NATO_Launcher_Ammo        = 1; //All ammunition used by BLUFOR rocket/missile launchers
_OPFOR_Ind_Launcher_Ammo   = 1; //All ammunition used by OPFOR and Independent rocket/missile launchers
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
_Bags                      = 1; //All empty, normal backpacks
_Preset_Bags               = 1; //All preset bags (normal bags containing a preset of items, such as First Aid Kits and Explosives, which are already found elsewhere in the crate)
_Assemble_Bags             = 1; //All backpacks that lack cargo but can be used or combined with another bag to assemble a static weapon

_Test_bed                  = 0; //Location to place any items to be tested for dev purposes (Keep off unless in specific use)
_Debug                     = 1; //Formatted return for all entities added to ammo box (.rpt)
//End Advanced Settings

_crate = _this select 0;

while {alive _crate} do
{
scopeName "whileloop";

clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

private ["_NATO_Weapon_Array","_OPFOR_Ind_Weapon_Array","_Mixed_Weapon_Array"];
//NATO Weapons
_NATO_Weapon_Array = [];
if (_NATO_Weapons == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			private ["_base"];
			if (_Base_Weapons == 1) then {
				_base = (configName (configFile >> "CfgWeapons" >> _classname >> "LinkedItems")) == "";
			}
			else
			{
				_base = true;
			};
			if (_cur_cfg_type in [1,2] && _picture != "" && !(_classname in _NATO_Weapon_Array) && ((["MX", _classname] call BIS_fnc_inString) || (["EBR", _classname] call BIS_fnc_inString) || (["LRR", _classname] call BIS_fnc_inString) || (["P07", _classname] call BIS_fnc_inString) || (["SMG_01", _classname] call BIS_fnc_inString) || (["Pistol_heavy_01", _classname] call BIS_fnc_inString)) && (_base)) then {
				if (_Debug == 1) then {if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};};
				_NATO_Weapon_Array set[count _NATO_Weapon_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Wpncount];
	} foreach _NATO_Weapon_Array;
};

//OPFOR/Independent Weapons
_OPFOR_Ind_Weapon_Array = [];
if (_OPFOR_Ind_Weapons == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			private ["_base"];
			if (_Base_Weapons == 1) then {
				_base = (configName (configFile >> "CfgWeapons" >> _classname >> "LinkedItems")) == "";
			}
			else
			{
				_base = true;
			};
			if (_cur_cfg_type in [1,2] && _picture != "" && !(_classname in _OPFOR_Ind_Weapon_Array) && ((["Katiba", _classname] call BIS_fnc_inString) || (["GM6", _classname] call BIS_fnc_inString) || (["DMR", _classname] call BIS_fnc_inString) || (["Zafir", _classname] call BIS_fnc_inString) || (["PDW2000", _classname] call BIS_fnc_inString) || (["SMG_02", _classname] call BIS_fnc_inString) || (["rook40", _classname] call BIS_fnc_inString) || (["Pistol_heavy_02", _classname] call BIS_fnc_inString)) && (_base)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_OPFOR_Ind_Weapon_Array set[count _OPFOR_Ind_Weapon_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Wpncount];
	} foreach _OPFOR_Ind_Weapon_Array;
};

//Mixed B/O weapons
_Mixed_Weapon_Array = [];
if (_Mixed_Weapons == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			private ["_base"];
			if (_Base_Weapons == 1) then {
				_base = (configName (configFile >> "CfgWeapons" >> _classname >> "LinkedItems")) == "";
			}
			else
			{
				_base = true;
			};
			if (_cur_cfg_type in [1,2] && _picture != "" && !(_classname in _Mixed_Weapon_Array) && ((["Mk20", _classname] call BIS_fnc_inString) || (["TRG21", _classname] call BIS_fnc_inString) || (["SDAR", _classname] call BIS_fnc_inString) || (["ACPC2", _classname] call BIS_fnc_inString)) && (_base)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Mixed_Weapon_Array set[count _Mixed_Weapon_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Wpncount];
	} foreach _Mixed_Weapon_Array;
};

//Weapon-specific ammo
if (_Weapon_Ammo == 1) then {
	_weapons = _Mixed_Weapon_Array + _OPFOR_Ind_Weapon_Array + _NATO_Weapon_Array;
	_magazines = [];
	for "_i" from 0 to (count _weapons)-1 do
	{
		_classname = _weapons select _i;
		_cur_cfg_magazines = getArray (configFile >> "CfgWeapons" >> _classname >> "magazines");
		{
			if !(_x in _magazines) then {
				_magazines = _magazines + [_x];
			};
		} forEach _cur_cfg_magazines;
	};
	{
		_crate addMagazineCargoGlobal [_x, _Ammocount];
	} foreach _magazines;
};

//NATO Launchers
if (_NATO_Launchers == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_NATO_Launcher_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 4 && _picture != "" && !(_classname in _NATO_Launcher_Array) && ((["launch_b", _classname] call BIS_fnc_inString) || (["launch_nlaw", _classname] call BIS_fnc_inString))) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_NATO_Launcher_Array set[count _NATO_Launcher_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Wpncount];
	} foreach _NATO_Launcher_Array;
};

//OPFOR Launchers
if (_OPFOR_Ind_Launchers == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_OPFOR_Ind_Launcher_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 4 && _picture != "" && !(_classname in _OPFOR_Ind_Launcher_Array) && ((["launch_o", _classname] call BIS_fnc_inString) || (["launch_i", _classname] call BIS_fnc_inString) || (["launch_rpg", _classname] call BIS_fnc_inString))) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_OPFOR_Ind_Launcher_Array set[count _OPFOR_Ind_Launcher_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Wpncount];
	} foreach _OPFOR_Ind_Launcher_Array;
};

//NATO Launcher Ammo
if (_NATO_Launcher_Ammo == 1) then {
	_cfgMagazines = configFile >> "CfgMagazines";
	_NATO_Launcher_Ammo_Array = [];
	
	for "_i" from 0 to (count _cfgMagazines)-1 do
	{
		_cur_cfg = _cfgMagazines select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (((_cur_cfg_type == 6*256) || (_cur_cfg_type == 3*256)) && _picture != "" && !(_classname in _NATO_Launcher_Ammo_Array)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_NATO_Launcher_Ammo_Array set[count _NATO_Launcher_Ammo_Array, _classname];
			};
		};
	};
	{
		_crate addMagazineCargoGlobal [_x, _Ammocount];
	} foreach _NATO_Launcher_Ammo_Array;
};

//OPFOR Launcher Ammo
if (_OPFOR_Ind_Launcher_Ammo == 1) then {
	_cfgMagazines = configFile >> "CfgMagazines";
	_OPFOR_Ind_Launcher_Ammo_Array = [];
	
	for "_i" from 0 to (count _cfgMagazines)-1 do
	{
		_cur_cfg = _cfgMagazines select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if ((((_cur_cfg_type == 2*256) && (getNumber (_cur_cfg >> "useAction") == 0) && (getNumber (_cur_cfg >> "count") == 1)) || ((_cur_cfg_type == 6*256) && !(_NATO_Launcher_Ammo == 1))) && (_picture != "") && !(_classname in _OPFOR_Ind_Launcher_Ammo_Array)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_OPFOR_Ind_Launcher_Ammo_Array set[count _OPFOR_Ind_Launcher_Ammo_Array, _classname];
			};
		};
	};
	{
		_crate addMagazineCargoGlobal [_x, _Ammocount];
	} foreach _OPFOR_Ind_Launcher_Ammo_Array;
};

//Plantable Explosives
if (_Plantable_Explosives == 1) then {
	_cfgMagazines = configFile >> "CfgMagazines";
	_Plantable_Explosives_Array = [];
	
	for "_i" from 0 to (count _cfgMagazines)-1 do
	{
		_cur_cfg = _cfgMagazines select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 2*256 && _picture != "" && !(_classname in _Plantable_Explosives_Array) && (getNumber (_cur_cfg >> "useAction") == 1)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Plantable_Explosives_Array set[count _Plantable_Explosives_Array, _classname];
			};
		};
	};
	{
		_crate addMagazineCargoGlobal [_x, _Ammocount];
	} foreach _Plantable_Explosives_Array;
};

//Grenade launcher rounds
if (_Grenade_Launcher_Ammo == 1) then {
	_cfgMagazines = configFile >> "CfgMagazines";
	_Grenade_Launch_Ammo_Array = [];
	
	for "_i" from 0 to (count _cfgMagazines)-1 do
	{
		_cur_cfg = _cfgMagazines select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 16 && _picture != "" && !(_classname in _Grenade_Launch_Ammo_Array) && !(getNumber (_cur_cfg >> "count") == 16)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Grenade_Launch_Ammo_Array set[count _Grenade_Launch_Ammo_Array, _classname];
			};
		};
	};
	{
		_crate addMagazineCargoGlobal [_x, _Ammocount];
	} foreach _Grenade_Launch_Ammo_Array;
};

//Throwable grenades, smokes, chemlights
if (_Throwables == 1) then {
	_cfgMagazines = configFile >> "CfgMagazines";
	_Throwable_Array = [];
	
	for "_i" from 0 to (count _cfgMagazines)-1 do
	{
		_cur_cfg = _cfgMagazines select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 256 && _picture != "" && !(_classname in _Throwable_Array) && (getNumber (_cur_cfg >> "count") == 1)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Throwable_Array set[count _Throwable_Array, _classname];
			};
		};
	};
	{
		_crate addMagazineCargoGlobal [_x, _Ammocount];
	} foreach _Throwable_Array;
};

//Attachments
if (_Attachments == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_Attachment_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _Attachment_Array) && ((["acc_", _classname] call BIS_fnc_inString) || (["optic_", _classname] call BIS_fnc_inString) || (["muzzle_", _classname] call BIS_fnc_inString))) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Attachment_Array set[count _Attachment_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Itemcount];
	} foreach _Attachment_Array;
};

//Items
if (_Items == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_Item_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
				if (_cur_cfg_type in [131072,4096,4] && (getText(_cur_cfg >> "displayName") != "") && _picture != "" && !(_classname in _Item_Array) && ((["item", _classname] call BIS_fnc_inString) || (["MineDetector", _classname] call BIS_fnc_inString) || (["kit", _classname] call BIS_fnc_inString) || (getNumber (_cur_cfg >> "useAsBinocular") == 1))) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Item_Array set[count _Item_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Itemcount];
	} foreach _Item_Array;
};

//Helmets/hats
if (_Headgear == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_Headgear_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _Headgear_Array) && (["H_", _classname] call BIS_fnc_inString) && !(["V_", _classname] call BIS_fnc_inString)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Headgear_Array set[count _Headgear_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Clothingcount];
	} foreach _Headgear_Array;
};

//Glasses/goggles
if (_Glasses_Goggles == 1) then {
	_cfgGlasses = configFile >> "CfgGlasses";
	_Glasses_Goggles_Array = [];
	
	for "_i" from 0 to (count _cfgGlasses)-1 do
	{
		_cur_cfg = _cfgGlasses select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 4 && _picture != "" && !(_classname in _Glasses_Goggles_Array) && (getText(_cur_cfg >> "model") != "")) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Glasses_Goggles_Array set[count _Glasses_Goggles_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Clothingcount];
	} foreach _Glasses_Goggles_Array;
};

//BLUFOR Uniforms
if (_BLUFOR_Uniforms == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_BLUFOR_Uniforms_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _BLUFOR_Uniforms_Array) && (["U_B_", _classname] call BIS_fnc_inString)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_BLUFOR_Uniforms_Array set[count _BLUFOR_Uniforms_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Clothingcount];
	} foreach _BLUFOR_Uniforms_Array;
};

//OPFOR Uniforms
if (_OPFOR_Uniforms == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_OPFOR_Uniforms_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _OPFOR_Uniforms_Array) && (["U_O_", _classname] call BIS_fnc_inString)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_OPFOR_Uniforms_Array set[count _OPFOR_Uniforms_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Clothingcount];
	} foreach _OPFOR_Uniforms_Array;
};

//Independent Uniforms
if (_Independent_Uniforms == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_Independent_Uniforms_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _Independent_Uniforms_Array) && (["U_I_", _classname] call BIS_fnc_inString)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Independent_Uniforms_Array set[count _Independent_Uniforms_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Clothingcount];
	} foreach _Independent_Uniforms_Array;
};

//Civilian Uniforms
if (_Civilian_Uniforms == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_Civilian_Uniforms_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _Civilian_Uniforms_Array) && (["U_C_", _classname] call BIS_fnc_inString)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Civilian_Uniforms_Array set[count _Civilian_Uniforms_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Clothingcount];
	} foreach _Civilian_Uniforms_Array;
};

//Guerilla Uniforms
if (_Guerilla_Uniforms == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_Guerilla_Uniforms_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _Guerilla_Uniforms_Array) && ((["U_BG_", _classname] call BIS_fnc_inString) || (["U_OG_", _classname] call BIS_fnc_inString) || (["U_IG_", _classname] call BIS_fnc_inString))) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Guerilla_Uniforms_Array set[count _Guerilla_Uniforms_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Clothingcount];
	} foreach _Guerilla_Uniforms_Array;
};

//Other Uniforms
if (_Other_Uniforms == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_Other_Uniforms_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _Other_Uniforms_Array) && !(["U_B_", _classname] call BIS_fnc_inString) && !(["U_O_", _classname] call BIS_fnc_inString) && !(["U_I_", _classname] call BIS_fnc_inString) && !(["U_BG_", _classname] call BIS_fnc_inString) && !(["U_IG_", _classname] call BIS_fnc_inString) && !(["U_OG_", _classname] call BIS_fnc_inString) && ((["U_", _classname] call BIS_fnc_inString) || (["U_OG_", _classname] call BIS_fnc_inString) || (["U_IG_", _classname] call BIS_fnc_inString))) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Other_Uniforms_Array set[count _Other_Uniforms_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Clothingcount];
	} foreach _Other_Uniforms_Array;
};

//Vests
if (_Vests == 1) then {
	_cfgWeapons = configFile >> "CfgWeapons";
	_Vest_Array = [];
	
	for "_i" from 0 to (count _cfgWeapons)-1 do
	{
		_cur_cfg = _cfgWeapons select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getNumber(_cur_cfg >> "type");
			_picture = getText(_cur_cfg >> "picture");
			if (_cur_cfg_type == 131072 && _picture != "" && !(_classname in _Vest_Array) && (["V_", _classname] call BIS_fnc_inString)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Vest_Array set[count _Vest_Array, _classname];
			};
		};
	};
	{
		_crate addItemCargoGlobal [_x, _Bagcount];
	} foreach _Vest_Array;
};

//Bags
if (_Bags == 1) then {
	_cfgVehicles = configFile >> "CfgVehicles";
	_Bag_Array = [];
	
	for "_i" from 0 to (count _cfgVehicles)-1 do
	{
		_cur_cfg = _cfgVehicles select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getText(_cur_cfg >> "vehicleClass");
			_picture = getText(_cur_cfg >> "picture");

			private ["_noItems","_noWeapons","_noMagazines","_isBag"];
			_Items_Check_Cfg = (configFile >> "CfgVehicles" >> _classname >> "TransportItems");
			if ((count _Items_Check_Cfg) == 0) then {
				_noItems = true} else {_noItems = false};
			_Weapons_Check_Cfg = (configFile >> "CfgVehicles" >> _classname >> "TransportWeapons");
			if ((count _Weapons_Check_Cfg) == 0) then {
				_noWeapons = true} else {_noWeapons = false};
			_Magazines_Check_Cfg = (configFile >> "CfgVehicles" >> _classname >> "TransportMagazines");
			if ((count _Magazines_Check_Cfg) == 0) then {
				_noMagazines = true} else {_noMagazines = false};
			if ((_noItems) && (_noWeapons) && (_noMagazines)) then {
				_isBag = true;
			}
			else
			{
				_isBag = false;
			};

			_isAssemble = (configName (configFile >> "CfgVehicles" >> _classname >> "assembleInfo")) != "";
			
			if (_cur_cfg_type == "Backpacks" && _picture != "" && !(_classname in _Bag_Array) && (_isBag) && !(_isAssemble)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Bag_Array set[count _Bag_Array, _classname];
			};
		};
	};
	{
		_crate addBackPackCargoGlobal [_x, _Bagcount];
	} foreach _Bag_Array;
};

//Preset bags
if (_Preset_Bags == 1) then {
	_cfgVehicles = configFile >> "CfgVehicles";
	_Preset_Bag_Array = [];
	
	for "_i" from 0 to (count _cfgVehicles)-1 do
	{
		_cur_cfg = _cfgVehicles select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getText(_cur_cfg >> "vehicleClass");
			_picture = getText(_cur_cfg >> "picture");
			
			private ["_noItems","_noWeapons","_noMagazines","_isBag"];
			_Items_Check_Cfg = (configFile >> "CfgVehicles" >> _classname >> "TransportItems");
			if ((count _Items_Check_Cfg) == 0) then {
				_noItems = true} else {_noItems = false};
			_Weapons_Check_Cfg = (configFile >> "CfgVehicles" >> _classname >> "TransportWeapons");
			if ((count _Weapons_Check_Cfg) == 0) then {
				_noWeapons = true} else {_noWeapons = false};
			_Magazines_Check_Cfg = (configFile >> "CfgVehicles" >> _classname >> "TransportMagazines");
			if ((count _Magazines_Check_Cfg) == 0) then {
				_noMagazines = true} else {_noMagazines = false};
			if ((_noItems) && (_noWeapons) && (_noMagazines)) then {
				_isBag = true;
			}
			else
			{
				_isBag = false;
			};
			
			_isAssemble = (configName (configFile >> "CfgVehicles" >> _classname >> "assembleInfo")) != "";
			
			if (_cur_cfg_type == "Backpacks" && _picture != "" && !(_classname in _Preset_Bag_Array) && !(_isBag) && !(_isAssemble)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Preset_Bag_Array set[count _Preset_Bag_Array, _classname];
			};
		};
	};
	{
		_crate addBackPackCargoGlobal [_x, _Bagcount];
	} foreach _Preset_Bag_Array;
};

//Assemble bags
if (_Assemble_Bags == 1) then {
	_cfgVehicles = configFile >> "CfgVehicles";
	_Assemble_Bag_Array = [];
	
	for "_i" from 0 to (count _cfgVehicles)-1 do
	{
		_cur_cfg = _cfgVehicles select _i;
		
		if (isClass _cur_cfg) then
		{
			_classname = configName _cur_cfg;
			_cur_cfg_type = getText(_cur_cfg >> "vehicleClass");
			_picture = getText(_cur_cfg >> "picture");
			
			_isAssemble = (configName (configFile >> "CfgVehicles" >> _classname >> "assembleInfo")) != "";
			
			if (_cur_cfg_type == "Backpacks" && _picture != "" && !(_classname in _Assemble_Bag_Array) && (_isAssemble)) then {
				if (_Debug == 1) then {diag_log format["Classname: %1 - Type: %2 - Pic: %3 - Cfg Dir: %4",_classname,_cur_cfg_type,_picture,_cur_cfg];};
				_Assemble_Bag_Array set[count _Assemble_Bag_Array, _classname];
			};
		};
	};
	{
		_crate addBackPackCargoGlobal [_x, _Bagcount];
	} foreach _Assemble_Bag_Array;
};

//Test bed
if (_Test_bed == 1) then {

};

if (_Refresh > 0) then {
	sleep _Refresh;
}
else
{
	breakOut "whileloop";
};
};