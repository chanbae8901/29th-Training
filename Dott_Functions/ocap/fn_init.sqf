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

/*
	A large amount of code in this folder is taken from OCAP 2 Addon.
	https://github.com/OCAP2/OCAP?tab=License-1-ov-file#readme
*/

//NOTE: OCAP settings defined in cba_settings.sqf

if (isServer) then 
{
	if !(isClass (configFile >> "CfgPatches" >> "OCAP_recorder")) exitWith {};

	DOTT_ocap_roundNum = 1;

	// --- Sector --- //
	DOTT_ocap_fnc_handleSector = compileFinal preprocessFileLineNumbers "DOTT_Functions\ocap\fn_handleSector.sqf";	
	DOTT_ocap_fnc_createSectorMarkers = compileFinal preprocessFileLineNumbers "DOTT_Functions\ocap\fn_createSectorMarkers.sqf";

	{
		_x call DOTT_ocap_fnc_handleSector;
	} forEach (allMissionObjects "ModuleSector_F");

	addMissionEventHandler ["EntityCreated", 
	{
		params ["_entity"];
		if (_entity isKindOf "ModuleSector_F") then 
		{
			[] spawn 
			{
				sleep 10;
				_entity call DOTT_ocap_fnc_handleSector;
			}		
		};
	}];

	//Order matters, event won't register if recording is not currently happening
	//However, dont start/pause recordings if autoStart is forced by server config
	if !(OCAP_settings_autoStart) then 
	{
		DOTT_ocap_fnc_startRecording = compile preprocessFileLineNumbers "DOTT_Functions\ocap\fn_startRecording.sqf";
		DOTT_ocap_fnc_stopRecording = compile preprocessFileLineNumbers "DOTT_Functions\ocap\fn_stopRecording.sqf";

		DOTT_ocap_fnc_initializePlayer = compile preprocessFileLineNumbers "DOTT_Functions\ocap\fn_initializePlayer.sqf";

		// Trigger a waitAndExecute in OCAP init.sqf so we can get rid of it.
		[{!isNil "ocap_recorder_captureFrameNo"}, {ocap_recorder_startTime = time}] call CBA_fnc_waitUntilAndExecute;
		[{ocap_recorder_captureFrameNo > 0}, {call DOTT_ocap_fnc_stopRecording}] call CBA_fnc_waitUntilAndExecute;
		//Add marker workarounds
		[{!isNil "ocap_listener_markers"}, {call compile preprocessFileLineNumbers "DOTT_Functions\ocap\handleMarker.sqf"}] call CBA_fnc_waitUntilAndExecute;
	};

	[OCAP_settings_autoStart] remoteExec ["DOTT_ocap_fnc_initClient", [0, -2] select isDedicated, true];

	//Workaround for major but unlikely issue where if save has no markers, it is formatted improperly.
	createMarkerLocal ["DOTT_ocap_debugMarker", [0,0,0]];
	"DOTT_ocap_debugMarker" setMarkerAlphaLocal 0;

	[
		"DOTT_round_safeStartBegin", 
		{
			if !(OCAP_settings_autoStart) then 
			{ 
				call DOTT_ocap_fnc_startRecording;
			};

			["ocap_customEvent", ["generalEvent", "Safe start began!"]] call CBA_fnc_serverEvent;
		}
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_safeStartAborted", 
		{
			["ocap_customEvent", ["generalEvent", "Safe start aborted!"]] call CBA_fnc_serverEvent;

			if !(OCAP_settings_autoStart) then 
			{ 
				call DOTT_ocap_fnc_stopRecording;
			};
		}
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_started", 
		{
			if !(OCAP_settings_autoStart || OCAP_recorder_recording) then 
			{ 				
				call DOTT_ocap_fnc_startRecording;
			};

			["ocap_customEvent", ["generalEvent", format ["Round %1 started!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent;			
		}
	] call CBA_fnc_addEventHandler;	

	[
		"DOTT_round_ended", 
		{
			["ocap_customEvent", ["generalEvent", format ["Round %1 ended!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent;
			DOTT_ocap_roundNum = DOTT_ocap_roundNum + 1;
			call DOTT_ocap_fnc_stopRecording;
		}
	] call CBA_fnc_addEventHandler;	
};


