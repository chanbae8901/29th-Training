/**
 * Function: TN_round_fnc_setOvertimeEnabled
 * Author:   Bae [29th ID], modified from Dott [29th ID]
 *
 * Enables or disables overtime for the current round.
 *
 * Parameters:
 *     _enabled - Boolean - true to enable, false to disable.
 *
 * Returns:
 *     Boolean - true
 *
 * Example:
 *     [true] call TN_round_fnc_setOvertimeEnabled;
 */

params ["_enabled"];

TN_round_overtimeEnabled = _enabled;
publicVariable "TN_round_overtimeEnabled";

true
