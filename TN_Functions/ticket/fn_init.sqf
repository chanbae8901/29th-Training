#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes ticket system.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_ticket_fnc_init;
 */

if (isServer) then {
    GVAR(enabled) = false;
    GVAR(counts) = [0, 0, 0];
    GVAR(startingCounts) = [0, 0, 0];

    [
        QEGVAR(round,started),
        {
            if (!GVAR(enabled)) exitWith {};
            GVAR(counts) = +GVAR(startingCounts);
            publicVariable QGVAR(counts);
        }
    ] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [
        QGVAR(respawnCount),
        "Respawn", {
            if (GVAR(enabled) && ROUND_LIVE) then {
                private _playerSide = playerSide;
                [_playerSide] remoteExecCall [QFUNC(count), 2];
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;

    [
        QEGVAR(round,started),
        {
            if !(IS_ADMIN) exitWith {};
            systemChat format [
                "Current Tickets: Blu: %1, Opf: %2, Grn: %3",
                GVAR(startingCounts) select 1,
                GVAR(startingCounts) select 0,
                GVAR(startingCounts) select 2
            ];
        }
    ] call CBA_fnc_addEventHandler;
};

nil
