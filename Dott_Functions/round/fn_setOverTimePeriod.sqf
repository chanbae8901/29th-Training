/**
 * DOTT_round_fnc_setOvertimePeriod
 *
 * Sets the overtime period duration. Rejects non-positive values.
 *
 * Parameters:
 *     _time - Number - Overtime duration in seconds.
 *
 * Returns:
 *     Boolean - true on success, false if rejected.
 *
 * Example:
 *     [300] call DOTT_round_fnc_setOvertimePeriod;
 */

params ["_time"];

if (_time <= 0) exitWith {false};

DOTT_round_overtimePeriod = _time;
publicVariable "DOTT_round_overtimePeriod";

true
