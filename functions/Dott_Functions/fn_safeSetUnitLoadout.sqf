/*
 * Name:	fnc_safeSetUnitLoadout
 * Date:	7/24/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Wrapper function that removes causes of inaudible weapon glitch when applying loadout to unit.
 * Should spawn this function over setUnitLoadout
 * Can only spawn due to sleep
 *
 * Parameter(s): 
 * ["_unit","_loadout", "_fullMagazines"]
 * Reference Syntax 2 of https://community.bistudio.com/wiki/setUnitLoadout
 *
 * Returns:
 * n/a
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

_unit call DOTT_fnc_removeWeaponMags; //prevent inaudible weapon bug

//setUnitLoadout will fail if called during weapon switch	
//also give time for empty mags to sync to server
private _curTime = time;
waitUntil {sleep .01; !isSwitchingWeapon _unit};	

player setUnitLoadout [_loadout, _fullMagazines];