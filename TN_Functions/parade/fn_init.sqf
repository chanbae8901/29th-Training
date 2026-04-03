#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes the parade loadout module. Applies the correct
 * parade uniform on first spawn (including JIP), and registers
 * server-side respawn inventories for each side.
 * No-ops if 29th ID Uniforms addon is not loaded.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_parade_fnc_init;
 */

if (!isClass (configFile >> "CfgPatches" >> "29thID_Uniforms"))
    exitWith {};

if (hasInterface) then {
    // Wait for default parade loadout, then apply initial
    // parade inventory.
    [
        { primaryWeapon player isEqualTo "rhs_weap_m1garand_sa43" },
        FUNC(handleInitialInventory)
    ] call CBA_fnc_waitUntilAndExecute;

    [QEGVAR(loadout,afterArsenalClosed), {
        player call FUNC(setInsignia);
    }] call CBA_fnc_addEventHandler;

    [QEGVAR(loadout,afterSetLoadout),
        FUNC(setInsignia)
    ] call CBA_fnc_addEventHandler;

    [
        QGVAR(setInsigniaRespawn),
        "Respawn",
        FUNC(setInsignia)
    ] call CBA_fnc_addBISPlayerEventHandler;
};

if (isServer) then {
    // Register parade respawn inventories for each faction.
    [WEST, "29TH_PARADE_WEST"] call BIS_fnc_addRespawnInventory;
    [EAST, "29TH_PARADE_EAST"] call BIS_fnc_addRespawnInventory;
    [INDEPENDENT, "29TH_PARADE_INDEPENDENT"] call BIS_fnc_addRespawnInventory;
};

nil
