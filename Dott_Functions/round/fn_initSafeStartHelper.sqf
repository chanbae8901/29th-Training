#include "defines.hpp"

/*
 * Name:	DOTT_round_fnc_initSafeStartHelper
 * Date:	03/06/2026
 * Version: 1.3
 * Author:  Bae [29th ID] 
 *
 * Description:
 * Helper function for initSafeStart that calls itself every second until the end of safeStart or 
 * if not all teams are ready and forced safe start is not on.
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

if (isNil "DOTT_round_safeStartActive") exitWith { true };

private _allSidesReady = call DOTT_round_fnc_checkAllSidesReady;
if !(_allSidesReady || DOTT_round_ignoreReadiness) exitWith 
{
	// Display aborted message if someone unready mid-countdown			
	["<t color='#ffffff' size='4'>Timer Aborted!</t>","PLAIN",0.5] remoteExec ["DOTT_common_fnc_displayMsg"];
	RESET_SAFESTART_VARS;
	[-1] call BIS_fnc_countdown;
	["DOTT_round_safeStartAborted", []] call CBA_fnc_globalEvent;
	true
};
if (([0] call BIS_fnc_countdown) > 0) then
{
	[{call DOTT_round_fnc_initSafeStartHelper}, [], .2] call CBA_fnc_waitAndExecute;
} else 
{
	RESET_SAFESTART_VARS;
	[] call DOTT_round_fnc_start;
};
true