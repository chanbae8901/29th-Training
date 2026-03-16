/**
 * Function: TN_parade_fnc_forceAll
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Forces all players within a given radius of an object into
 *   parade loadout by remotely executing fn_load on each client.
 *
 * Parameters:
 *   _obj    (Object) - Center object to measure distance from
 *   _radius (Number) - Radius in meters around _obj
 *
 * Returns:
 *   true
 */

params ["_obj", "_radius"];

private _allPlayers = call BIS_fnc_listPlayers;

// Filter to players within the specified radius.
private _targets = _allPlayers select
{
    _obj distance _x <= _radius;
};

{
    [] remoteExecCall ["TN_parade_fnc_load", _x];
} forEach _targets;

true
