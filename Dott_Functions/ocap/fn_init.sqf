//NOTE: OCAP settings defined in cba_settings.sqf

if !(isServer) exitWith {};

if !(isClass (configFile >> "CfgPatches" >> "OCAP_recorder")) exitWith {};

DOTT_ocap_roundNum = 1;

// Round events for OCAP viewing
[
	"DOTT_round_safeStartBegin", 
	{
		["ocap_customEvent", ["generalEvent", "Safe start began!"]] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_safeStartAborted", 
	{
		["ocap_customEvent", ["generalEvent", "Safe start aborted!"]] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_started", 
	{
		["ocap_customEvent", ["generalEvent", format ["Round %1 started!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_ended", 
	{
		["ocap_customEvent", ["generalEvent", format ["Round %1 ended!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent;
		DOTT_ocap_roundNum = DOTT_ocap_roundNum + 1;
	}
] call CBA_fnc_addEventHandler;

if (OCAP_settings_autoStart) exitWith {}; //If server overrides mission settings

// Start/pause recording
[
	"DOTT_round_safeStartBegin", 
	{
		["ocap_record"] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_safeStartAborted", 
	{
		["ocap_pause"] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_started", 
	{
		if (OCAP_recorder_recording) exitWith {};
		["ocap_record"] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_ended", 
	{
		["ocap_pause"] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;