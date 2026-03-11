/**
 * File: fn_weaponToNum.sqf
 * Function: DOTT_tracker_fnc_weaponToNum
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Server-side function that registers or looks up a weapon name
 * in DOTT_tracker_weapons. Returns the index for compact event
 * storage and network transmission.
 *
 * Parameters:
 * _weaponName (String): Display name of the weapon.
 *
 * Returns:
 * Number -- index into DOTT_tracker_weapons.
 */

params ["_weaponName"];

private _num = DOTT_tracker_weapons find _weaponName;

if (_num == -1) then
{
    DOTT_tracker_weapons pushBack _weaponName;
    _num = count DOTT_tracker_weapons - 1;
};

_num
