/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Checks if the round is currently active.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * true if the round is active, false otherwise <BOOL>
 *
 * Example:
 * call TN_round_fnc_isRoundActive;
 */

[true] call BIS_fnc_countdown && !TN_round_safeStartActive
