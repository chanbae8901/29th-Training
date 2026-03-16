/**
 * Function: TN_tracker_fnc_weaponToNum
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Server-side function that registers or looks up a weapon name
 * in TN_tracker_weapons. Returns the index for compact event
 * storage and network transmission.
 *
 * Parameters:
 * _weaponName (String): Display name of the weapon.
 *
 * Returns:
 * Number -- index into TN_tracker_weapons.
 */

params ["_weaponName"];

private _num = TN_tracker_weapons find _weaponName;

if (_num == -1) then
{
    TN_tracker_weapons pushBack _weaponName;
    _num = count TN_tracker_weapons - 1;
};

_num
