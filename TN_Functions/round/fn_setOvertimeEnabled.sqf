/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Enables or disables overtime for the current round.
 *
 * Arguments:
 * 0: true to enable, false to disable <BOOL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [true] call TN_round_fnc_setOvertimeEnabled;
 */

params ["_enabled"];

TN_round_overtimeEnabled = _enabled;
publicVariable "TN_round_overtimeEnabled";

nil
