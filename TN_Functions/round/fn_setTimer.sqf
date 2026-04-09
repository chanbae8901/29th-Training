#include "script_component.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Sets the round timer length. Cannot be used while the round is
 * active (use addTime instead). Rejects non-positive values.
 *
 * Arguments:
 * 0: Round length in seconds <NUMBER>
 *
 * Return Value:
 * true on success, false if rejected <BOOL>
 *
 * Example:
 * [1200] call TN_round_fnc_setTimer;
 */

params ["_time"];

if (
    _time <= 0 || ROUND_LIVE
) exitWith {false};

GVAR(timerLength) = _time;
publicVariable QGVAR(timerLength);

true
