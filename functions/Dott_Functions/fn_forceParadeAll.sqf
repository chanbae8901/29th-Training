/*
 * Name:	fnc_forceParadeAll
 * Date:	8/27/2025
 * Version: 1.1
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
 * [blu_ammo, 125] call DOTT_fnc_forceParadeAll;
 * 
 */
params ["_obj", "_radius"];

private _allPlayers = call BIS_fnc_listPlayers;

private _targets = _allPlayers select 
{
	_obj distance _x <= _radius;
};

{
    private _target = _x;

    if !([_target] call DOTT_fnc_checkNonCombatLoadout) then 
	{
        [{call DOTT_fnc_forceParade; systemChat "Parade loadout applied."}] remoteExec ["call", _target];
    };
} forEach _targets;

true