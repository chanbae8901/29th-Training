#include "defines.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Transitions to overtime if applicable, otherwise ends the round
 * with notifications.
 *
 * Arguments:
 * 0: Manual overriding of round end (default: false) <BOOL>
 *
 * Return Value:
 * true if round was active, false otherwise <BOOL>
 *
 * Example:
 * [true] call TN_round_fnc_end;
 */

params [["_force", false, [false]]];

if (NOT_ROUND_LIVE) exitWith {false};

if (GVAR(overtimeEnabled) && !_force) then {
    [
        "<t color='#ffffff' size='3'><br/>%1 Minute OVERTIME</t>",
        "PLAIN",
        0.5,
        true,
        GVAR(overtimePeriod) / 60
    ] remoteExecCall [QEFUNC(common,displayMsg)];

    [GVAR(overtimePeriod)] call BIS_fnc_countdown;

    // Prevents overtime from repeating forever.
    GVAR(overtimeEnabled) = false;
    publicVariable QGVAR(overtimeEnabled);

    GVAR(timeAdded) = true;
    publicVariable QGVAR(timeAdded);

    [
        {(call FUNC(getTime)) <= 0},
        {call FUNC(end)},
        []
    ] call CBA_fnc_waitUntilAndExecute;
} else {
    // Let waitUntilAndExecute in fn_start call end.
    if ((call FUNC(getTime)) > 0) exitWith {
        // In case manual end was called.
        GVAR(overtimeEnabled) = false;
        publicVariable QGVAR(overtimeEnabled);
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
};

true
