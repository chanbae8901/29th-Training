/**
 * @description Enables or disables overtime for the current round.
 * @param {Boolean} _enabled - true to enable, false to disable.
 * @return {Boolean} true
 * @example [true] call DOTT_round_fnc_setOvertimeEnabled;
 */

params ["_enabled"];

DOTT_round_overtimeEnabled = _enabled;
publicVariable "DOTT_round_overtimeEnabled";

true
