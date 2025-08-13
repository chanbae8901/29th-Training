params["_force", false, [false]];
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
};

true


