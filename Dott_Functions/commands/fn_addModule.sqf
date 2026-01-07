/*
 * Name:	DOTT_commands_fnc_addModule
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Adds chat commands to the chat command system. Meant for modules to call on init.
 *
 * Parameter(s): 
 * _commands - Array of command definitions to add (see commands.sqf for format)
 * _helpInfo - Array of help info definitions to add (see commands.sqf for format)
 * _noLog - Array of command names that should not be logged when used
 * _restricted - Array of command names that should be restricted to outside rounds
 * _admin - Array of command names that should be restricted to admins only
 *
 * Returns:
 * true if commands added, false otherwise
 *
 * Example:
 * call DOTT_commands_fnc_init;
 * 
 */

if (isNil "pvpfw_chatIntercept_allCommands") exitWith { false };

params [["_commands", [], [[]]], ["_helpInfo", [], [[]]]];

pvpfw_chatIntercept_allCommands append _commands;
pvpfw_chatIntercept_helpInfo append _helpInfo;

true

