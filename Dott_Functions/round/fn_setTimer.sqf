/**
 * DOTT_round_fnc_setTimer
 *
 * Sets the round timer length. Cannot be used while the round is
 * active (use addTime instead). Rejects non-positive values.
 *
 * Parameters:
 *     _time - Number - Round length in seconds.
 *
 * Returns:
 *     Boolean - true on success, false if rejected.
 *
 * Example:
 *     [1200] call DOTT_round_fnc_setTimer;
 */

params ["_time"];

if (
    _time <= 0 || call DOTT_round_fnc_isRoundActive
) exitWith {false};

DOTT_round_timerLength = _time;
publicVariable "DOTT_round_timerLength";

true
