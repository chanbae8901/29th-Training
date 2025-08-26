/*
 * Name:	fnc_init
 * Date:	8/26/2025
 * Version: 1.1
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
	DOTT_tracker_previous = [];
	DOTT_tracker_events = [];
	DOTT_tracker_names = [];
	DOTT_tracker_sides = [];
	DOTT_tracker_weapons = [];	
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
			DOTT_tracker_weapons = [];								
		} 
	] call CBA_fnc_addEventHandler;

	// --- Vehicle Kill --- //	
	addMissionEventHandler ["EntityKilled", 
	{
		params ["_unit", "_killer", "_instigator"];
		if (!(_unit isKindOf "AllVehicles") || (_unit isKindOf "Man")) exitWith {};
		[_unit, _killer, _instigator] call DOTT_tracker_fnc_recordKill;
	}];

	// --- Tracker Diary --- //
	[
		"DOTT_round_ended",
		{
			DOTT_tracker_startTime = -1;
			publicVariable "DOTT_tracker_startTime";
			[] spawn {
				uiSleep 3; //wait for last events to arrive

				//can be out of order due to delaying ACE Unconsious send or due to latency
				DOTT_tracker_events = [DOTT_tracker_events, [], {_x select 1}] call BIS_fnc_sortBy;

				[
					DOTT_tracker_events,
					DOTT_tracker_names,
					DOTT_tracker_sides,	
					DOTT_tracker_weapons,
					DOTT_tracker_currentRound
				] remoteExec ["DOTT_tracker_fnc_createDiaryEntries"];

				DOTT_tracker_previous pushBack 
				[	
					+DOTT_tracker_events,
					+DOTT_tracker_names,
					+DOTT_tracker_sides,
					+DOTT_tracker_weapons
				];

				DOTT_tracker_currentRound = DOTT_tracker_currentRound + 1;	
			}
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
	DOTT_tracker_backupInstigatorName = "Unknown";
	DOTT_tracker_lastNonNullInstigator = nil;
	DOTT_tracker_lastInstigatorWeapon = "Unknown";

	[] spawn 
	{
		waitUntil {!isNull player};
		player addEventHandler ["Killed", 
		{
			params ["_unit", "_killer", "_instigator"];
			[_unit, _killer, _instigator] call DOTT_tracker_fnc_recordKill;
		}];
		player addEventHandler ["Respawn", 
		{
			DOTT_tracker_backupInstigatorName = "Unknown";
			DOTT_tracker_lastNonNullInstigator = nil;	
			DOTT_tracker_lastInstigatorWeapon = "Unknown";					
		}];	
		player addEventHandler ["HandleDamage", 
		{
			private _projectile = _this select 4;
			private _instigator = _this select 6;
			if (!isNull _instigator) then 
			{ 
				DOTT_tracker_lastNonNullInstigator =  _instigator;
				DOTT_tracker_lastInstigatorWeapon = [_projectile, _instigator] call DOTT_tracker_fnc_getWeapon;
			};	
		}];		

	};

	// --- Consciousness --- //	
	[
		"ace_unconscious", 
		{ _this call DOTT_tracker_fnc_recordACEConscious; }
	]
	call CBA_fnc_addEventHandler;

	// --- Remove Statistics from Map, Send All Round Histories --- //	
	addMissionEventHandler ["PreloadFinished", {
		player removeDiarySubject "Statistics";
		[player] remoteExec ["DOTT_tracker_fnc_sendAll", 2];
		removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
	}];

	//Vanilla + SOP Grenade Launchers
	DOTT_tracker_attachedGLs = ["M203", "M320", "GP-25", "PBG", "AG36", "VHS-BG", "3GL", "EGLM", "KGL"];
};



