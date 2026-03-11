/**
 * @description Sets the overtime period duration. Rejects
 *     non-positive values.
 * @param {Number} _time - Overtime duration in seconds.
 * @return {Boolean} true on success, false if rejected.
 * @example [300] call DOTT_round_fnc_setOvertimePeriod;
 */

params ["_time"];

if (_time <= 0) exitWith {false};

DOTT_round_overtimePeriod = _time;
publicVariable "DOTT_round_overtimePeriod";

true
