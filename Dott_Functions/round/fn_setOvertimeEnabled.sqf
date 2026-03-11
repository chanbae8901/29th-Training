/**
 * DOTT_round_fnc_setOvertimeEnabled
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
 *     [true] call DOTT_round_fnc_setOvertimeEnabled;
 */

params ["_enabled"];

DOTT_round_overtimeEnabled = _enabled;
publicVariable "DOTT_round_overtimeEnabled";

true
