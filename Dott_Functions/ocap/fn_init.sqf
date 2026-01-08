/*
 * Name:	DOTT_ocap_fnc_init
 * Date:	01/05/2026
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initializes OCAP event handlers that work with the round system.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_ocap_fnc_init;
 * 
 */

//NOTE: OCAP settings defined in cba_settings.sqf

if !(isServer) exitWith {};

if !(isClass (configFile >> "CfgPatches" >> "OCAP_recorder")) exitWith {};

DOTT_ocap_roundNum = 1;


//Order matters, event won't register if recording is not currently happening
//However, dont start/pause recordings if autoStart is forced by server config

//SafeStart Start
if !(OCAP_settings_autoStart) then 
{ 
	[
		"DOTT_round_safeStartBegin", 
		{
			["ocap_record"] call CBA_fnc_serverEvent;
		}
	] call CBA_fnc_addEventHandler;
};

[
	"DOTT_round_safeStartBegin", 
	{
		["ocap_customEvent", ["generalEvent", "Safe start began!"]] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

//Safe Start Aborted
[
	"DOTT_round_safeStartAborted", 
	{
		["ocap_customEvent", ["generalEvent", "Safe start aborted!"]] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

if !(OCAP_settings_autoStart) then 
{
	[
		"DOTT_round_safeStartAborted", 
		{
			["ocap_pause"] call CBA_fnc_serverEvent;
		}
	] call CBA_fnc_addEventHandler;
};

//Round Start
if !(OCAP_settings_autoStart) then 
{
	[
		"DOTT_round_started", 
		{
			if (OCAP_recorder_recording) exitWith {};
			["ocap_record"] call CBA_fnc_serverEvent;
		}
	] call CBA_fnc_addEventHandler;
};

[
	"DOTT_round_started", 
	{
		["ocap_customEvent", ["generalEvent", format ["Round %1 started!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

//Round End
[
	"DOTT_round_ended", 
	{
		["ocap_customEvent", ["generalEvent", format ["Round %1 ended!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent;
		DOTT_ocap_roundNum = DOTT_ocap_roundNum + 1;
	}
] call CBA_fnc_addEventHandler;

if !(OCAP_settings_autoStart) then 
{
	[
		"DOTT_round_ended", 
		{
			["ocap_pause"] call CBA_fnc_serverEvent;
		}
	] call CBA_fnc_addEventHandler;
};






