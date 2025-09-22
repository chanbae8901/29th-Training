/*
 * Name:	DOTT_tracker_fnc_recordACEConscious
 * Date:	8/30/2025
 * Version: 1.2
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
if (!isPlayer _unit) exitWith { false };
private _timeStamp = round(serverTime - DOTT_tracker_startTime);
//need group since ACE3? sets unconscious men to CIV but not the group
private _eventInfo = [[name _unit, side (group _unit)], _state];
private _eventType = ACE_CONSCIOUSNESS_NUM;
if (_state) then 
{
	private _lastHit = _unit getVariable "DOTT_lastHit";

	if !(isNil "_lastHit") then 
	{
		//[name, side, pos, weapon];	
		private _instigatorInfo = _lastHit select 0;
		private _hitTime = _lastHit select 1;		
		_eventInfo pushBack [_instigatorInfo select 0, _instigatorInfo select 1];
		private _distance = round (_unit distance (_instigatorInfo select 2));
		_eventInfo pushBack _distance;
		_eventInfo pushBack (_instigatorInfo select 3);
		if (_timeStamp - _hitTime > DELAY_TIME) then 
		{ 
			_eventType = DELAY_ACE_CONSCIOUSNESS_NUM;
			_timeStamp = [_timeStamp, _hitTime];
		};
	} else
	{
		//try to find roadkill, blame any vehicle nearby
		private _nearbyVehicles = _unit nearEntities ["LandVehicle", 7]; //7 meters
		if (count _nearbyVehicles == 0) exitWith {}; 
		private _vehicle = _nearbyVehicles select 0;
		private _instigator = driver _vehicle;
		if (isNull _instigator) then { _instigator = (UAVControl _vehicle) select 0 };
		if (_vehicle isKindOf "StaticWeapon" || isNull _instigator) exitWith {};
		_eventInfo pushBack [name _instigator, side (group _instigator)];
		private _distance = round (_unit distance _instigator);		
		_eventInfo pushBack _distance;
		_eventInfo pushBack ([_vehicle] call DOTT_tracker_fnc_getName) + " - Roadkill";		
	};
};

private _event = [_eventType, _timeStamp, _eventInfo];
[_event] spawn DOTT_tracker_fnc_saveEvent;

true
