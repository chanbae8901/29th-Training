/*
 * Name:	DOTT_round_fnc_initSafeStartHelper
 * Date:	01/11/2026
 * Version: 1.2
 * Author:  Bae [29th ID] 
 *
 * Description:
 * Helper function for initSafeStart that calls itself every second until the end of safeStart or 
 * if not all teams are ready.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_round_fnc_initSafeStartHelper;
 * 
 */

if (isNil "DOTT_safeStartActive") exitWith { true };

private _allSidesReady = call DOTT_round_fnc_checkAllSidesReady;
if (!_allSidesReady) exitWith 
{
	// Display aborted message if someone unready mid-countdown			
	["<t color='#ffffff' size='4'>Timer Aborted!</t>","PLAIN",0.5] remoteExec ["DOTT_common_fnc_displayMsg"];
	DOTT_safeStartActive = nil; publicVariable DOTT_safeStartActive;
	[-1] call BIS_fnc_countdown;
	["DOTT_round_safeStartAborted", []] call CBA_fnc_globalEvent;
	true
};
if (([0] call BIS_fnc_countdown) > 0) then
{
	[{call DOTT_round_fnc_initSafeStartHelper}, [], .2] call CBA_fnc_waitAndExecute;
} else 
{
	DOTT_safeStartActive = nil; publicVariable DOTT_safeStartActive;
	[] call DOTT_round_fnc_start;
};
true