#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Forces all players within a given radius of an object into
 * parade loadout by remotely executing TN_parade_fnc_load on each client.
 *
 * Arguments:
 * 0: Center object to measure distance from <OBJECT>
 * 1: Radius in meters around _obj <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [myObj, 100] call TN_parade_fnc_forceAll;
 */

params ["_obj", "_radius"];

private _allPlayers = call BIS_fnc_listPlayers;

// Filter to players within the specified radius.
private _targets = _allPlayers select {
    _obj distance _x <= _radius;
};

{
    [] remoteExecCall [QFUNC(load), _x];
} forEach _targets;

nil
