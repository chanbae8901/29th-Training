/*
 * Name:	fnc_start
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Starts the round with a specified timer length.
 *
 * Parameter(s): 
 * _roundLength (Number) - value to start round timer in seconds
 *
 * Returns:
 * false if round is already active, true otherwise
 *
 * Example:
 * [500] call DOTT_round_fnc_setTimer;
 * 
 */


//return false if round already active, otherwise return true
params[["_roundLength", timerLength, [0]]]; // Length of the round in seconds
if (call DOTT_round_fnc_isRoundActive) exitWith {false};

[_roundLength] call BIS_fnc_countdown;
["<t color='#ffffff' size='4'>LIVE LIVE LIVE</t><br/>%1 Minute Time Limit","PLAIN",0.5, true, _roundLength/60] remoteExecCall ["DOTT_fnc_displayMsg"];

[{
	[{(call DOTT_round_fnc_getTime) <= 0}, { call DOTT_round_fnc_end }, []] call CBA_fnc_waitUntilAndExecute;
}] remoteExecCall ["call", 2];

bluReady = false;
opfReady = false;
grnReady = false; 
publicVariable "bluReady";
publicVariable "opfReady";	
publicVariable "grnReady";

[] remoteExec ["DOTT_round_fnc_roundEvents"]; 

["DOTT_round_started", []] call CBA_fnc_globalEvent;

true