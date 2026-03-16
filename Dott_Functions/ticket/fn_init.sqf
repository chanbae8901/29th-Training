/**
 * Function: TN_ticket_fnc_init
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Initializes ticket system.
 *   NOTE: Unsure if finished.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   Nothing
 *
 * Example:
 *   call TN_ticket_fnc_init;
 */

// Ensure JIP client is aware of the status of the ticket system.
if (isNil "TN_ticketEnabled") then
{
    TN_ticketEnabled = false;
};
if (isNil "TN_ticketWEST") then
{
    TN_ticketWEST = 0;
};
if (isNil "TN_ticketEAST") then
{
    TN_ticketEAST = 0;
};
if (isNil "TN_ticketGUER") then
{
    TN_ticketGUER = 0;
};

if (hasInterface) then
{
    [
        "TN_ticket_respawnCount",
        "Respawn",
        {
            if (TN_ticketEnabled) then
            {
                private _playerSide = playerSide;
                [_playerSide] remoteExecCall ["TN_ticket_fnc_count", 2];
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;
};
