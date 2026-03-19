/*
 * Author: Bae [29th ID]
 * Adds chat commands to the chat command system. Meant for modules to call on init.
 *
 * Arguments:
 * 0: Command definitions to add (see commands.sqf for format) <ARRAY>
 * 1: Help info definitions to add (see commands.sqf for format) <ARRAY>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_commands_fnc_init;
 */

if (isNil "TN_commands_allCommands") exitWith { false };

params [["_commands", [], [[]]], ["_helpInfo", [], [[]]]];

TN_commands_allCommands append _commands;
TN_commands_helpInfo append _helpInfo;

nil
