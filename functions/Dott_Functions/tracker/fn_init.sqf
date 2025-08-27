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

	// --- Tracker Diary --- //
	[
		"DOTT_round_ended",
		{
			DOTT_tracker_startTime = -1;
			publicVariable "DOTT_tracker_startTime";
			[] spawn 
			{
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
	DOTT_tracker_last_round_Recorded = 0;

	// --- Infantry Kill --- //	
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
			params ["_unit", "_corpse"];
			_unit setVariable ["DOTT_tracker_backupInstigatorName", nil];
			_unit setVariable ["DOTT_tracker_lastNonNullInstigator", nil];	
			_unit setVariable ["DOTT_tracker_lastInstigatorWeapon", nil];
			_unit setVariable ["DOTT_tracker_lastDistance", nil];												
		}];	
		player addEventHandler ["HandleDamage", 
		{
			private _unit = _this select 0;
			private _projectile = _this select 4;
			private _instigator = _this select 6;

			if (player != _unit) exitWith 
			{
				_unit removeEventHandler ["HandleDamage", _thisEventHandler];
				nil
			}; 

			if (!isNull _instigator) then 
			{
				private _instigatorName = "";
				//if unit is not man then name does not work properly
				if (_instigator isKindOf "Man") then 
				{
					_instigatorName = name _instigator;
				} else 
				{
					_instigatorName = getText (configFile >> "CfgVehicles" >> typeOf _instigator >> "displayName");
					if (_instigatorName == "") then {_instigatorName = "Vehicle"}; 
				};
				_unit setVariable ["DOTT_tracker_backupInstigatorName", _instigatorName];					 
				_unit setVariable ["DOTT_tracker_lastNonNullInstigator", _instigator];
				_unit setVariable ["DOTT_tracker_lastInstigatorWeapon", [_unit, _projectile, _instigator] call DOTT_tracker_fnc_getWeapon];
				_unit setVariable ["DOTT_tracker_lastDistance", round (_unit distance _instigator)];
			};	

			nil
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
		[player] remoteExec ["DOTT_tracker_fnc_sendAll", 2];
		player removeDiarySubject "Statistics";	
		removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
	}];

	//Vanilla + SOP Grenade Launchers
	DOTT_tracker_attachedGLs = ["M203", "M320", "GP-25", "PBG", "AG36", "VHS-BG", "3GL", "EGLM", "KGL"];
};

//Both server and client

// --- Vehicle Kill --- //	
addMissionEventHandler ["EntityKilled", 
{
	params ["_unit", "_killer", "_instigator"];
	if (!local _unit) exitWith {};
	if (!(_unit isKindOf "AllVehicles") || (_unit isKindOf "Man")) exitWith {};
	[_unit, _killer, _instigator] call DOTT_tracker_fnc_recordKill;
}];


addMissionEventHandler ["EntityCreated", 
{
	params ["_entity"];
	if (_entity isKindOf "AllVehicles" && !(_entity isKindOf "Man")) then 
	{
		_entity addEventHandler ["HandleDamage", 
		{
			private _unit = _this select 0;
			private _projectile = _this select 4;
			private _instigator = _this select 6;

			if (!alive _unit) exitWith 
			{
				_unit removeEventHandler ["HandleDamage", _thisEventHandler];
				nil
			}; 

			if (!isNull _instigator) then 
			{
				private _instigatorName = "";
				//if unit is not man then name does not work properly
				if (_instigator isKindOf "Man") then 
				{
					_instigatorName = name _instigator;
				} else 
				{
					_instigatorName = getText (configFile >> "CfgVehicles" >> typeOf _instigator >> "displayName");
					if (_instigatorName == "") then {_instigatorName = "Vehicle"}; 
				};
				_unit setVariable ["DOTT_tracker_backupInstigatorName", _instigatorName];					 
				_unit setVariable ["DOTT_tracker_lastNonNullInstigator", _instigator];
				_unit setVariable ["DOTT_tracker_lastInstigatorWeapon", [_unit, _projectile, _instigator] call DOTT_tracker_fnc_getWeapon];
				_unit setVariable ["DOTT_tracker_lastDistance", round (_unit distance _instigator)];				
			};		
			nil
		}];	
		_entity addEventHandler ["Local", {
			params ["_entity", "_isLocal"];
			if (_isLocal) exitWith {};

			private _backupName = _entity getVariable ["DOTT_tracker_backupInstigatorName", nil];
			if (!isNil "_backupName") then
			{
				_entity setVariable ["DOTT_tracker_backupInstigatorName", _backupName, owner _entity];
			};

			private _lastInstigator = _entity getVariable ["DOTT_tracker_lastNonNullInstigator", nil];
			if (!isNil "_lastInstigator") then 
			{
				_entity setVariable ["DOTT_tracker_lastNonNullInstigator", _lastInstigator, owner _entity];
			};

			private _lastWeapon = _entity getVariable ["DOTT_tracker_lastInstigatorWeapon", nil];
			if (!isNil "_lastWeapon") then
			{
				_entity setVariable ["DOTT_tracker_lastInstigatorWeapon", _lastWeapon, owner _entity];
			};		

			private _lastDistance = _entity getVariable ["DOTT_tracker_lastDistance", nil];
			if (!isNil "_lastDistance") then
			{
				_entity setVariable ["DOTT_tracker_lastDistance", _lastDistance, owner _entity];	
			};			
		}];				
	};
}];

{
	if !(_x isKindOf "Man") then 
	{
		_x addEventHandler ["HandleDamage", 
		{
			private _unit = _this select 0;
			private _projectile = _this select 4;
			private _instigator = _this select 6;

			if (!alive _unit) exitWith 
			{
				_unit removeEventHandler ["HandleDamage", _thisEventHandler];
				nil
			}; 

			if (!isNull _instigator) then 
			{
				private _instigatorName = "";
				//if unit is not man then name does not work properly
				if (_instigator isKindOf "Man") then 
				{
					_instigatorName = name _instigator;
				} else 
				{
					_instigatorName = getText (configFile >> "CfgVehicles" >> typeOf _instigator >> "displayName");
					if (_instigatorName == "") then {_instigatorName = "Vehicle"}; 
				};
				_unit setVariable ["DOTT_tracker_backupInstigatorName", _instigatorName];					 
				_unit setVariable ["DOTT_tracker_lastNonNullInstigator", _instigator];
				_unit setVariable ["DOTT_tracker_lastInstigatorWeapon", [_unit, _projectile, _instigator] call DOTT_tracker_fnc_getWeapon];
				_unit setVariable ["DOTT_tracker_lastDistance", round (_unit distance _instigator)];
			};	
			nil
		}];		
		_x addEventHandler ["Local", {
			params ["_entity", "_isLocal"];
			if (_isLocal) exitWith {};

			private _backupName = _entity getVariable ["DOTT_tracker_backupInstigatorName", nil];
			if (!isNil "_backupName") then
			{
				_entity setVariable ["DOTT_tracker_backupInstigatorName", _backupName, owner _entity];
			};

			private _lastInstigator = _entity getVariable ["DOTT_tracker_lastNonNullInstigator", nil];
			if (!isNil "_lastInstigator") then 
			{
				_entity setVariable ["DOTT_tracker_lastNonNullInstigator", _lastInstigator, owner _entity];
			};

			private _lastWeapon = _entity getVariable ["DOTT_tracker_lastInstigatorWeapon", nil];
			if (!isNil "_lastWeapon") then
			{
				_entity setVariable ["DOTT_tracker_lastInstigatorWeapon", _lastWeapon, owner _entity];
			};

			private _lastDistance = _entity getVariable ["DOTT_tracker_lastDistance", nil];
			if (!isNil "_lastDistance") then
			{
				_entity setVariable ["DOTT_tracker_lastDistance", _lastDistance, owner _entity];	
			};
		}];
	};
} forEach allMissionObjects "AllVehicles";



