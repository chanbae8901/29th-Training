/*
 * Name:	DOTT_tracker_fnc_recordKill
 * Date:	8/30/2025
 * Version: 1.2
 * Author:  Bae [29th ID]
 *
 * Description:
 * Client side function that constructs array of "Killed/EntityKilled" event for tracker.
 * Tracks when unit is killed and attempts to find out who did it and stores it.
 *
 * Parameter(s): 
 * [_unit, _killer, _instigator] reference Killed/EntityKilled events.
 * 
 * Returns:
 * true if saved, false otherwise
 *
 * Example:
 * [_unit, _killer, _instigator] call DOTT_tracker_fnc_recordKill;
 * 
 */

#include "eventNumbers.hpp"
params ["_unit", "_killer", "_instigator"];
if (DOTT_tracker_startTime == -1) exitWith { false };

private _timeStamp = round(serverTime - DOTT_tracker_startTime);

private _eventType = if (_unit isKindOf "Man") then {INFANTRY_KILL_NUM} else {VEHICLE_KILL_NUM};

private _unitName = [_unit] call DOTT_tracker_fnc_getName;

private _unitSide = side (group _unit); //need group since ACE3? sets dead men to CIV but not the group

private _killInfo = [[_unitName, _unitSide]]; 

private _lastHit = _unit getVariable "DOTT_lastHit";
if !(isNil "_lastHit") then {
	_lastHit append ((_unit getVariable "DOTT_hitMap") get _lastHit);
};

//Player manual respawned without taking known damage
if (isNil "_lastHit" && _killer == _unit && isNull _instigator) exitWith { false }; 

if !(isNil "_lastHit") then 
{
	if !(isNull _instigator) then 
	{
		_lastHit = [_instigator call DOTT_tracker_fnc_getName, side (group _instigator)];
		_lastHit append ((_unit getVariable "DOTT_hitMap") get _lastHit);
		//[name, side, distance, weapon];
		private _hitTime = _lastHit select 4;	
		private _distance = round ((getPosASL _unit) distance (_lastHit select 2));
		_killInfo append [[_lastHit select 0, _lastHit select 1], _distance, _lastHit select 3];

		//Player respawns after taking damage or bleeds out
		if ((_timeStamp - _hitTime > DELAY_TIME) && _eventType == INFANTRY_KILL_NUM) then
		{
			_eventType = DELAY_KILL_NUM;
			_timeStamp = [_timeStamp, _hitTime];
		};			
	}
	else 
	{
		//died to fall damage, burn, ace fragmentation
		//give kill credit to last projectile hit if exists
		private _hitTime = _lastHit select 4;	
		private _distance = round ((getPosASL _unit) distance (_lastHit select 2));		
		_killInfo append [[_lastHit select 0, _lastHit select 1], _distance, _lastHit select 3];

		//Player respawns after taking damage or bleeds out
		if ((_timeStamp - _hitTime > DELAY_TIME) && _eventType == INFANTRY_KILL_NUM) then
		{
			_eventType = DELAY_KILL_NUM;
			_timeStamp = [_timeStamp, _hitTime];
		};		
	};
}; 
private _event = [_eventType, _timeStamp, _killInfo];

[_event] spawn DOTT_tracker_fnc_saveEvent;

true