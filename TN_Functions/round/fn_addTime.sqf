#include "script_component.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Adds (or subtracts) time from the currently running round. Cannot
 * be used when no round is active. Notifies all players of the time
 * change via hint.
 *
 * Arguments:
 * 0: Seconds to add. Negative values subtract time <NUMBER>
 *
 * Return Value:
 * New time remaining, or -1 if round not active <NUMBER>
 *
 * Example:
 * [120] call TN_round_fnc_addTime;
 */

params ["_timeDelta"];

if (NOT_ROUND_LIVE) exitWith {-1};

private _timeLeft = call FUNC(getTime);
[_timeDelta + _timeLeft] call BIS_fnc_countdown;

GVAR(timeAdded) = true;
publicVariable QGVAR(timeAdded);

private _hintMsg = format [
    "Added %1 minutes to the time limit!",
    _timeDelta / 60
];
[_hintMsg] remoteExecCall ["hint"];

call FUNC(getTime)
