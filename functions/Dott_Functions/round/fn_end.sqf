/*
 * Name:	fnc_end
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Transisitions to overtime if applicable, otherwise ends the round with notifications.
 *
 * Parameter(s): 
 * _force (boolean): Manual overriding of round end.
 *
 * Returns:
 * true
 *
 * Example:
 * [true] call DOTT_round_fnc_end;
 * 
 */


params[["_force", false, [false]]];
if (overtimeEnabled && !_force) then
{
	["<t color='#ffffff' size='3'><br/>%1 Minute OVERTIME</t>","PLAIN",0.5, true, overTimePeriod/60] remoteExec ["DOTT_fnc_displayMsg"];
	[overtimePeriod] call BIS_fnc_countdown;
	overtimeEnabled = false; //Prevents overtime from repeating forever
	publicVariable "overtimeEnabled";
	[] remoteExec ["DOTT_round_fnc_roundEvents"]; 	
} else
{
	["<t color='#ffffff' size='5'>GAME!</t>","PLAIN",0.4] remoteExec ["DOTT_fnc_displayMsg"];
	[-1] call BIS_fnc_countdown;
	overtimeEnabled = false; //in case manual end was called
	publicVariable "overtimeEnabled";
	if (_force) then { [{ terminate roundEventsScript }] remoteExec ["call"]; };
};

true


