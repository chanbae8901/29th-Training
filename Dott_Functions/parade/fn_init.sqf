/**
 * Function: DOTT_parade_fnc_init
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Initializes the parade loadout module. Applies the correct
 *   parade uniform on first spawn (including JIP), and registers
 *   server-side respawn inventories for each side.
 *   No-ops if 29th ID Uniforms addon is not loaded.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   Nothing
 */

if (!isClass (configFile >> "CfgPatches" >> "29thID_Uniforms"))
    exitWith {};

if (hasInterface) then
{
    // Wait for player object, then apply initial parade loadout
    // in unscheduled scope via isNil trick.
    [] spawn
    {
        waitUntil { !isNull player };
        isNil { call DOTT_parade_fnc_handleInitialInventory };
    };
};

if (isServer) then
{
    // Register parade respawn inventories for each faction.
    [WEST, "29TH_PARADE_WEST"]
        call BIS_fnc_addRespawnInventory;
    [EAST, "29TH_PARADE_EAST"]
        call BIS_fnc_addRespawnInventory;
    [INDEPENDENT, "29TH_PARADE_INDEPENDENT"]
        call BIS_fnc_addRespawnInventory;
};
