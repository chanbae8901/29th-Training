/**
 * DOTT_round_fnc_isRoundActive
 *
 * Checks if the round is currently active.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Boolean - true if the round is active, false otherwise.
 *
 * Example:
 *     call DOTT_round_fnc_isRoundActive;
 */

[true] call BIS_fnc_countdown && isNil "DOTT_round_safeStartActive"
