/*
 * Name:	fnc_init
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes tracker system both server and client side.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * Nothing
 *
 * Example:
 * call DOTT_tracker_fnc_init;
 * 
 */

if (isServer) then
{
	DOTT_tracker_events = [];
	DOTT_tracker_names = [];
	DOTT_tracker_sides = [];	
	DOTT_tracker_currentRound = 1;

	DOTT_tracker_startTime = -1;	
	publicVariable "DOTT_tracker_startTime";
	[
		"DOTT_round_started",
		{
			DOTT_tracker_startTime = serverTime;
			publicVariable "DOTT_tracker_startTime";	

			DOTT_tracker_events = [];
			DOTT_tracker_names = [];	
			DOTT_tracker_sides = [];							
		} 
	] call CBA_fnc_addEventHandler;

	// --- Vehicle Kill --- //	
	addMissionEventHandler ["EntityKilled", 
	{
		params ["_unit", "_killer", "_instigator"];
		if (_unit isKindOf "Man") exitWith {};
		[_unit, _killer, _instigator] call DOTT_tracker_fnc_recordKill;
	}];

	// --- Tracker Diary --- //
	[
		"DOTT_round_ended",
		{
			DOTT_tracker_startTime = -1;
			publicVariable "DOTT_tracker_startTime";

			[
				DOTT_tracker_events,
				DOTT_tracker_names,
				DOTT_tracker_sides,	
				DOTT_tracker_currentRound
			] remoteExec ["DOTT_tracker_fnc_createDiaryEntry"];

			DOTT_tracker_currentRound = DOTT_tracker_currentRound + 1;			
		} 
	] call CBA_fnc_addEventHandler;

	// --- Sector Capture --- //
	{
		[_x, "ownerChanged", 
		{
			_this call DOTT_tracker_fnc_recordSectorCapture;
		}] call BIS_fnc_addScriptedEventHandler;
	} forEach (allMissionObjects "ModuleSector_F");

	addMissionEventHandler ["EntityCreated", 
	{
		params ["_entity"];
		if (_entity isKindOf "ModuleSector_F") then 
		{
			[_entity, "ownerChanged", 
				{ _this call DOTT_tracker_fnc_recordSectorCapture;}
			] call BIS_fnc_addScriptedEventHandler;
		};
	}];
}; 

if (hasInterface) then 
{
	// --- Infantry Kill --- //	
	player addEventHandler ["Killed", 
	{
		params ["_unit", "_killer", "_instigator"];
		[_unit, _killer, _instigator] call DOTT_tracker_fnc_recordKill;
	}];

	// --- Consciousness --- //	
	[
		"ace_unconscious", 
		{ _this call DOTT_tracker_fnc_recordACEConscious; }
	]
	call CBA_fnc_addEventHandler;	
};



