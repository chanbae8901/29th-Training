/*
 * Author: Bae [29th ID]
 * Server-side function that registers or looks up a weapon name
 * in TN_tracker_weapons. Returns the index for compact event
 * storage and network transmission.
 *
 * Arguments:
 * 0: Display name of the weapon <STRING>
 *
 * Return Value:
 * Index into TN_tracker_weapons <NUMBER>
 */

params ["_weaponName"];

private _num = TN_tracker_weapons find _weaponName;

if (_num == -1) then
{
    TN_tracker_weapons pushBack _weaponName;
    _num = count TN_tracker_weapons - 1;
};

_num
