#include "..\..\data\defines.hpp"
/*
 * Name:	DOTT_commands_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes chat command system. Client side only.
 * Should be initialized after round system.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_commands_fnc_init;
 * 
 */

if (hasInterface) then {
	pvpfw_chatIntercept_commandMarker = "!"; //Character at the front of the chat input to intercept it

	{
		private _commandsFile = format ["DOTT_Functions\%1\commands.sqf", _x];
		if !(fileExists _commandsFile) then { continue };

		call compile preprocessFileLineNumbers _commandsFile;
	}
	forEach (DOTT_MODULES - ["commands"]);

	pvpfw_chatIntercept_allCommands = createHashMapFromArray pvpfw_chatIntercept_allCommands;
	pvpfw_chatIntercept_helpInfo = createHashMapFromArray pvpfw_chatIntercept_helpInfo;
	DOTT_commands_finishedInit = true;
	["DOTT_commands_initCompleted", []] call CBA_fnc_localEvent;

	addMissionEventHandler ["HandleChatMessage", 
		{
			params ["_channel", "_owner", "_from", "_text", "_person", "_name", "_strID", "_forcedDisplay", "_isPlayerMessage", "_sentenceType", "_chatMessageType", "_params"];
			_chatArr = toArray _text;
			if ((_chatArr select 0) isEqualTo ((toArray pvpfw_chatIntercept_commandMarker) select 0)) then 
			{
				if (_strID == getPlayerID player) then { [_chatArr] call DOTT_commands_fnc_execute }; //only execute for the player who sent the message
				true; //blocks message from showing up in chat
			} else
			{
				nil; //don't do anything to message if it's not a command
			};
		}
	];
};