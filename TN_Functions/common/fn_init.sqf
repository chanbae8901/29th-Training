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
};

if (hasInterface) then {
    //No point of having this on server since it can't JIP
    call FUNC(initPreloadFinished);
};

nil
