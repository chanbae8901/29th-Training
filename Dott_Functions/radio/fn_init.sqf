/**
 * Function: DOTT_radio_fnc_init
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Initializes the radio module. Registers arsenal-close handlers
 *   to auto-add radios, a death handler to strip radios, a
 *   disconnect handler for the same, and sets up TFAR settings
 *   persistence. No-ops if TFAR Beta is not loaded.
 *   Should be initialized before loadout.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   Nothing
 */

if !(isClass (configFile >> "CfgPatches" >> "tfar_core")) exitWith {};

if (hasInterface) then
{
    // Re-add side-correct radio after closing vanilla arsenal.
    [
        missionNamespace,
        "arsenalClosed",
        {
            // Skip if Zeus is open (ZEN loadout editing).
            if !(isNull (findDisplay 312)) exitWith {};
            call DOTT_radio_fnc_add;
        }
    ] call BIS_fnc_addScriptedEventHandler;

    // Re-add side-correct radio after closing ACE arsenal.
    if (isClass (configFile >> "CfgPatches" >> "ace_main")) then
    {
        [
            "ace_arsenal_displayClosed",
            {
                // Skip if Zeus is open (ZEN loadout editing).
                if !(isNull (findDisplay 312)) exitWith {};
                call DOTT_radio_fnc_add;
            }
        ] call CBA_fnc_addEventHandler;
    };

    // Strip radios on death when the setting is enabled.
    [
        "DOTT_radio_removeOnDeath",
        "Killed",
        {
            if (TN_removeRadiosOnDeath) then
            {
                (_this select 0) call DOTT_radio_fnc_remove;
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;

    // Persist TFAR radio settings across respawn / loadout swap.
    call DOTT_radio_fnc_initTransferSettings;
};

if (isServer) then
{
    // Strip radios from disconnecting players' bodies.
    addMissionEventHandler [
        "HandleDisconnect",
        {
            params ["_unit"];

            if (isNull _unit) exitWith {};

            if (TN_removeRadiosOnDeath) then
            {
                _unit call DOTT_radio_fnc_remove;
            };
        }
    ];
};
