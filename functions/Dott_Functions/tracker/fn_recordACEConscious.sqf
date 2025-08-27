/*
 * Name:	fnc_recordACEConscious
 * Date:	8/26/2025
 * Version: 1.1
 * Author:  Bae [29th ID]
 *
 * Description:
 * Client side function that constructs array of "ace_unconscious" event for tracker.
 * Tracks when unit is knocked unconscious or regains consciousness.
 * If knocked unconscious, attempts to find out who did it and stores the result.
 *
 * Parameter(s): 
 * _unit: Unit in event.
 * _state: True if unit turned unconscious, false if unit turned conscious.
 * Reference "ace_unconscious" event in ACE3.
 * 
 * Returns:
 * true if saved, false otherwise
 *
 * Example:
 * [_unit, false] call DOTT_tracker_fnc_recordACEConscious;
 * 
 */

#include "eventNumbers.hpp"
params["_unit", "_state"];
if (DOTT_tracker_startTime == -1) exitWith { false };
if (player != _unit) exitWith { false }; //we want this to run local to the unit
private _timeStamp = round(serverTime - DOTT_tracker_startTime);
//need group since ACE3? sets unconscious men to CIV but not the group
private _eventInfo = [[name _unit, side (group _unit)], _state];
if (_state) then 
{
	private _instigator = [_unit, _unit, objNull] call DOTT_tracker_fnc_findInstigator;
	if (!isNull _instigator) then 
	{
		private _instigatorName = _unit getVariable ["DOTT_tracker_backupInstigatorName", nil];
		if (!isNil {_instigatorName}) then 
		{		
			_eventInfo pushBack [_instigatorName, side (group _instigator)];
			private _distance = _unit getVariable ["DOTT_tracker_lastDistance", 0];
			_eventInfo pushBack _distance;
			_eventInfo pushBack (_unit getVariable ["DOTT_tracker_lastInstigatorWeapon", "Unknown"]);
		};
	};
};

private _event = [ACE_CONSCIOUSNESS_NUM, _timeStamp, _eventInfo];

//don't report unconscious close to death to reduce events
DOTT_tracker_deathCloseToUnconscious = false;
[_event] spawn {
	params["_event"];
	uisleep 2;
	if (DOTT_tracker_deathCloseToUnconscious) exitWith {}; 
	[_event] remoteExec ["DOTT_tracker_fnc_saveEvent", 2]; 
};


true
