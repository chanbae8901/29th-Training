/*
 * Name:	DOTT_loadout_fnc_fullSetUnitLoadout
 * Date:	03/06/2026
 * Version: 1.4
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
 * false if _unit not local or alive, true otherwise
 *
 * Example:
 * [player, _inventory, true] spawn DOTT_loadout_fnc_fullSetUnitLoadout;
 * 
 */

params["_unit", "_loadout", "_fullMagazines"];

if (!local _unit) exitWith {["Unit %1 must be local.", _unit] call BIS_fnc_error; false;};

if (!alive _unit) exitWith { false };

isNil { [_unit, _loadout, _fullMagazines] call CBA_fnc_setLoadout }; //run unscheduled

//don't pull out weapon if no primary 
if (primaryWeapon _unit == "") then 
{
	_unit action ["SwitchWeapon", _unit, _unit, -1] 
};

private _scriptHandle = [_unit] spawn DOTT_loadout_fnc_resetWeaponState;

//wait so that setInsignia does not correctly assume non-combat loadout
[_unit, _scriptHandle] spawn {
	params ["_unit", "_scriptHandle"];
	waitUntil { scriptDone _scriptHandle };
	_unit spawn DOTT_loadout_fnc_setInsignia;
};

true