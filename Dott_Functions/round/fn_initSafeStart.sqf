#include "defines.hpp"

/**
 * @description Launches safe start before round start. Displays a
 *     countdown notification and delegates to the helper function
 *     which polls until the timer expires or teams unready. If
 *     _forced is true, the countdown ignores team readiness state.
 *     Forced to run on server.
 * @param {Number} _safeStartTime - Seconds between all sides ready
 *     and automatic live call. Default: TN_safeStartTime
 * @param {Boolean} _forced - Force safe start regardless of team
 *     readiness. Default: false
 * @return {Boolean} true if safe start launched, false otherwise.
 * @note Calling syntax should always include at least an empty array.
 * @example [] call DOTT_round_fnc_initSafeStart;
 */

// Server should own the waitAndExecute chain.
if (!isServer) exitWith
{
    _this remoteExec ["DOTT_round_fnc_initSafeStart", 2];
};

if !(isNil "DOTT_round_safeStartActive") exitWith {false};
if (call DOTT_round_fnc_isRoundActive) exitWith {false};

params [
    ["_safeStartTime", TN_safeStartTime],
    ["_forced", false]
];

DOTT_round_safeStartActive = true;
publicVariable "DOTT_round_safeStartActive";

/* --- Notification --- */
private _msgText = format [
    "<t color='#ffffff' size='3'>Live in %1!</t>",
    [_safeStartTime] call DOTT_round_fnc_formatTime
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
] remoteExecCall ["DOTT_common_fnc_displayMsg"];

if (_forced) then
{
    DOTT_round_ignoreReadiness = true;
    publicVariable "DOTT_round_ignoreReadiness";
};

["DOTT_round_safeStartBegin", []]
    call CBA_fnc_globalEvent;

[_safeStartTime] call BIS_fnc_countdown;

call DOTT_round_fnc_initSafeStartHelper;

true
