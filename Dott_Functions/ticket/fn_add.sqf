/**
 * Function: TN_ticket_fnc_add
 * Author:   Dott [29th ID]
 *
 * Description:
 *   Handles adding tickets to either side. Does not use
 *   BIS_fnc_respawnTickets.
 *
 * Parameters:
 *   _ticketSide   (String) - The side to apply the tickets to
 *   _ticketAmount (Number) - The amount of tickets to be added
 *                            (or subtracted)
 *
 * Returns:
 *   Nothing
 */

params
[
    ["_ticketSide", "noside", [""]],
    ["_ticketAmount", 0, [0]]
];

if (TN_ticketEnabled == false) exitWith
{
    systemChat "Error: Ticket system disabled!";
};

private _ticketWEST = TN_ticketWEST;
private _ticketEAST = TN_ticketEAST;
private _ticketGUER = TN_ticketGUER;

switch (_ticketSide) do
{
    case "WEST":
    {
        TN_ticketWEST = (_ticketWEST + _ticketAmount);
        publicVariable "TN_ticketWEST";
        format ["Blufor tickets set to %1", TN_ticketWEST] remoteExecCall ["hint"];
    };
    case "EAST":
    {
        TN_ticketEAST = (_ticketEAST + _ticketAmount);
        publicVariable "TN_ticketEAST";
        format ["Opfor tickets set to %1", TN_ticketEAST] remoteExecCall ["hint"];
    };
    case "GUER":
    {
        TN_ticketGUER = (_ticketGUER + _ticketAmount);
        publicVariable "TN_ticketGUER";
        format ["Grnfor tickets set to %1", TN_ticketGUER] remoteExecCall ["hint"];
    };
    case "reset":
    {
        TN_ticketWEST = 0;
        publicVariable "TN_ticketWEST";
        TN_ticketEAST = 0;
        publicVariable "TN_ticketEAST";
        TN_ticketGUER = 0;
        publicVariable "TN_ticketGUER";
        "All tickets reset to zero!" remoteExecCall ["hint"];
    };
    default
    {
        systemChat "Error: No side defined!";
    };
};
