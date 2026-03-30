/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Monitors alive player counts per side and triggers game end
 * when only one side remains. Supports both permadeath (BIRD
 * respawn) and spectate-area-based death detection.
 *
 * Requires:
 *     TN_event_fnc_game
 *     TN_round_state
 *     TN_event_spectateArea (global, if respawn-based)
 *     TN_event_spectateAreaRadius (global, if respawn-based)
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 */

#include "script_component.hpp"
#include "..\..\data\roundState.hpp"

#define RESPAWN_BIRD 1
#define ALIVE_CHECK_INTERVAL 5

if (!isServer) exitWith {};

private _respawnType = 0 call BIS_fnc_missionRespawnType;
private _remainDead = (_respawnType isEqualTo RESPAWN_BIRD);

[{
    private _args = _this getVariable "params";
    _args params ["_remainDead", "_notified"];

    private _allPlayers = call BIS_fnc_listPlayers;

    private _bluforPlayers = [];
    private _opforPlayers = [];
    private _resistancePlayers = [];

    {
        private _side = side group _x;
        switch (_side) do {
            case west: {
                _bluforPlayers pushBack _x;
            };
            case east: {
                _opforPlayers pushBack _x;
            };
            case resistance: {
                _resistancePlayers pushBack _x;
            };
            default {};
        };
    } forEach _allPlayers;

    private _numBluforDead = 0;
    private _numOpforDead = 0;
    private _numResistanceDead = 0;

    if (_remainDead) then {
        _numBluforDead = { !alive _x } count _bluforPlayers;
        _numOpforDead = { !alive _x } count _opforPlayers;
        _numResistanceDead = { !alive _x } count _resistancePlayers;
    } else {
        _numBluforDead = {
            (_x distance2D GVAR(spectateArea)) < GVAR(spectateAreaRadius)
        } count _bluforPlayers;

        _numOpforDead = {
            (_x distance2D GVAR(spectateArea)) < GVAR(spectateAreaRadius)
        } count _opforPlayers;

        _numResistanceDead = {
            (_x distance2D GVAR(spectateArea)) < GVAR(spectateAreaRadius)
        } count _resistancePlayers;
    };

    private _isBluforAlive = (count _bluforPlayers) > _numBluforDead;
    private _isOpforAlive = (count _opforPlayers) > _numOpforDead;
    private _isResistanceAlive = (count _resistancePlayers) > _numResistanceDead;

    if (!_isBluforAlive
        && !_isOpforAlive
        && !_isResistanceAlive) exitWith {
        if (!_notified) then {
            "All sides eliminated — admin should declare the winner." remoteExecCall ["systemChat", 0];
            _args set [1, true];
        };
    };

    private _winnerSide = civilian;

    if (_isBluforAlive
        && !_isOpforAlive
        && !_isResistanceAlive) then {
        _winnerSide = west;
    };
    if (!_isBluforAlive
        && _isOpforAlive
        && !_isResistanceAlive) then {
        _winnerSide = east;
    };
    if (!_isBluforAlive
        && !_isOpforAlive
        && _isResistanceAlive) then {
        _winnerSide = resistance;
    };

    if (_winnerSide isNotEqualTo civilian) then {
        [_winnerSide] call FUNC(game);
    };
}, ALIVE_CHECK_INTERVAL, [_remainDead, false], {}, {}, {true}, {NOT_ROUND_LIVE}] call CBA_fnc_createPerFrameHandlerObject;

nil
