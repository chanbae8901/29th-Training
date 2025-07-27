/*
 * Name:	fnc_safeSetUnitLoadout
 * Date:	7/24/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Wrapper function that removes causes of inaudible weapon glitch when applying loadout to unit.
 * Also applies squad insignia.
 * Should spawn this function over setUnitLoadout
 *
 * Parameter(s): 
 * ["_unit","_loadout", "_fullMagazines"]
 * Reference Syntax 2 of https://community.bistudio.com/wiki/setUnitLoadout
 *
 * Returns:
 * false if _unit not local, true otherwise
 *
 * Example:
 * [player, _inventory, true] spawn DOTT_fn_safeSetUnitLoadout;
 * 
 */

params
[
    "_unit",
    "_loadout",
    "_fullMagazines"
];

//setUnitLoadout as of 2.20 temporarily does not work non-local
if (!local _unit) exitWith {["Unit %1 must be local.", _unit] call BIS_fnc_error; false;};

_unit call DOTT_fnc_removeWeaponMags; //prevent inaudible weapon bug

//setUnitLoadout will fail if called during weapon switch	
//also give time for empty mags to sync to server
waitUntil {sleep .01; !isSwitchingWeapon _unit};	

_unit setUnitLoadout [_loadout, _fullMagazines];
_unit spawn Hill_fnc_setInsignia;
true