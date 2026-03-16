/**
 * Function: TN_round_fnc_isRoundActive
 * Author:   Bae [29th ID], modified from Dott [29th ID]
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
 *     call TN_round_fnc_isRoundActive;
 */

[true] call BIS_fnc_countdown && !TN_round_safeStartActive
