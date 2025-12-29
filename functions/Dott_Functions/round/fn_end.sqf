/*
 * Name:	DOTT_round_fnc_end
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
	["<t color='#ffffff' size='3'><br/>%1 Minute OVERTIME</t>","PLAIN",0.5, true, overTimePeriod/60] remoteExecCall ["DOTT_common_fnc_displayMsg"];
	[overtimePeriod] call BIS_fnc_countdown;
	overtimeEnabled = false; //Prevents overtime from repeating forever
	publicVariable "overtimeEnabled";
	DOTT_round_timeAdded = true;
	publicVariable "DOTT_round_timeAdded";
	[{(call DOTT_round_fnc_getTime) <= 0}, { call DOTT_round_fnc_end }, []] call CBA_fnc_waitUntilAndExecute;
} else
{	
	//let waituntilandexecute in fn_start call end
	if (call DOTT_round_fnc_isRoundActive) exitWith 
	{		
		overtimeEnabled = false; //in case manual end was called
		publicVariable "overtimeEnabled";		
		[-1] call BIS_fnc_countdown; 
		true
	};
	

	if (_force) exitWith {true}; //implies called when round not running

	//let round naturally end on non-forced case
	["<t color='#ffffff' size='5'>GAME!</t>","PLAIN",0.4] remoteExecCall ["DOTT_common_fnc_displayMsg"];
	[-1] call BIS_fnc_countdown;
	["DOTT_round_ended",[]] call CBA_fnc_globalEvent;		
};

true


