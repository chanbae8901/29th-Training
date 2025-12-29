/*
 * Name:	DOTT_parade_fnc_forceAll
 * Date:	9/30/2025
 * Version: 1.2
 * Author:  Bae [29th ID]
 *
 * Description:
 * Swaps any player not in non-combat uniforms to parade uniforms within _radius from _obj.
 *
 * Parameter(s): 
 * _obj (Object): The object to check around.
 * _radius (Number): The radius around the object to check for players.
 *
 * Returns:
 * true
 *
 * Example:
 * [blu_ammo, 125] call DOTT_parade_fnc_forceAll;
 * 
 */
params ["_obj", "_radius"];

private _allPlayers = call BIS_fnc_listPlayers;

private _targets = _allPlayers select 
{
	_obj distance _x <= _radius;
};

{
    [] remoteExec ["DOTT_parade_fnc_load", _x];
} forEach _targets;

true