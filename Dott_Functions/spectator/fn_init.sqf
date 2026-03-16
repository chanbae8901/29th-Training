/**
 * Function: TN_spectator_fnc_init
 * Author:   Bae [29th ID]
 *
 * Initializes the spectator module on clients.
 * Registers a respawn event handler that automatically places
 * the player into spectator mode when TN_autoSpectate is enabled.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     call TN_spectator_fnc_init;
 */

if (!hasInterface) exitWith {};

// --- Auto-spectate on respawn ---
["TN_spectator_autoSpectate", "Respawn",
{
    params ["_newUnit", "_oldUnit"];

    if (!isNull _oldUnit) then
    {
        if (TN_autoSpectate) then
        {
            systemChat "AutoSpectate is ON.";
            [_newUnit] spawn TN_spectator_fnc_enter;
        };
    };
}] call CBA_fnc_addBISPlayerEventHandler;
