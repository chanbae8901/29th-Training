//return false if round already active, otherwise return true
params[["_roundLength", timerLength, [0]]]; // Length of the round in seconds
if (call DOTT_round_fnc_isRoundActive) exitWith {false};

[_roundLength] call BIS_fnc_countdown;
["<t color='#ffffff' size='4'>LIVE LIVE LIVE</t><br/>%1 Minute Time Limit","PLAIN",0.5, true, _roundLength/60] remoteExec ["DOTT_fnc_displayMsg"];

bluReady = false;
opfReady = false;
grnReady = false; 
publicVariable "bluReady";
publicVariable "opfReady";	
publicVariable "grnReady";

[] remoteExec ["DOTT_round_fnc_roundEvents"]; 

true