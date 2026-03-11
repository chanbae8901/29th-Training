/**
 * @description Sets the round timer length. Cannot be used while the
 *     round is active (use addTime instead). Rejects non-positive
 *     values.
 * @param {Number} _time - Round length in seconds.
 * @return {Boolean} true on success, false if rejected.
 * @example [1200] call DOTT_round_fnc_setTimer;
 */

params ["_time"];

if (
    _time <= 0 || call DOTT_round_fnc_isRoundActive
) exitWith {false};

DOTT_round_timerLength = _time;
publicVariable "DOTT_round_timerLength";

true
