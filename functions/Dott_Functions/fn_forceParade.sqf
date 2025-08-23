/*
 * Name:	fnc_forceParade
 * Date:	8/8/2025
 * Version: 1.0
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
 * [blu_ammo, 125] call DOTT_fnc_forceParade;
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
        [_target, 
        {
            params ["_unit"];
            [_unit, missionConfigFile >> "CfgRespawnInventory" >> "29TH_PARADE_WEST"] call BIS_fnc_loadInventory;
            _unit spawn Hill_fnc_setInsignia;
            systemChat "Parade loadout applied.";
        }] remoteExec ["call", _target];
    };
} forEach _targets;

true