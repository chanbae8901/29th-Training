/*
 * Name:	DOTT_round_fnc_start
 * Date:	12/24/2025
 * Version: 1.1
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

private _msgText = format [
	"<t color='#ffffff' size='4'>LIVE LIVE LIVE</t><br/>%1 Time Limit",
	[_roundLength, true] call DOTT_round_fnc_formatTime
];

[
	_msgText,
	"PLAIN",
	0.5,
	false
] remoteExecCall ["DOTT_common_fnc_displayMsg"];

[{
	[{(call DOTT_round_fnc_getTime) <= 0}, { call DOTT_round_fnc_end }, []] call CBA_fnc_waitUntilAndExecute;
}] remoteExecCall ["call", 2];

bluReady = false;
opfReady = false;
grnReady = false; 
DOTT_safeStartActive = nil;
publicVariable "bluReady";
publicVariable "opfReady";	
publicVariable "grnReady";
publicVariable "DOTT_safeStartActive";

[] remoteExec ["DOTT_round_fnc_roundEvents"]; 

["DOTT_round_started", []] call CBA_fnc_globalEvent;

true