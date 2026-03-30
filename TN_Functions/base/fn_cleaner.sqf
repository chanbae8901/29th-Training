#include "script_component.hpp"

/*
 * Author: Rellikplug AKA Hill [29th ID]
 * Removes all dead bodies globally and deletes loose
 * ground items (weapons, magazines) within 250 meters
 * of each garbage can object in TN_base_garbages. Intended
 * to be attached to garbage cans via addAction.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * false if nothing was deleted, true otherwise <BOOL>
 *
 * Example:
 * call TN_base_fnc_cleaner;
 */

private _dead = allDeadMen;

//  get items around trash cans
private _nearObjects = [];
{
    _nearObjects append (nearestObjects [_x, ["WeaponHolder", "GroundWeaponHolder"], 250]);
} forEach GVAR(garbages);

private _countObjects = count _nearObjects;
private _countDead = count _dead;
private _countAllNear = _countObjects + _countDead;

if (_countAllNear < 1) exitWith {
    hintSilent "Nothing to delete.";
    false
};

{ deleteVehicle _x; } forEach _dead;
{ deleteVehicle _x; } forEach _nearObjects;

private _text = format ["Cleaned:\n%1 Objects\n%2 Dead Bodies", _countObjects, _countDead];
hintSilent _text;
true
