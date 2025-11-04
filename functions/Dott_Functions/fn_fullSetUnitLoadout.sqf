/*
 * Name:	DOTT_fnc_fullSetUnitLoadout
 * Date:	9/30/2025
 * Version: 1.1
 * Author:  Bae [29th ID]
 *
 * Description:
 * Wrapper function that ensures other functions are called with setUnitLoadout.
 * Should spawn this function over setUnitLoadout when applicable.
 *
 * Parameter(s): 
 * ["_unit","_loadout", "_fullMagazines"]
 * Reference https://cbateam.github.io/CBA_A3/docs/files/loadout/fnc_setLoadout-sqf.html
 *
 * Returns:
 * false if _unit not local, true otherwise
 *
 * Example:
 * [player, _inventory, true] spawn DOTT_fnc_fullSetUnitLoadout;
 * 
 */

params["_unit", "_loadout", "_fullMagazines"];

if (!local _unit) exitWith {["Unit %1 must be local.", _unit] call BIS_fnc_error; false;};

[_unit, _loadout, _fullMagazines] call CBA_fnc_setLoadout;
//don't pull out weapon if no primary 
if (primaryWeapon _unit == "") then 
{
	_unit action ["SwitchWeapon", _unit, _unit, -1] 
};
_unit spawn Hill_fnc_setInsignia;

//prevents incorrect weapon state when called on unit that respawned
//but did not set a loadout in arsenal in current life
sleep 1; //previously 3, 2
[_unit] spawn DOTT_fnc_resetWeaponState;

true