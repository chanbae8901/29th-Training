#include "defines.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Launches safe start before round start. Displays a countdown
 * notification and delegates to the helper function which polls until
 * the timer expires or teams unready. If _forced is true, the
 * countdown ignores team readiness state. Forced to run on server.
 * Calling syntax should always include at least an empty array.
 *
 * Arguments:
 * 0: Seconds between all sides ready and automatic live call (default: TN_safeStartTime) <NUMBER>
 * 1: Force safe start regardless of team readiness (default: false) <BOOL>
 *
 * Return Value:
 * true if safe start launched, false otherwise <BOOL>
 *
 * Example:
 * [] call TN_round_fnc_initSafeStart;
 */

// Server should own the perFrameHandler.
if (!isServer) exitWith {
    _this remoteExecCall [QFUNC(initSafeStart), 2];
};

if (NOT_ROUND_IDLE) exitWith {false};

params [
    ["_safeStartTime", GVARMAIN(safeStartTime)],
    ["_forced", false]
];

GVAR(state) = 1;
publicVariable QGVAR(state);

/* --- Notification --- */
private _msgText = format [
    "<t color='#ffffff' size='3'>Live in %1!</t>",
    [_safeStartTime] call FUNC(formatTime)
];

if (_forced) then {
    _msgText = _msgText
        + "<br/>Teams can still ready up to end safe start early.";
};

[
    _msgText,
    "PLAIN",
    0.5,
    false
] remoteExecCall [QEFUNC(common,displayMsg)];

if (_forced) then {
    GVAR(ignoreReadiness) = true;
    publicVariable QGVAR(ignoreReadiness);
};

[QGVAR(safeStartBegin), []] call CBA_fnc_globalEvent;

[_safeStartTime] call BIS_fnc_countdown;

call FUNC(initSafeStartHelper);

true
