if (hasInterface) then
{
	call DOTT_training_fnc_initBaseObjects;

	//Init chat command system
	[] execVM "module_chatIntercept\init.sqf";

	[] spawn DOTT_training_fnc_initDefaultLoadouts;
};

if (isServer) then
{
	INDEPENDENT setFriend [WEST, 0];

	//set-up default date and weather
	private _forcedDate     = [2018, 3, 30, 12, 0]; 
	private _forcedOvercast = 0.1;
	private _forcedFog      = [0.1, 0.01, 0];
	[_forcedDate, _forcedOvercast, _forcedFog] call DOTT_training_fnc_initDateAndWeather;

	call DOTT_settings_fnc_initServer;
};

//We want event variation to only have CBA as a mod requirement so below are training only

//heavily ACE Medical integrated + meaningless since mission ends automatically as well
if (("enableRoundEventLog" call BIS_fnc_getParamValue) == 1) then {call DOTT_tracker_fnc_init};

//29th Mod Required
call DOTT_parade_fnc_init; 