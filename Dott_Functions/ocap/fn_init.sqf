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

// --- Sector Capture --- //
{
	[_x, "ownerChanged", 
	{
		params ["_sector", "_owner", "_ownerOld"];
		private _sectorName = _sector getVariable ["name", "sector"];
		private _ownerName = _owner call BIS_fnc_sideName;
		["ocap_customEvent", ["generalEvent", format["%1 captured by %2", _sectorName, _ownerName]]] call CBA_fnc_serverEvent;
	}] call BIS_fnc_addScriptedEventHandler;
} forEach (allMissionObjects "ModuleSector_F");

addMissionEventHandler ["EntityCreated", 
{
	params ["_entity"];
	if (_entity isKindOf "ModuleSector_F") then 
	{
		[_entity, "ownerChanged", 
		{
			params ["_sector", "_owner", "_ownerOld"];
			private _sectorName = _sector getVariable ["name", "sector"];
			private _ownerName = _owner call BIS_fnc_sideName;
			["ocap_customEvent", ["generalEvent", format["%1 captured by %2", _sectorName, _ownerName]]] call CBA_fnc_serverEvent;
		}] call BIS_fnc_addScriptedEventHandler;
	};
}];

//Enable marker moves to be tracked
//Use ACE event to reduce spam to server
[
	"ace_markers_markerMoveEnded", //local event
	{
		params ["_player", "_marker", "_originalPos", "_finalPos"];
		private _isExcluded = false;
		if (!isNil "ocap_recorder_settings_excludeMarkerFromRecord") then {
		{
			if ((str _marker) find _x >= -1) exitWith {
			_isExcluded = true;
			};
		} forEach (parseSimpleArray ocap_recorder_settings_excludeMarkerFromRecord);
		};
		if (_isExcluded) exitWith {};

		private _pos = ATLToASL _finalPos;

		["ocap_handleMarker", ["UPDATED", _marker, _player, _pos, "", "", "", markerDir _marker, "", "", 1]] call CBA_fnc_serverEvent;		
	}
] call CBA_fnc_addEventHandler;

//Order matters, event won't register if recording is not currently happening
//However, dont start/pause recordings if autoStart is forced by server config
if !(OCAP_settings_autoStart) then 
{
	DOTT_ocap_fnc_startRecording = compile preprocessFileLineNumbers "DOTT_Functions\ocap\fn_startRecording.sqf";
	DOTT_ocap_fnc_stopRecording = compile preprocessFileLineNumbers "DOTT_Functions\ocap\fn_stopRecording.sqf";

	// Trigger a waitAndExecute in OCAP init.sqf so we can get rid of it.
	ocap_recorder_startTime = time;
	[{ocap_recorder_captureFrameNo > 0}, {call DOTT_ocap_fnc_stopRecording}] call CBA_fnc_waitUntilAndExecute;
	//Add marker workarounds
	[{!isNil "ocap_listener_markers"}, {call compile preprocessFileLineNumbers "DOTT_Functions\ocap\handleMarker.sqf"}] call CBA_fnc_waitUntilAndExecute;
};

//Workaround for major but unlikely issue where if save has no markers, it is formatted improperly.
createMarkerLocal ["DOTT_ocap_debugMarker", [0,0,0]];
"DOTT_ocap_debugMarker" setMarkerAlphaLocal 0;

//SafeStart Start
if !(OCAP_settings_autoStart) then 
{ 
	[
		"DOTT_round_safeStartBegin", 
		{
			call DOTT_ocap_fnc_startRecording;
		}
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_safeStartAborted", 
		{
			[{call DOTT_ocap_fnc_stopRecording}] call CBA_fnc_execNextFrame;
		}
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_started", 
		{
			if (OCAP_recorder_recording) exitWith {};
			call DOTT_ocap_fnc_startRecording;
		}
	] call CBA_fnc_addEventHandler;	

	[
		"DOTT_round_ended", 
		{
			[{call DOTT_ocap_fnc_stopRecording}] call CBA_fnc_execNextFrame;
		}
	] call CBA_fnc_addEventHandler;	
};

//SafeStart Start
[
	"DOTT_round_safeStartBegin", 
	{
		[{["ocap_customEvent", ["generalEvent", "Safe start began!"]] call CBA_fnc_serverEvent}] call CBA_fnc_execNextFrame;
	}
] call CBA_fnc_addEventHandler;

//Safe Start Aborted
[
	"DOTT_round_safeStartAborted", 
	{
		["ocap_customEvent", ["generalEvent", "Safe start aborted!"]] call CBA_fnc_serverEvent;
	}
] call CBA_fnc_addEventHandler;

//Round Start
[
	"DOTT_round_started", 
	{
		[{["ocap_customEvent", ["generalEvent", format ["Round %1 started!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent}] call CBA_fnc_execNextFrame;
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
