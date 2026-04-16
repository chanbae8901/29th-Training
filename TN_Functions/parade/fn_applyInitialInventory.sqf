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
 * call TN_parade_fnc_applyInitialInventory;
 */

if (!hasInterface) exitWith {};

private _side = side (group player);

switch (_side) do {
    case WEST: {
        call FUNC(load);
        call EFUNC(radio,add);
        [player, [missionNamespace, "Parade"]] call BIS_fnc_saveInventory;
        [player, ["missionNamespace:Parade"]] call BIS_fnc_setRespawnInventory;
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

nil
