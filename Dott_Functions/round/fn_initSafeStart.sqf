#include "defines.hpp"

/*
 * Name:	DOTT_round_fnc_initSafeStart
 * Date:	03/06/2026
 * Version: 1.3
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Launches safe start before round start. 
 * Launches round if all sides are still ready after the safe start time or if forced parameter is used.
 * Forced to be run on server.
 *
 * Parameter(s): 
 * _safeStartTime (Number) - optional time between all sides ready and automatic live call (default TN_safeStartTime)
 * _forced (Boolean) - whether to force safe start, and not end it if all teams are not ready (default false)
 * NOTE: Calling syntax should always include at least empty array.
 *
 * Returns:
 * true if safe started launched, false otherwise
 *
 * Example:
 * [] call DOTT_round_fnc_initSafeStart;
 * 
 */

if (!isServer) exitWith {_this remoteExec ["DOTT_round_fnc_initSafeStart", 2];}; //server should be in charge of this waitAndExecute

if !(isNil "DOTT_round_safeStartActive") exitWith { false };
if (call DOTT_round_fnc_isRoundActive) exitWith { false }; //don't start safe start if round already live


params [["_safeStartTime", TN_safeStartTime], ["_forced", false]];

DOTT_round_safeStartActive = true;
publicVariable "DOTT_round_safeStartActive";

private _msgText = format [
	"<t color='#ffffff' size='3'>Live in %1!</t>",
	[_safeStartTime] call DOTT_round_fnc_formatTime
];

if (_forced) then { _msgText = _msgText + "<br/>Teams can still ready up to end safe start early."; };

[
	_msgText,
	"PLAIN",
	0.5,
	false
] remoteExecCall ["DOTT_common_fnc_displayMsg"];

if (_forced) then { DOTT_round_ignoreReadiness = true; publicVariable "DOTT_round_ignoreReadiness"; };

["DOTT_round_safeStartBegin", []] call CBA_fnc_globalEvent;
[_safeStartTime] call BIS_fnc_countdown;
call DOTT_round_fnc_initSafeStartHelper;

true