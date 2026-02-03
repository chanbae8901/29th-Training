/*
 * Name:	DOTT_loadout_fnc_fullSetUnitLoadout
 * Date:	1/29/2026
 * Version: 1.2
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

waitUntil { uiSleep 0.1; !isSwitchingWeapon _unit };
//EXPERIMENTAL: Apply setUnitLoadout before CBA_fnc_setLoadout to attempt prevent silent weapon bug
_unit setUnitLoadout [["hgun_PDW2000_F","","","",["30Rnd_9x21_Mag",30],[],""],
 nil, nil, nil, nil, nil, nil, nil, nil, nil];
waitUntil { uiSleep 0.5; !isSwitchingWeapon _unit };
isNil { [_unit, _loadout, _fullMagazines] call CBA_fnc_setLoadout }; //run unscheduled

//don't pull out weapon if no primary 
if (primaryWeapon _unit == "") then 
{
	_unit action ["SwitchWeapon", _unit, _unit, -1] 
};
_unit spawn DOTT_loadout_fnc_setInsignia;

true