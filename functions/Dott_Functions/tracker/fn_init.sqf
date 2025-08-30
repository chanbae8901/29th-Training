/*
 * Name:	fnc_init
 * Date:	8/30/2025
 * Version: 1.2
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

	// --- Kill --- //
	//wont catch road kills	
	addMissionEventHandler ["EntityKilled", 
	{
		params ["_unit", "_killer", "_instigator"];
		if !(isPlayer _unit || (!(_unit isKindOf "Man") && _unit isKindOf "AllVehicles")) exitWith {};
		[_unit, _killer, _instigator] call DOTT_tracker_fnc_recordKill;
	}];

	// --- Consciousness --- //	
	[
		"ace_unconscious", 
		{ _this call DOTT_tracker_fnc_recordACEConscious; }
	]
	call CBA_fnc_addEventHandler;

	// --- Attacker Info --- //	
	addMissionEventHandler ["EntityRespawned", 
	{
		params ["_entity"];

		_entity setVariable ["DOTT_lastHit", nil];		
		
		if (local _entity || !isPlayer _entity) exitWith {}; 

		[_entity] spawn DOTT_tracker_fnc_addEventHandlersUnit;
	}];

	["ace_explosives_place", 
	{
		params ["_explosive", "_dir", "_pitch", "_unit"];
		private _explosiveName = getText (configFile >> "CfgMagazines" >> getText (configFile >> "CfgAmmo" >> typeOf _explosive >> "defaultMagazine") >> "displayName");
		if (_explosiveName == "") then {_explosiveName = "Placed Explosive"};
		private _data = [name _unit, side (group _unit), getPosATL _unit, _explosiveName];
		_explosive setVariable ["DOTT_instigatorInfo", _data];
		_explosive addEventHandler ["HitExplosion", 
		{
			_this call DOTT_tracker_fnc_projectileHit;
		}];	
		//bouncing mines
		_explosive addEventHandler ["SubmunitionCreated", {
			params ["_projectile", "_submunitionProjectile"];
			_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
			_submunitionProjectile addEventHandler ["HitExplosion", {
				_this call DOTT_tracker_fnc_projectileHit;
			}];						
		}];		
	}] call CBA_fnc_addEventHandler;

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
	// --- Attacker Info --- //	
	[] spawn 
	{
		waitUntil {!isNull player};
		[player] remoteExec ["DOTT_tracker_fnc_addEventHandlersUnit", 2];
	};

	
	// --- Remove Statistics from Map, Send All Round Histories --- //	
	DOTT_tracker_last_round_Recorded = 0;

	addMissionEventHandler ["PreloadFinished", 
	{
		[player] remoteExec ["DOTT_tracker_fnc_sendAll", 2];
		player removeDiarySubject "Statistics";	
		removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
	}];
};





