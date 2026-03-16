/*
 * Name:	TN_commands_fnc_addModule
 * Date:	12/30/2025
 * Version: 1.0
 * Author:   Bae [29th ID]
 *
 * Description:
 * Adds chat commands to the chat command system. Meant for modules to call on init.
 *
 * Parameter(s): 
 * _commands - Array of command definitions to add (see commands.sqf for format)
 * _helpInfo - Array of help info definitions to add (see commands.sqf for format)
 *
 * Returns:
 * true if commands added, false otherwise
 *
 * Example:
 * call TN_commands_fnc_init;
 * 
 */

if (isNil "TN_commands_allCommands") exitWith { false };

params [["_commands", [], [[]]], ["_helpInfo", [], [[]]]];

TN_commands_allCommands append _commands;
TN_commands_helpInfo append _helpInfo;

true
