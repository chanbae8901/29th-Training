/**
 * @description Transitions to overtime if applicable, otherwise ends
 *     the round with notifications.
 * @param {Boolean} _force - Manual overriding of round end.
 *     Default: false
 * @return {Boolean} true
 * @example [true] call DOTT_round_fnc_end;
 */

params [["_force", false, [false]]];

if (DOTT_round_overtimeEnabled && !_force) then
{
    [
        "<t color='#ffffff' size='3'><br/>%1 Minute OVERTIME</t>",
        "PLAIN",
        0.5,
        true,
        DOTT_round_overtimePeriod / 60
    ] remoteExecCall ["DOTT_common_fnc_displayMsg"];

    [DOTT_round_overtimePeriod] call BIS_fnc_countdown;

    // Prevents overtime from repeating forever.
    DOTT_round_overtimeEnabled = false;
    publicVariable "DOTT_round_overtimeEnabled";

    DOTT_round_timeAdded = true;
    publicVariable "DOTT_round_timeAdded";

    [
        {(call DOTT_round_fnc_getTime) <= 0},
        {call DOTT_round_fnc_end},
        []
    ] call CBA_fnc_waitUntilAndExecute;
}
else
{
    // Let waitUntilAndExecute in fn_start call end.
    if (call DOTT_round_fnc_isRoundActive) exitWith
    {
        // In case manual end was called.
        DOTT_round_overtimeEnabled = false;
        publicVariable "DOTT_round_overtimeEnabled";
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
    ] remoteExecCall ["DOTT_common_fnc_displayMsg"];

    [-1] call BIS_fnc_countdown;
    ["DOTT_round_ended", []] call CBA_fnc_globalEvent;
};

true
