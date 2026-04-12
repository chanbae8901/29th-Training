#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Adjust lives of player when lives system is enabled.
 * The system does not use this function internally,
 * this is intended for manually adjusting specific players
 * (ex. by admin).
 *
 * Arguments:
 * 0: Player unit to reference <OBJECT>
 * 1: New number of lives <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [] call TN_event_fnc_adjustLives;
 */

if !(isServer) exitWith {_this remoteExecCall [QFUNC(adjustLives), 2]};

params ["_player", "_newLives"];
private _uid = getPlayerUID _player;
if (_uid isEqualTo "") exitWith {};

private _previousLives = GVAR(livesByUID) getOrDefault [_uid, GVAR(numberOfLives)];
if (_previousLives isEqualTo _newLives) exitWith {};

private _msg = format ["%1 lives adjusted from %2 to %3.", name _player, _previousLives, _newLives];
_msg remoteExecCall ["systemChat"];

//Switching out of spectator for no life unit will cost a life
if (_previousLives isEqualTo 0) then {
    if (GVAR(trackingLives)) then { _newLives = _newLives + 1 };
    if (ROUND_LIVE) then {[QGVAR(backInAction), [_player]] call CBA_fnc_localEvent};
};

if (_newLives isEqualTo 0) then {
     [QGVAR(outOfLives), [_player]] call CBA_fnc_localEvent;
};

GVAR(livesByUID) set [_uid, _newLives];

[QGVAR(adjustLives), [_newLives], _player] call CBA_fnc_targetEvent;