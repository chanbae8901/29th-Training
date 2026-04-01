#include "defines.hpp"

#define SAFE_START_POLL_INTERVAL 0.2

/*
 * Author: Bae [29th ID]
 * Helper function for initSafeStart. Registers a perFrameHandler
 * that polls every 0.2 seconds until the safe start countdown
 * expires (then starts the round) or until teams are no longer all
 * ready and forced mode is off (then aborts the countdown).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_round_fnc_initSafeStartHelper;
 */

[{
    params ["", "_handle"];

    if (NOT_ROUND_SAFE) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _allSidesReady = call FUNC(checkAllSidesReady);

    /* --- Abort if a team unreadied and we're not forced --- */
    if !(_allSidesReady || GVAR(ignoreReadiness)) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;

        [
            "<t color='#ffffff' size='4'>Timer Aborted!</t>",
            "PLAIN",
            0.5
        ] remoteExecCall [QEFUNC(common,displayMsg)];

        RESET_SAFESTART_VARS;
        [-1] call BIS_fnc_countdown;

        [QGVAR(safeStartAborted), []] call CBA_fnc_globalEvent;
    };

    /* --- Go live when countdown expires --- */
    if (([0] call BIS_fnc_countdown) <= 0) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;

        RESET_SAFESTART_VARS;
        [] call FUNC(start);
    };
}, SAFE_START_POLL_INTERVAL] call CBA_fnc_addPerFrameHandler;

nil
