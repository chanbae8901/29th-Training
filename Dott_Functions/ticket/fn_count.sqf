/**
 * Function: DOTT_ticket_fnc_count
 * Author:   Dott [29th ID]
 *
 * Description:
 *   Counts tickets and displays them discretly to each team and
 *   the admin. Does not use BIS_fnc_respawnTickets. Called via
 *   remoteExec from the client respawn event handler.
 *
 * Parameters:
 *   _playerSide (Side) - The side of the player who respawned
 *
 * Returns:
 *   Nothing
 *
 * Example:
 *   private _playerSide = playerSide;
 *   [_playerSide] remoteExec ["DOTT_ticket_fnc_count", 2];
 */

params
[
    ["_playerSide", sideUnknown]
];

if (!isServer) exitWith {};

private _clientOwner = remoteExecutedOwner;

// Test each connected client for admin status.
// Default is server, to avoid sending hints to clients when no
// logged admin is present.
private _adminClient = 2;
{
    private _currentID = owner _x;
    private _adminStatus = admin _currentID;

    // If player is logged admin, define their clientOwnerID
    // as admin and exit forEach loop.
    if (_adminStatus isEqualTo 2) exitWith
    {
        _adminClient = _currentID;
    };
} forEach (allPlayers - entities "HeadlessClient_F");

switch (_playerSide) do
{
    case west:
    {
        private _ticketWEST = DOTT_ticketWEST;
        // If tickets are 0, tell player.
        if (_ticketWEST isEqualTo 0) then
        {
            [
                "<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>",
                "PLAIN",
                0.8
            ] remoteExec [
                "DOTT_common_fnc_displayMsg",
                _clientOwner
            ];
        }
        else
        {
            DOTT_ticketWEST = (_ticketWEST - 1);
            publicVariable "DOTT_ticketWEST";

            // If player gets the last ticket, tell them,
            // and hint team.
            if (DOTT_ticketWEST isEqualTo 0) then
            {
                "Your team is out of tickets!"
                    remoteExec ["hint", _playerSide];
                "ADMIN: Blufor is out of tickets!"
                    remoteExec ["hint", _adminClient];
                [
                    "<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>",
                    "PLAIN",
                    0.8
                ] remoteExec [
                    "DOTT_common_fnc_displayMsg",
                    _clientOwner
                ];
            }
            else
            {
                // If tickets remain, tell player they can spawn
                // and hintSilent remaining tickets to team.
                format [
                    "Your team has %1 tickets remaining!",
                    DOTT_ticketWEST
                ] remoteExec [
                    "hintSilent", _playerSide
                ];
                [
                    "<t color='#ffffff' size='2'>You may leave spawn!</t>",
                    "PLAIN",
                    0.5
                ] remoteExec [
                    "DOTT_common_fnc_displayMsg",
                    _clientOwner
                ];
            };
        };
    };
    case east:
    {
        private _ticketEAST = DOTT_ticketEAST;
        if (_ticketEAST isEqualTo 0) then
        {
            [
                "<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>",
                "PLAIN",
                0.8
            ] remoteExec [
                "DOTT_common_fnc_displayMsg",
                _clientOwner
            ];
        }
        else
        {
            DOTT_ticketEAST = (_ticketEAST - 1);
            publicVariable "DOTT_ticketEAST";

            if (DOTT_ticketEAST isEqualTo 0) then
            {
                "Your team is out of tickets!"
                    remoteExec ["hint", _playerSide];
                "ADMIN: Opfor is out of tickets!"
                    remoteExec ["hint", _adminClient];
                [
                    "<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>",
                    "PLAIN",
                    0.8
                ] remoteExec [
                    "DOTT_common_fnc_displayMsg",
                    _clientOwner
                ];
            }
            else
            {
                format [
                    "Your team has %1 tickets remaining!",
                    DOTT_ticketEAST
                ] remoteExec [
                    "hintSilent", _playerSide
                ];
                [
                    "<t color='#ffffff' size='2'>You may leave spawn!</t>",
                    "PLAIN",
                    0.5
                ] remoteExec [
                    "DOTT_common_fnc_displayMsg",
                    _clientOwner
                ];
            };
        };
    };
    case resistance:
    {
        private _ticketGUER = DOTT_ticketGUER;
        if (_ticketGUER isEqualTo 0) then
        {
            [
                "<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>",
                "PLAIN",
                0.8
            ] remoteExec [
                "DOTT_common_fnc_displayMsg",
                _clientOwner
            ];
        }
        else
        {
            DOTT_ticketGUER = (_ticketGUER - 1);
            publicVariable "DOTT_ticketGUER";

            if (DOTT_ticketGUER isEqualTo 0) then
            {
                "Your team is out of tickets!"
                    remoteExec ["hint", _playerSide];
                "ADMIN: Grnfor is out of tickets!"
                    remoteExec ["hint", _adminClient];
                [
                    "<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>",
                    "PLAIN",
                    0.8
                ] remoteExec [
                    "DOTT_common_fnc_displayMsg",
                    _clientOwner
                ];
            }
            else
            {
                format [
                    "Your team has %1 tickets remaining!",
                    DOTT_ticketGUER
                ] remoteExec [
                    "hintSilent", _playerSide
                ];
                [
                    "<t color='#ffffff' size='2'>You may leave spawn!</t>",
                    "PLAIN",
                    0.5
                ] remoteExec [
                    "DOTT_common_fnc_displayMsg",
                    _clientOwner
                ];
            };
        };
    };
    case civilian: {};
    default {};
};
