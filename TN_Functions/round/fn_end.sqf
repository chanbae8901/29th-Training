#include "defines.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Ends the round with notifications.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * true if round was active, false otherwise <BOOL>
 *
 * Example:
 * call TN_round_fnc_end;
 */

if (NOT_ROUND_LIVE) exitWith {false};

// Let waitUntilAndExecute in fn_start call end
// if manual end was called.
if ((call FUNC(getTime)) > 0) exitWith {
    [-1] call BIS_fnc_countdown;
    true
};

// Let round naturally end on non-forced case.
[
    "<t color='#ffffff' size='5'>GAME!</t>",
    "PLAIN",
    0.4
] remoteExecCall [QEFUNC(common,displayMsg)];

[-1] call BIS_fnc_countdown;
GVAR(state) = 0;
publicVariable QGVAR(state);
[QGVAR(ended), []] call CBA_fnc_globalEvent;

true
