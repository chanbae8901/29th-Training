/*
 * Name:	fnc_fullSetUnitLoadout
 * Date:	7/24/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Wrapper function that ensures other functions are called with setUnitLoadout, such as
 * Should spawn this function over setUnitLoadout
 *
 * Parameter(s): 
 * ["_unit","_loadout", "_fullMagazines"]
 * Reference Syntax 2 of https://community.bistudio.com/wiki/setUnitLoadout
 * "_loadout" can also be a string representing a variable from missionNamespace
 *
 * Returns:
 * false if _unit not local, true otherwise
 *
 * Example:
 * [player, _inventory, true] spawn DOTT_fn_fullSetUnitLoadout;
 * 
 */

params
[
    "_unit",
    "_loadout",
    "_fullMagazines"
];

if (_loadout isEqualType "") then {
    _loadout = missionNamespace getVariable [_loadout, nil];
    if (isNil {_loadout}) exitWith {
        ["Loadout not found in missionNamespace"] call BIS_fnc_error; false;
    };
};

//setUnitLoadout as of 2.20 temporarily does not work non-local
if (!local _unit) exitWith {["Unit %1 must be local.", _unit] call BIS_fnc_error; false;};

//prevents incorrect weapon state when called on unit that respawned
//but did not set a loadout in arsenal in current life
_unit call DOTT_fnc_removeWeaponMags; 

//setUnitLoadout will fail if called during weapon switch	
waitUntil {sleep .1; !isSwitchingWeapon _unit};	

_unit setUnitLoadout [_loadout, _fullMagazines];
_unit spawn Hill_fnc_setInsignia;
sleep 3;
private _weaponStateMsg = format [
    "%1 has incorrect weapon state - Drop and re-equip your weapon. - On Reset",
    name _unit
];
//Weapon state should be correct due to removeWeaponMags, but check just in case
//remove in future if this never shows up in systemChat
[_unit, false, _weaponStateMsg] spawn DOTT_fnc_checkPlayerWeaponState;		
true