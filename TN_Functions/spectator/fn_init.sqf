#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes the spectator module on clients.
 * Registers a respawn event handler that automatically places
 * the player into spectator mode when TN_autoSpectate is enabled.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_spectator_fnc_init
 */

if (!hasInterface) exitWith {};

// --- Auto-spectate on respawn ---
[QGVAR(autoSpectate), "Respawn", {
    params ["_newUnit", "_oldUnit"];

    if (!isNull _oldUnit) then {
        if (GVARMAIN(autoSpectate)) then {
            systemChat "AutoSpectate is ON.";
            [_newUnit] call FUNC(enter);
        };
    };
}] call CBA_fnc_addBISPlayerEventHandler;

nil
