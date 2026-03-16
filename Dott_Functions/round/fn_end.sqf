/**
 * Function: TN_round_fnc_end
 * Author:   Bae [29th ID], modified from Dott [29th ID]
 *
 * Transitions to overtime if applicable, otherwise ends the round
 * with notifications.
 *
 * Parameters:
 *     _force - Boolean - Manual overriding of round end. Default: false
 *
 * Returns:
 *     Boolean - true
 *
 * Example:
 *     [true] call TN_round_fnc_end;
 */

params [["_force", false, [false]]];

if (TN_round_overtimeEnabled && !_force) then
{
    [
        "<t color='#ffffff' size='3'><br/>%1 Minute OVERTIME</t>",
        "PLAIN",
        0.5,
        true,
        TN_round_overtimePeriod / 60
    ] remoteExecCall ["TN_common_fnc_displayMsg"];

    [TN_round_overtimePeriod] call BIS_fnc_countdown;

    // Prevents overtime from repeating forever.
    TN_round_overtimeEnabled = false;
    publicVariable "TN_round_overtimeEnabled";

    TN_round_timeAdded = true;
    publicVariable "TN_round_timeAdded";

    [
        {(call TN_round_fnc_getTime) <= 0},
        {call TN_round_fnc_end},
        []
    ] call CBA_fnc_waitUntilAndExecute;
}
else
{
    // Let waitUntilAndExecute in fn_start call end.
    if (call TN_round_fnc_isRoundActive) exitWith
    {
        // In case manual end was called.
        TN_round_overtimeEnabled = false;
        publicVariable "TN_round_overtimeEnabled";
        [-1] call BIS_fnc_countdown;
        true
    };

    // Implies called when round not running.
    if (_force) exitWith {true};

    // Let round naturally end on non-forced case.
    [
        "<t color='#ffffff' size='5'>GAME!</t>",
        "PLAIN",
        0.4
    ] remoteExecCall ["TN_common_fnc_displayMsg"];

    [-1] call BIS_fnc_countdown;
    ["TN_round_ended", []] call CBA_fnc_globalEvent;
};

true
