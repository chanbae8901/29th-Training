#include "..\..\data\defines.hpp"

/*
 * Function: DOTT_commands_fnc_init
 * Author:   Bae [29th ID]
 *
 * Description:
 *     Initializes the chat command system on the client.
 *     Compiles and executes each module's commands.sqf to
 *     populate the global command and help arrays, then
 *     converts them to HashMaps for O(1) lookups. Registers
 *     a HandleChatMessage event handler that intercepts
 *     messages beginning with the command marker ("!") and
 *     routes them to fn_execute. Should be initialized after
 *     the round system.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     call DOTT_commands_fnc_init;
 */

if (hasInterface) then
{
    pvpfw_chatIntercept_commandMarker = "!";

    // Load each module's commands.sqf if it exists.
    {
        private _commandsFile = format [
            "DOTT_Functions\%1\commands.sqf", _x
        ];
        if !(fileExists _commandsFile) then { continue };

        call compile preprocessFileLineNumbers _commandsFile;
    }
    forEach (DOTT_MODULES - ["commands"]);

    // Convert flat arrays to HashMaps for fast lookup.
    pvpfw_chatIntercept_allCommands =
        createHashMapFromArray pvpfw_chatIntercept_allCommands;
    pvpfw_chatIntercept_helpInfo =
        createHashMapFromArray pvpfw_chatIntercept_helpInfo;

    DOTT_commands_finishedInit = true;
    [
        "DOTT_commands_initCompleted", []
    ] call CBA_fnc_localEvent;

    // Intercept chat messages starting with the command
    // marker and route to fn_execute.
    addMissionEventHandler [
        "HandleChatMessage",
        {
            params [
                "_channel", "_owner", "_from", "_text",
                "_person", "_name", "_strID",
                "_forcedDisplay", "_isPlayerMessage",
                "_sentenceType", "_chatMessageType",
                "_params"
            ];

            private _chatArr = toArray _text;

            if (
                (_chatArr select 0) isEqualTo
                (
                    (toArray pvpfw_chatIntercept_commandMarker)
                    select 0
                )
            ) then
            {
                // Only the sender executes the command.
                if (_strID == getPlayerID player) then
                {
                    [_chatArr] call DOTT_commands_fnc_execute;
                };
                true
            }
            else
            {
                nil
            };
        }
    ];
};
