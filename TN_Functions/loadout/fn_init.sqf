#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes the loadout module on clients. Registers arsenal
 * close handlers for both BI and ACE arsenals, and sets up
 * insignia reapplication on respawn.
 * Should be initialized after the radio module.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_loadout_fnc_init;
 */

/*
 * Editor-placed objects referenced in this module:
 *     base_res_blu
 *     base_res_red
 *     base_res_grn
 *     base_action_arsenal_blu
 *     base_action_arsenal_red
 *     base_action_arsenal_grn
 */

if (hasInterface) then {
    [
        missionNamespace,
        "arsenalClosed", {
            // Don't do if Zeus Open (ZEN Loadout Editing).
            if !(isNull (findDisplay 312)) exitWith {};
            call FUNC(onArsenalClosed);
        }
    ] call BIS_fnc_addScriptedEventHandler;

    if (isClass (configFile >> "CfgPatches" >> "ace_main"))
        then {
        [
            "ace_arsenal_displayClosed", {
                // Don't do if Zeus Open (ZEN Loadout Editing).
                if !(isNull (findDisplay 312)) exitWith {};
                call FUNC(onArsenalClosed);
            }
        ] call CBA_fnc_addEventHandler;
    };
};

nil
