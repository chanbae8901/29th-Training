/**
 * @description Checks if the round is currently active.
 * @return {Boolean} true if the round is active, false otherwise.
 * @example call DOTT_round_fnc_isRoundActive;
 */

[true] call BIS_fnc_countdown && isNil "DOTT_round_safeStartActive"
