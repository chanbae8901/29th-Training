/*
 * Name:	DOTT_loadout_fnc_resetWeaponState
 * Date:	02/04/2026
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Attempt reset of weapon state for a unit to prevent silent weapon bug.
 * If no primary weapon, will naturally not do anything.
 *
 * Parameter(s): 
 * _unit: local unit that needs to reset weapon state
 * 
 * Returns:
 * true
 *
 * Example:
 * [_unit] spawn DOTT_loadout_fnc_resetWeaponState;
 * 
 */

params["_unit"];

waitUntil { sleep 0.2; (weaponState _unit) select 6 == 0 }; //wait until unit is not reloading
private _primaryMags = primaryWeaponMagazine _unit;

{
	_unit removePrimaryWeaponItem _x;
}
forEach _primaryMags;

sleep 0.5;

{
	_unit addPrimaryWeaponItem _x;
} forEach _primaryMags;
