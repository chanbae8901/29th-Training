/*
 * Name:	DOTT_round_fnc_isRoundActive
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Checks if the round is currently active.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true if the round is active, false otherwise.
 *
 * Example:
 * call DOTT_round_fnc_isRoundActive;
 * 
 */

[true] call BIS_fnc_countdown && isNil "DOTT_safeStartActive"