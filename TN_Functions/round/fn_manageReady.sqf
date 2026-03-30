#include "defines.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Changes the ready state of a side and checks if all sides are ready
 * to start the round. If all sides become ready, initiates safe start
 * or shortens an existing forced safe start.
 *
 * Arguments:
 * 0: Which side to change ready state for <SIDE>
 * 1: Desired ready state <BOOL>
 *
 * Return Value:
 * 2 if side already in requested state, 1 if round already started, 0 otherwise <NUMBER>
 *
 * Example:
 * [west, true] call TN_round_fnc_manageReady;
 */

params ["_side", "_isReady"];

if (ROUND_LIVE) exitWith {1};

private _sideIdx = _side call BIS_fnc_sideID;

if (_sideIdx > 2) exitWith {
    systemChat "Error: Invalid side to change ready state.";
};

private _playerSideReady = GVAR(sideReady) select _sideIdx;

if (_playerSideReady isEqualTo _isReady) exitWith {2};

GVAR(sideReady) set [_sideIdx, _isReady];
publicVariable QGVAR(sideReady);

[QGVAR(manageReadyChange), _this] call CBA_fnc_globalEvent;

/* --- Check if all sides ready and handle safe start --- */
if (call FUNC(checkAllSidesReady)) then {
    if (NOT_ROUND_SAFE) then {
        [] call FUNC(initSafeStart);
    } else {
        // Already in forced safe start; shorten timer if it exceeds safe start time.
        if (
            [0] call BIS_fnc_countdown <= GVARMAIN(safeStartTime)
        ) exitWith {};

        // Save forced timer state so we can restore if a team unreadies.
        GVAR(forcedTimeRemaining) = [0] call BIS_fnc_countdown;
        GVAR(shortenedAt) = serverTime;

        private _msgText = format [
            "<t color='#ffffff'><t size='3'>All teams ready! Shortening safe start.</t><br/><t size='2'>Live in %1!</t></t>",
            [GVARMAIN(safeStartTime)] call FUNC(formatTime)
        ];

        [
            _msgText,
            "PLAIN",
            0.5,
            false
        ] remoteExecCall [QEFUNC(common,displayMsg)];

        [GVARMAIN(safeStartTime)] call BIS_fnc_countdown;
    };
} else {
    // A team unreadied. If we're in a forced safe start that was shortened,
    // restore the original forced timer adjusted for total elapsed time.
    if (
        ROUND_SAFE
        && GVAR(ignoreReadiness)
        && {!(isNil QGVAR(shortenedAt))}
    ) then {
        private _elapsed = serverTime - GVAR(shortenedAt);
        private _restoredTime = (GVAR(forcedTimeRemaining) - _elapsed) max 1;
        private _currentTime = [0] call BIS_fnc_countdown;

        GVAR(shortenedAt) = nil;
        GVAR(forcedTimeRemaining) = nil;

        // Don't restore if the adjusted original would be shorter than current.
        if (_restoredTime <= _currentTime) exitWith {};

        [_restoredTime] call BIS_fnc_countdown;

        private _msgText = format [
            "<t color='#ffffff'><t size='2.5'>Team unreadied! Restoring longer safe start.</t><br/><t size='2'>Live in %1!</t></t>",
            [round _restoredTime] call FUNC(formatTime)
        ];

        [
            _msgText,
            "PLAIN",
            0.5,
            false
        ] remoteExecCall [QEFUNC(common,displayMsg)];
    };
};

0
