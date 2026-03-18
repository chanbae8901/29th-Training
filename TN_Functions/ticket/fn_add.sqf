/*
 * Author: Dott [29th ID]
 * Handles adding tickets to either side. Does not use
 * BIS_fnc_respawnTickets.
 *
 * Arguments:
 * 0: The side to apply the tickets to <STRING>
 * 1: The amount of tickets to be added (or subtracted) <NUMBER>
 *
 * Return Value:
 * Nothing
 */

params
[
    ["_ticketSide", "noside", [""]],
    ["_ticketAmount", 0, [0]]
];

if (!TN_ticket_enabled) exitWith
{
    systemChat "Error: Ticket system disabled!";
};

private _ticketWEST = TN_ticket_WEST;
private _ticketEAST = TN_ticket_EAST;
private _ticketGUER = TN_ticket_GUER;

switch (_ticketSide) do
{
    case "WEST":
    {
        TN_ticket_WEST = (_ticketWEST + _ticketAmount);
        publicVariable "TN_ticket_WEST";
        format ["Blufor tickets set to %1", TN_ticket_WEST] remoteExecCall ["hint"];
    };
    case "EAST":
    {
        TN_ticket_EAST = (_ticketEAST + _ticketAmount);
        publicVariable "TN_ticket_EAST";
        format ["Opfor tickets set to %1", TN_ticket_EAST] remoteExecCall ["hint"];
    };
    case "GUER":
    {
        TN_ticket_GUER = (_ticketGUER + _ticketAmount);
        publicVariable "TN_ticket_GUER";
        format ["Grnfor tickets set to %1", TN_ticket_GUER] remoteExecCall ["hint"];
    };
    case "reset":
    {
        TN_ticket_WEST = 0;
        publicVariable "TN_ticket_WEST";
        TN_ticket_EAST = 0;
        publicVariable "TN_ticket_EAST";
        TN_ticket_GUER = 0;
        publicVariable "TN_ticket_GUER";
        "All tickets reset to zero!" remoteExecCall ["hint"];
    };
    default
    {
        systemChat "Error: No side defined!";
    };
};
