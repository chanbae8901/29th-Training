#include "defines.hpp"

/**
 * Function: TN_round_fnc_initSafeStart
 * Author:   Bae [29th ID], modified from Dott [29th ID]
 *
 * Launches safe start before round start. Displays a countdown
 * notification and delegates to the helper function which polls until
 * the timer expires or teams unready. If _forced is true, the
 * countdown ignores team readiness state. Forced to run on server.
 * Calling syntax should always include at least an empty array.
 *
 * Parameters:
 *     _safeStartTime - Number - Seconds between all sides ready and
 *         automatic live call. Default: TN_safeStartTime
 *     _forced - Boolean - Force safe start regardless of team
 *         readiness. Default: false
 *
 * Returns:
 *     Boolean - true if safe start launched, false otherwise.
 *
 * Example:
 *     [] call TN_round_fnc_initSafeStart;
 */

// Server should own the waitAndExecute chain.
if (!isServer) exitWith
{
    _this remoteExecCall ["TN_round_fnc_initSafeStart", 2];
};

if (TN_round_safeStartActive) exitWith {false};
if (call TN_round_fnc_isRoundActive) exitWith {false};

params [
    ["_safeStartTime", TN_safeStartTime],
    ["_forced", false]
];

TN_round_safeStartActive = true;
publicVariable "TN_round_safeStartActive";

/* --- Notification --- */
private _msgText = format [
    "<t color='#ffffff' size='3'>Live in %1!</t>",
    [_safeStartTime] call TN_round_fnc_formatTime
];

if (_forced) then
{
    _msgText = _msgText
        + "<br/>Teams can still ready up to end safe start early.";
};

[
    _msgText,
    "PLAIN",
    0.5,
    false
] remoteExecCall ["TN_common_fnc_displayMsg"];

if (_forced) then
{
    TN_round_ignoreReadiness = true;
    publicVariable "TN_round_ignoreReadiness";
};

["TN_round_safeStartBegin", []] call CBA_fnc_globalEvent;

[_safeStartTime] call BIS_fnc_countdown;

call TN_round_fnc_initSafeStartHelper;

true
