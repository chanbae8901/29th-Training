#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes shared common utilities.
 * Registers centralized mission event handlers that fire
 * CBA events for consumer modules.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_common_fnc_init;
 */

GVAR(strToSideMap) = createHashMapFromArray [
    ["blufor",  west],
    ["opfor",   east],
    ["grnfor",  resistance]
];

GVAR(sideToStrMap) = createHashMap;
GVAR(sideToStrMap) set [west,       "BLUFOR"];
GVAR(sideToStrMap) set [east,       "OPFOR"];
GVAR(sideToStrMap) set [resistance, "GRNFOR"];

if (isServer) then {
    call FUNC(initAdminStateChanged);

    GVAR(adminClient) = 2;

    // Catch any admin already logged in before this runs.
    {
        if (admin (owner _x) isEqualTo 2) exitWith {
            GVAR(adminClient) = owner _x;
            publicVariable QGVAR(adminClient);
        };
    } forEach (allPlayers - entities "HeadlessClient_F");

    [
        QGVAR(adminStateChanged), {
            params ["_unit", "_loggedIn"];
            if (isNull _unit) exitWith {};
            GVAR(adminClient) = [2, owner _unit] select _loggedIn;
            publicVariable QGVAR(adminClient);
        }
    ] call CBA_fnc_addEventHandler;    
};

if (hasInterface) then {
    //No point of having this on server since it can't JIP
    call FUNC(initPreloadFinished);
};

nil
