/*
 * File: Dott_Functions/base/commands.sqf
 * Author: Hill [29th ID]
 *
 * Description:
 *     Registers base-module chat commands with the command
 *     system. Currently adds the "cleanup" command which
 *     triggers the garbage can cleaner function.
 *
 * Parameters:
 *     None (called via compile preprocessFileLineNumbers)
 *
 * Returns:
 *     Nothing
 */

[
    [
        [
            "cleanup",
            {
                call DOTT_base_fnc_cleaner;
                systemChat "Cleaning up!";
            }
        ]
    ],
    [
        ["cleanup", "Cleans up bodies (trash can function)"]
    ]
] call DOTT_commands_fnc_addModule;
