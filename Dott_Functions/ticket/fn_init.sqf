/**
 * Function: DOTT_ticket_fnc_init
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Initalizes ticket system.
 *   NOTE: Unsure if finished.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   Nothing
 *
 * Example:
 *   call DOTT_ticket_fnc_init;
 */

// Ensure JIP client is aware of the status of the ticket system.
if (isNil "DOTT_ticketEnabled") then
{
    DOTT_ticketEnabled = false;
};
if (isNil "DOTT_ticketWEST") then
{
    DOTT_ticketWEST = 0;
};
if (isNil "DOTT_ticketEAST") then
{
    DOTT_ticketEAST = 0;
};
if (isNil "DOTT_ticketGUER") then
{
    DOTT_ticketGUER = 0;
};

if (hasInterface) then
{
    [
        "DOTT_ticket_respawnCount",
        "Respawn",
        {
            if (DOTT_ticketEnabled) then
            {
                private _playerSide = playerSide;
                [_playerSide] remoteExec [
                    "DOTT_ticket_fnc_count", 2
                ];
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;
};
