/*
 * Name:	DOTT_ticket_fnc_add
 * Date:	2/19/2024
 * Version:	1.0
 * Author:	Dott [29th ID]
 *
 * Description:
 * Handles adding tickets to either side. Does not use BIS_fnc_respawnTickets
 *
 * Parameter(s):
 * _ticketSide(string): The side to apply the tickets to
 * _ticketAmount(number): The amount of tickets to be added (or subtracted)
 *
 * Returns:
 * n/a
 *
 * Example:
 * 
 * 
 */

params 
[
	["_ticketSide","noside", [""]],
	["_ticketAmount", 0, [0]]
];

if (DOTT_ticketEnabled == false) exitWith
{
	systemChat "Error: Ticket system disabled!";
};

Private _ticketWEST = DOTT_ticketWEST;
Private _ticketEAST = DOTT_ticketEAST;
Private _ticketGUER = DOTT_ticketGUER;

switch (_ticketSide) do
{
	case "WEST": 
	{
		DOTT_ticketWEST = (_ticketWEST + _ticketAmount);
		publicVariable "DOTT_ticketWEST"; 
		format ["Blufor tickets set to %1", DOTT_ticketWEST] remoteExec ["hint"];
	};
	case "EAST": 
	{	
		DOTT_ticketEAST = (_ticketEAST + _ticketAmount);
		publicVariable "DOTT_ticketEAST";
		format ["Opfor tickets set to %1", DOTT_ticketEAST] remoteExec ["hint"];		
	};
	case "GUER": 
	{	
		DOTT_ticketGUER = (_ticketGUER + _ticketAmount);
		publicVariable "DOTT_ticketGUER";
		format ["Grnfor tickets set to %1", DOTT_ticketGUER] remoteExec ["hint"];
	};
	case "reset":
	{
		DOTT_ticketWEST = 0; publicVariable "DOTT_ticketWEST";
		DOTT_ticketEAST = 0; publicVariable "DOTT_ticketEAST";
		DOTT_ticketGUER = 0; publicVariable "DOTT_ticketGUER";
		"All tickets reset to zero!" remoteExec ["hint"];
	};
	default 
	{
		systemChat "Error: No side defined!";
	};
};