#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Changes or cancels/unforces a currently active safe start. Will not
 * start a new safe start if one is not already active. Passing 0 or
 * less unforces the safe start so it ends if teams are not all ready.
 *
 * Arguments:
 * 0: New safe start duration in seconds. 0 or less cancels/unforces (default: 0) <NUMBER>
 *
 * Return Value:
 * true if safe start was changed, false otherwise <BOOL>
 *
 * Example:
 * [60] call TN_round_fnc_changeForcedSafeStart;
 */

params [["_seconds", 0, [0]]];

private _changed = false;

if (_seconds > 0) then {
    if (ROUND_LIVE) exitWith {};

    // Don't call a new safe start; redirect to initSafeStart for that.
    if (NOT_ROUND_SAFE) exitWith {};

    [_seconds] call BIS_fnc_countdown;

    private _formattedTime =
        [_seconds] call FUNC(formatTime);
    private _text = format [
        "<t color='#ffffff' size='2'>Forced Safe Start changed to %1!</t>",
        _formattedTime
    ];

    [
        _text,
        "PLAIN",
        0.5,
        false
    ] remoteExecCall [QEFUNC(common,displayMsg)];

    _changed = true;
} else {
    if (ROUND_SAFE) then {
        GVAR(ignoreReadiness) = false;
        publicVariable QGVAR(ignoreReadiness);
        _changed = true;
    };
};

_changed
