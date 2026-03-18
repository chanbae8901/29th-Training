/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Sets the overtime period duration. Rejects non-positive values.
 *
 * Arguments:
 * 0: Overtime duration in seconds <NUMBER>
 *
 * Return Value:
 * true on success, false if rejected <BOOL>
 *
 * Example:
 * [300] call TN_round_fnc_setOvertimePeriod;
 */

params ["_time"];

if (_time <= 0) exitWith {false};

TN_round_overtimePeriod = _time;
publicVariable "TN_round_overtimePeriod";

true
