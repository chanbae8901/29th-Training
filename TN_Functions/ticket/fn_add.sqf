#include "script_component.hpp"
/*
 * Author: Dott [29th ID]
 * Handles adding tickets to either side. Does not use
 * BIS_fnc_respawnTickets.
 *
 * Arguments:
 * 0: The side to apply the tickets to <SIDE>
 * 1: The amount of tickets to be added (or subtracted) <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [west, 5] call TN_ticket_fnc_add;
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

private _newTotal = (GVAR(counts) select _sideID) + _ticketAmount;
GVAR(counts) set [_sideID, _newTotal];
publicVariable QGVAR(counts);

private _sideName = [_side] call EFUNC(common,convertSide);
format ["%1 tickets set to %2", _sideName, _newTotal] remoteExecCall ["hint"];

nil
