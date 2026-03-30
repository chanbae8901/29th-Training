#include "script_component.hpp"
/*
 * Author: Hill [29th ID]
 * Ensures joining player has correct loadout on joining the
 * server, using custom parade if available on BLUFOR.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_parade_fnc_handleInitialInventory;
 */

if (!hasInterface) exitWith {};

private _fn_loadParade = {
    private _side = side (group player);

    switch (_side) do {
        case WEST: {
            call FUNC(load);
        };
        case EAST: {
            [player, missionConfigFile >> "CfgRespawnInventory" >> "29TH_PARADE_EAST"]
                call BIS_fnc_loadInventory;
        };
        case INDEPENDENT: {
            [player, missionConfigFile >> "CfgRespawnInventory" >> "29TH_PARADE_INDEPENDENT"]
                call BIS_fnc_loadInventory;
        };
        default {};
    };
};

[QEGVAR(common,preloadFinished), _fn_loadParade] call CBA_fnc_addEventHandler;

nil
