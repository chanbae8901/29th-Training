/*
 * Name:	DOTT_round_fnc_initSafeStartHelper
 * Date:	12/24/2025
 * Version: 1.1
 * Author:  Bae [29th ID] 
 *
 * Description:
 * Helper function for initSafeStart that calls itself every second until the end of safeStart or 
 * if not all teams are ready.
 *
 * Parameter(s): 
 * _countdown (Number): How many more times to call itself every second
 *
 * Returns:
 * true
 *
 * Example:
 * [10] call DOTT_round_fnc_initSafeStartHelper;
 * 
 */

private _allSidesReady = call DOTT_round_fnc_checkAllSidesReady;
if (isNil "DOTT_safeStartActive") exitWith { true };
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
	[{[_this select 0] call DOTT_round_fnc_initSafeStartHelper}, [], .2] call CBA_fnc_waitAndExecute;
} else 
{
	DOTT_safeStartActive = nil; publicVariable DOTT_safeStartActive;	
	[] call DOTT_round_fnc_start;
};
true