#include "defines.hpp"

/**
 * DOTT_round_fnc_start
 *
 * Starts the round with a specified timer length. Displays a LIVE
 * notification, kicks off the countdown, schedules the end-of-round
 * check, fires the round_started event, and clears safe start state.
 *
 * Parameters:
 *     _roundLength - Number - Round duration in seconds.
 *         Default: DOTT_round_timerLength
 *
 * Returns:
 *     Boolean - false if round already active, true otherwise.
 *
 * Example:
 *     [] call DOTT_round_fnc_start;
 */

params [["_roundLength", DOTT_round_timerLength, [0]]];

if (call DOTT_round_fnc_isRoundActive) exitWith {false};

[_roundLength] call BIS_fnc_countdown;

/* --- LIVE notification --- */
private _msgText = format [
    "<t color='#ffffff'><t size='4'>LIVE LIVE LIVE</t><br/><t size='2'>%1 Time Limit</t></t>",
    [_roundLength, true] call DOTT_round_fnc_formatTime
];

[
    _msgText,
    "PLAIN",
    0.5,
    false
] remoteExecCall ["DOTT_common_fnc_displayMsg"];

/* --- Schedule end-of-round check on server --- */
[{
    [
        {(call DOTT_round_fnc_getTime) <= 0},
        {call DOTT_round_fnc_end},
        []
    ] call CBA_fnc_waitUntilAndExecute;
}] remoteExecCall ["call", 2];

/* --- Reset state --- */
UNREADY_ALL_SIDES;

DOTT_round_safeStartActive = nil;
publicVariable "DOTT_round_safeStartActive";

[] remoteExec ["DOTT_round_fnc_roundEvents"];

["DOTT_round_started", []] call CBA_fnc_globalEvent;

true
