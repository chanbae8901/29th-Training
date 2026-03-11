#include "defines.hpp"

/**
 * DOTT_round_fnc_initSafeStartHelper
 *
 * Helper function for initSafeStart. Polls every 0.2 seconds until
 * the safe start countdown expires (then starts the round) or until
 * teams are no longer all ready and forced mode is off (then aborts
 * the countdown).
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Boolean - true
 *
 * Example:
 *     call DOTT_round_fnc_initSafeStartHelper;
 */

if (isNil "DOTT_round_safeStartActive") exitWith {true};

private _allSidesReady =
    call DOTT_round_fnc_checkAllSidesReady;

/* --- Abort if a team unreadied and we're not forced --- */
if !(_allSidesReady || DOTT_round_ignoreReadiness) exitWith
{
    [
        "<t color='#ffffff' size='4'>Timer Aborted!</t>",
        "PLAIN",
        0.5
    ] remoteExec ["DOTT_common_fnc_displayMsg"];

    RESET_SAFESTART_VARS;
    [-1] call BIS_fnc_countdown;

    ["DOTT_round_safeStartAborted", []]
        call CBA_fnc_globalEvent;

    true
};

/* --- Continue polling or go live --- */
if (([0] call BIS_fnc_countdown) > 0) then
{
    [
        {call DOTT_round_fnc_initSafeStartHelper},
        [],
        0.2
    ] call CBA_fnc_waitAndExecute;
}
else
{
    RESET_SAFESTART_VARS;
    [] call DOTT_round_fnc_start;
};

true
