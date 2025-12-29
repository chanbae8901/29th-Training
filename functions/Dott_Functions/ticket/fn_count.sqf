/*
 * Name:	DOTT_ticket_fnc_count
 * Date:	3/3/2024
 * Version:	1.1
 * Author:	Dott [29th ID]
 *
 * Description:
 * Counts tickets and displays them discretly to each team and the admin. Does not use BIS_fnc_respawnTickets
 * remoteExec in onPlayerRespawn.sqf
 *
 * Parameter(s):
 * _playerSide (side): The side of the player which remoteExec'd the function
 *
 * Returns:
 * n/a
 *
 * Example (in onPlayerRespawn.sqf):
 * 
 *	private _playerSide = playerSide;
 *  [_playerSide] remoteExec ["DOTT_ticket_fnc_count", 2];
 *	
 * 
 */
 
params 
[
	["_playerSide",sideUnknown]
];

if (!isServer) exitWith {}; //server only

private _clientOwner = remoteExecutedOwner; //define client who remoteExec'd

//test each connected client for admin status
private _adminClient = 2; //default is server, to avoid sending hints to clients when no logged admin is present
{
	private _currentID = owner _x;
	private _adminStatus = admin _currentID;
	
	//if player is logged admin, define their clientOwnerID as admin and exit forEach loop
	if (_adminStatus isEqualTo 2) exitWith
	{
		_adminClient = _currentID;
	};
}
forEach allPlayers - entities "HeadlessClient_F"; //clients minus headless client

switch (_playerSide) do //select side
{
	case west: 
	{
		Private _ticketWEST = DOTT_ticketWEST;
		if (_ticketWEST isEqualTo 0) then //If tickets are 0, tell player
		{
			["<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>","PLAIN",0.8] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
		}
		else //otherwise subtract ticket
		{
			DOTT_ticketWEST = (_ticketWEST - 1); publicVariable "DOTT_ticketWEST";
			
			if (DOTT_ticketWEST isEqualTo 0) then //If player gets the last ticket, tell them, and hint team
			{
				"Your team is out of tickets!" remoteExec ["hint", _playerSide];
				"ADMIN: Blufor is out of tickets!" remoteExec ["hint", _adminClient]; //inform admin
				["<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>","PLAIN",0.8] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
				
			}
			else //If tickets remain, tell player they can spawn and hintSilent remaining tickets to team
			{
				format ["Your team has %1 tickets remaining!", DOTT_ticketWEST] remoteExec ["hintSilent", _playerSide];
				["<t color='#ffffff' size='2'>You may leave spawn!</t>","PLAIN",0.5] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
			};
		};
	};
	case east: 
	{	
		Private _ticketEAST = DOTT_ticketEAST;
		if (_ticketEAST isEqualTo 0) then
		{
			["<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>","PLAIN",0.8] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
		}
		else
		{
			DOTT_ticketEAST = (_ticketEAST - 1); publicVariable "DOTT_ticketEAST";
			
			if (DOTT_ticketEAST isEqualTo 0) then
			{
				"Your team is out of tickets!" remoteExec ["hint", _playerSide];
				"ADMIN: Opfor is out of tickets!" remoteExec ["hint", _adminClient];
				["<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>","PLAIN",0.8] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
			}
			else
			{
				format ["Your team has %1 tickets remaining!", DOTT_ticketEAST] remoteExec ["hintSilent", _playerSide];
				["<t color='#ffffff' size='2'>You may leave spawn!</t>","PLAIN",0.5] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
			};
		};		
	};
	case resistance: 
	{	
		Private _ticketGUER = DOTT_ticketGUER;
		if (_ticketGUER isEqualTo 0) then
		{
			["<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>","PLAIN",0.8] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
		}
		else
		{
			DOTT_ticketGUER = (_ticketGUER - 1); publicVariable "DOTT_ticketGUER";
			
			if (DOTT_ticketGUER isEqualTo 0) then
			{
				"Your team is out of tickets!" remoteExec ["hint", _playerSide];
				"ADMIN: Grnfor is out of tickets!" remoteExec ["hint", _adminClient];
				["<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>","PLAIN",0.8] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
			}
			else
			{
				format ["Your team has %1 tickets remaining!", DOTT_ticketGUER] remoteExec ["hintSilent", _playerSide];
				["<t color='#ffffff' size='2'>You may leave spawn!</t>","PLAIN",0.5] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
			};
		};
	};
	case civilian: {};
	default {};
};