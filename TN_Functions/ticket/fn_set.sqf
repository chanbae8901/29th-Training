#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Sets tickets for a side to an absolute value. If the round is not live,
 * modifies startingCounts (pre-round config); if live, modifies counts directly.
 *
 * Arguments:
 * 0: The side to set tickets for <SIDE>
 * 1: The amount to set tickets to <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [west, 10] call TN_ticket_fnc_set;
 */

params
[
    ["_side", sideUnknown],
    ["_ticketAmount", 0, [0]]
];

if (!GVAR(enabled)) exitWith {
    systemChat "Error: Ticket system disabled!";
};

private _sideID = _side call BIS_fnc_sideID;

if (_sideID < 0 || _sideID > 2) exitWith {
    systemChat "Error: No side defined!";
};

private _newTotal = _ticketAmount max 0;

if (ROUND_LIVE) then {
    GVAR(counts) set [_sideID, _newTotal];
    publicVariable QGVAR(counts);
} else {
    GVAR(startingCounts) set [_sideID, _newTotal];
    publicVariable QGVAR(startingCounts);
};

private _sideName = [_side] call EFUNC(common,convertSide);
[format ["%1 tickets set to %2", _sideName, _newTotal]] remoteExecCall [QEFUNC(common,timedHint), _side];

nil
