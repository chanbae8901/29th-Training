/*
 * Author: Bae [29th ID]
 * Initializes the event-driven alive check system. Tracks
 * per-side player counts and ends the round when only one
 * side has players with lives remaining.
 *
 * Called once at init. Listens for round start, player
 * elimination, disconnect, and JIP events.
 *
 * Requires:
 *     TN_event_fnc_endMission
 *     TN_event_livesByUID
 *     TN_event_numberOfLives
 *     TN_round_state
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_initAliveCheck;
 */

#include "script_component.hpp"
#define CHECK_DELAY 1 //Grace period for trades that result in no team standing 

if (!isServer) exitWith {};

// --- Winner check function ---
FUNC(checkWinner) = {
    private _aliveSides = GVAR(aliveCounts) select { _x > 0 };
    private _numAlive = count _aliveSides;

    if (_numAlive > 1) exitWith {};

    if (_numAlive isEqualTo 0) exitWith {
        if (isNil QGVAR(notifiedAllDead)) then
        {
            GVAR(notifiedAllDead) = true;
            [{
                private _msg = "All teams eliminated!";
                _msg remoteExecCall [QEFUNC(common,timedHint)];
                _msg remoteExecCall ["systemChat"];
            }, {}, 5] call CBA_fnc_waitAndExecute;
            ["All sides eliminated — admin should declare the winner.", true, true]
                call EFUNC(common,notifyAdmin);
        };
    };

    private _winIdx = GVAR(aliveCounts) findIf { _x > 0 };
    private _winningSide = _winIdx call BIS_fnc_sideType;
    if (!GVAR(missionEnded)) then {
        [{
            params["_winningSide"];
            private _sideName = _winningSide call EFUNC(common,convertSide);
            private _msg = format ["%1 is the only team left standing!", _sideName];
            _msg remoteExecCall [QEFUNC(common,timedHint)];
            _msg remoteExecCall ["systemChat"];
            [_winningSide, ENDING_DELAY] call FUNC(endMission);
        }, _winningSide, 5] call CBA_fnc_waitAndExecute;
    };
};

// --- Round start: build initial counts ---
[QEGVAR(round,started), {
    private _counts = [0, 0, 0];

    {
        private _sideIdx = (side group _x) call BIS_fnc_sideId;
        if (_sideIdx > 2) then { continue };

        private _uid = getPlayerUID _x;
        private _lives = GVAR(livesByUID) getOrDefault [
            _uid, GVAR(numberOfLives)
        ];
        if (_lives > 0) then {
            _counts set [_sideIdx, (_counts select _sideIdx) + 1];
        };
    } forEach (call BIS_fnc_listPlayers);

    GVAR(aliveCounts) = _counts;
}] call CBA_fnc_addEventHandler;

// --- Player out of lives ---
[QGVAR(outOfLives), {
    params ["_unit"];
    if (NOT_ROUND_LIVE) exitWith {};

    private _sideIdx = (side group _unit) call BIS_fnc_sideId;
    if (_sideIdx > 2) exitWith {};

    private _newCount = (GVAR(aliveCounts) select _sideIdx) - 1;
    GVAR(aliveCounts) set [_sideIdx, _newCount max 0];
    [FUNC(checkWinner), {}, CHECK_DELAY] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;

// --- Player disconnect ---
addMissionEventHandler ["HandleDisconnect", {
    params ["_unit", "_id", "_uid"];
    if (NOT_ROUND_LIVE) exitWith { false };

    private _sideIdx = (side group _unit) call BIS_fnc_sideId;
    if (_sideIdx > 2) exitWith { false };

    private _lives = GVAR(livesByUID) getOrDefault [
        _uid, GVAR(numberOfLives)
    ];
    if (_lives > 0) then {
        private _newCount = (GVAR(aliveCounts) select _sideIdx) - 1;
        GVAR(aliveCounts) set [_sideIdx, _newCount max 0];
        [FUNC(checkWinner), {}, CHECK_DELAY] call CBA_fnc_waitAndExecute;
    };

    false
}];

// --- JIP player with lives ---
[QGVAR(jipLivesResolved), {
    params ["_player", "_lives"];
    if (NOT_ROUND_LIVE) exitWith {};
    if (_lives <= 0) exitWith {};

    private _sideIdx = (side group _player) call BIS_fnc_sideId;
    if (_sideIdx > 2) exitWith {};

    GVAR(aliveCounts) set [
        _sideIdx,
        (GVAR(aliveCounts) select _sideIdx) + 1
    ];
}] call CBA_fnc_addEventHandler;

nil
