/*
 * Name:	fnc_initSafeStartHelper
 * Date:	8/15/2025
 * Version: 1.0
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

params["_countdown"];
private _allSidesReady = call DOTT_round_fnc_checkAllSidesReady;
if (!_allSidesReady) exitWith 
{
	// Display aborted message if someone unready mid-countdown			
	["<t color='#ffffff' size='4'>Timer Aborted!</t>","PLAIN",0.5] remoteExec ["DOTT_fnc_displayMsg"];
};
if (_countdown > 0)	then
{
	[{[_this select 0] call DOTT_round_fnc_initSafeStartHelper}, [_countdown - 1], 1] call CBA_fnc_waitAndExecute;
} else 
{
	[] call DOTT_round_fnc_start;
};
true