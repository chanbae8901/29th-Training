/**
 * DOTT_round_fnc_addTime
 *
 * Adds (or subtracts) time from the currently running round. Cannot
 * be used when no round is active. Notifies all players of the time
 * change via hint.
 *
 * Parameters:
 *     _timeDelta - Number - Seconds to add. Negative values subtract time.
 *
 * Returns:
 *     Number - New time remaining, or -1 if round not active.
 *
 * Example:
 *     [120] call DOTT_round_fnc_addTime;
 */

params ["_timeDelta"];

if !(call DOTT_round_fnc_isRoundActive) exitWith {-1};

private _timeLeft = call DOTT_round_fnc_getTime;
[_timeDelta + _timeLeft] call BIS_fnc_countdown;

DOTT_round_timeAdded = true;
publicVariable "DOTT_round_timeAdded";

private _hintMsg = format [
    "Added %1 minutes to the time limit!",
    _timeDelta / 60
];
[_hintMsg] remoteExec ["hint"];

call DOTT_round_fnc_getTime
