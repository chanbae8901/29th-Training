#include "defines.hpp"

/**
 * DOTT_round_fnc_manageReady
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
 *     [west, true] call DOTT_round_fnc_manageReady;
 */

params ["_side", "_isReady"];

if (call DOTT_round_fnc_isRoundActive) exitWith {1};

private _sideIdx = _side call BIS_fnc_sideID;

if (_sideIdx > 2) exitWith
{
    systemChat "Error: Invalid side to change ready state.";
};

private _playerSideReady = DOTT_round_sideReady select _sideIdx;

if (_playerSideReady == _isReady) exitWith {2};

DOTT_round_sideReady set [_sideIdx, _isReady];
publicVariable "DOTT_round_sideReady";

["DOTT_round_manageReadyChange", _this] call CBA_fnc_globalEvent;

/* --- Check if all sides ready and handle safe start --- */
if (call DOTT_round_fnc_checkAllSidesReady) then
{
    if (isNil "DOTT_round_safeStartActive") then
    {
        [] call DOTT_round_fnc_initSafeStart;
    }
    else
    {
        // Already in forced safe start; shorten timer if it exceeds safe start time.
        if (
            [0] call BIS_fnc_countdown <= TN_safeStartTime
        ) exitWith {};

        private _msgText = format [
            "<t color='#ffffff'><t size='3'>All teams ready! Shortening safe start.</t><br/><t size='2'>Live in %1!</t></t>",
            [TN_safeStartTime] call DOTT_round_fnc_formatTime
        ];

        [
            _msgText,
            "PLAIN",
            0.5,
            false
        ] remoteExecCall ["DOTT_common_fnc_displayMsg"];

        [TN_safeStartTime] call BIS_fnc_countdown;
    };
};

0
