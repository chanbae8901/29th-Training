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
if (isNil "TN_ticket_enabled") then
{
    TN_ticket_enabled = false;
};
if (isNil "TN_ticket_WEST") then
{
    TN_ticket_WEST = 0;
};
if (isNil "TN_ticket_EAST") then
{
    TN_ticket_EAST = 0;
};
if (isNil "TN_ticket_GUER") then
{
    TN_ticket_GUER = 0;
};

if (hasInterface) then
{
    [
        "TN_ticket_respawnCount",
        "Respawn",
        {
            if (TN_ticket_enabled) then
            {
                private _playerSide = playerSide;
                [_playerSide] remoteExecCall ["TN_ticket_fnc_count", 2];
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;
};
