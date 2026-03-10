/*
 * Function: DOTT_commands_fnc_addModule
 * Author:   Bae [29th ID]
 *
 * Description:
 *     Registers chat commands from a module into the global
 *     command system. Intended to be called by each module's
 *     commands.sqf during init. Must be called after the
 *     command system has initialized
 *     (pvpfw_chatIntercept_allCommands exists).
 *
 * Parameters:
 *     _commands - Array - Command definition pairs to append
 *         to pvpfw_chatIntercept_allCommands
 *     _helpInfo - Array - Help text pairs to append to
 *         pvpfw_chatIntercept_helpInfo
 *
 * Returns:
 *     Boolean - true if commands were added, false if the
 *         command system is not yet initialized
 *
 * Example:
 *     [
 *         [["mycommand", { systemChat "hello"; }]],
 *         [["mycommand", "Says hello"]]
 *     ] call DOTT_commands_fnc_addModule;
 */

if (isNil "pvpfw_chatIntercept_allCommands") exitWith
{
    false
};

params [
    ["_commands", [], [[]]],
    ["_helpInfo", [], [[]]]
];

pvpfw_chatIntercept_allCommands append _commands;
pvpfw_chatIntercept_helpInfo append _helpInfo;

true
