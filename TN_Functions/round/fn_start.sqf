#include "defines.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Starts the round with a specified timer length. Displays a LIVE
 * notification, kicks off the countdown, schedules the end-of-round
 * check, fires the round_started event, and clears safe start state.
 *
 * Arguments:
 * 0: Round duration in seconds (default: TN_round_timerLength) <NUMBER>
 *
 * Return Value:
 * false if round already active, true otherwise <BOOL>
 *
 * Example:
 * [] call TN_round_fnc_start;
 */

params [["_roundLength", TN_round_timerLength, [0]]];

if (ROUND_LIVE) exitWith {false};

[_roundLength] call BIS_fnc_countdown;

/* --- LIVE notification --- */
private _msgText = format [
    "<t color='#ffffff'><t size='4'>LIVE LIVE LIVE</t><br/><t size='2'>%1 Time Limit</t></t>",
    [_roundLength, true] call TN_round_fnc_formatTime
];

[
    _msgText,
    "PLAIN",
    0.5,
    false
] remoteExecCall ["TN_common_fnc_displayMsg"];

/* --- Schedule end-of-round check on server --- */
[{
    [
        {call TN_round_fnc_getTime <= 0},
        {call TN_round_fnc_end},
        []
    ] call CBA_fnc_waitUntilAndExecute;
}] remoteExecCall ["call", 2];

/* --- Reset state --- */
UNREADY_ALL_SIDES;

TN_round_state = 2;
publicVariable "TN_round_state";

[] remoteExec ["TN_round_fnc_roundEvents"];

["TN_round_started", []] call CBA_fnc_globalEvent;

true
