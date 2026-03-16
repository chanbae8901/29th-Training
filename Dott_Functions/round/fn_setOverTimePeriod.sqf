/**
 * Function: TN_round_fnc_setOvertimePeriod
 * Author:   Bae [29th ID], modified from Dott [29th ID]
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
 *     [300] call TN_round_fnc_setOvertimePeriod;
 */

params ["_time"];

if (_time <= 0) exitWith {false};

TN_round_overtimePeriod = _time;
publicVariable "TN_round_overtimePeriod";

true
