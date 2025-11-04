/*
 * Name:	DOTT_tracker_fnc_recordACEConscious
 * Date:	9/30/2025
 * Version: 1.3
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
		_lastHit append ((_unit getVariable "DOTT_hitMap") get _lastHit);
		//[name, side, distance, weapon, time];	
		private _hitTime = _lastHit select 4;		
		_eventInfo append [[_lastHit select 0, _lastHit select 1], round ((getPosASL _unit) distance (_lastHit select 2)), _lastHit select 3];
		if (_timeStamp - _hitTime > DELAY_TIME) then 
		{ 
			_eventType = DELAY_ACE_CONSCIOUSNESS_NUM;
			_timeStamp = [_timeStamp, _hitTime];
		};
	};
};

private _event = [_eventType, _timeStamp, _eventInfo];
[_event] call DOTT_tracker_fnc_saveEvent;

true
