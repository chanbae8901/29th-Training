#include "defines.hpp"

/**
 * Function: TN_round_fnc_manageReady
 * Author:   Bae [29th ID], modified from Dott [29th ID]
 *
 * Changes the ready state of a side and checks if all sides are ready
 * to start the round. If all sides become ready, initiates safe start
 * or shortens an existing forced safe start.
 *
 * Parameters:
 *     _side - Side - Which side to change ready state for.
 *     _isReady - Boolean - Desired ready state.
 *
 * Returns:
 *     Number - 2 if side already in requested state, 1 if round
 *         already started, 0 otherwise.
 *
 * Example:
 *     [west, true] call TN_round_fnc_manageReady;
 */

params ["_side", "_isReady"];

if (call TN_round_fnc_isRoundActive) exitWith {1};

private _sideIdx = _side call BIS_fnc_sideID;

if (_sideIdx > 2) exitWith
{
    systemChat "Error: Invalid side to change ready state.";
};

private _playerSideReady = TN_round_sideReady select _sideIdx;

if (_playerSideReady == _isReady) exitWith {2};

TN_round_sideReady set [_sideIdx, _isReady];
publicVariable "TN_round_sideReady";

["TN_round_manageReadyChange", _this] call CBA_fnc_globalEvent;

/* --- Check if all sides ready and handle safe start --- */
if (call TN_round_fnc_checkAllSidesReady) then
{
    if (!TN_round_safeStartActive) then
    {
        [] call TN_round_fnc_initSafeStart;
    }
    else
    {
        // Already in forced safe start; shorten timer if it exceeds safe start time.
        if (
            [0] call BIS_fnc_countdown <= TN_safeStartTime
        ) exitWith {};

        // Save forced timer state so we can restore if a team unreadies.
        TN_round_forcedTimeRemaining = [0] call BIS_fnc_countdown;
        TN_round_shortenedAt = serverTime;

        private _msgText = format [
            "<t color='#ffffff'><t size='3'>All teams ready! Shortening safe start.</t><br/><t size='2'>Live in %1!</t></t>",
            [TN_safeStartTime] call TN_round_fnc_formatTime
        ];

        [
            _msgText,
            "PLAIN",
            0.5,
            false
        ] remoteExecCall ["TN_common_fnc_displayMsg"];

        [TN_safeStartTime] call BIS_fnc_countdown;
    };
}
else
{
    // A team unreadied. If we're in a forced safe start that was shortened,
    // restore the original forced timer adjusted for total elapsed time.
    if (
        TN_round_safeStartActive
        && {TN_round_ignoreReadiness}
        && {!(isNil "TN_round_shortenedAt")}
    ) then
    {
        private _elapsed = serverTime - TN_round_shortenedAt;
        private _restoredTime = (TN_round_forcedTimeRemaining - _elapsed) max 1;
        private _currentTime = [0] call BIS_fnc_countdown;

        TN_round_shortenedAt = nil;
        TN_round_forcedTimeRemaining = nil;

        // Don't restore if the adjusted original would be shorter than current.
        if (_restoredTime <= _currentTime) exitWith {};

        [_restoredTime] call BIS_fnc_countdown;

        private _msgText = format [
            "<t color='#ffffff'><t size='2.5'>Team unreadied! Restoring longer safe start.</t><br/><t size='2'>Live in %1!</t></t>",
            [round _restoredTime] call TN_round_fnc_formatTime
        ];

        [
            _msgText,
            "PLAIN",
            0.5,
            false
        ] remoteExecCall ["TN_common_fnc_displayMsg"];
    };
};

0
