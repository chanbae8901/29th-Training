/*
 * Name:	fnc_initSafeStart
 * Date:	8/14/2025
 * Version: 1.0
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

private _safeStartTime = 10; // time between all sides ready and automatic live call (default 10)

["<t color='#ffffff' size='3'>Live in %1 Seconds!</t>", "PLAIN", 0.5, true, _safeStartTime] remoteExecCall ["DOTT_fnc_displayMsg"];

[_safeStartTime] call DOTT_round_fnc_initSafeStartHelper;

true