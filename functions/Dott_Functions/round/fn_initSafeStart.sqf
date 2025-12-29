/*
 * Name:	DOTT_round_fnc_initSafeStart
 * Date:	12/24/2025
 * Version: 1.1
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Launches safe start before round start. Launches round if all sides are still ready after the safe start time.
 * Forced to be run on server.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_round_fnc_initSafeStart;
 * 
 */

if (!isServer) exitWith {remoteExec ["DOTT_round_fnc_initSafeStart", 2];}; //server should be in charge of this waitAndExecute

private _safeStartTime = TN_safeStartTime; // time between all sides ready and automatic live call (default 10)

private _msgText = format [
	"<t color='#ffffff' size='3'>Live in %1!</t>",
	[_safeStartTime] call DOTT_round_fnc_formatTime
];

[
	_msgText,
	"PLAIN",
	0.5,
	false
] remoteExecCall ["DOTT_common_fnc_displayMsg"];

DOTT_safeStartActive = true;
publicVariable "DOTT_safeStartActive";
["DOTT_round_safeStartBegin", []] call CBA_fnc_globalEvent;
[_safeStartTime] call BIS_fnc_countdown;
call DOTT_round_fnc_initSafeStartHelper;

true