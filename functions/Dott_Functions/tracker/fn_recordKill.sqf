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

//Player manual respawned without taking known damage
if (isNil "_lastHit" && _killer == _unit && isNull _instigator) exitWith { false }; 

if !(isNil "_lastHit") then 
{
	//[name, side, pos, weapon];
	private _instigatorInfo = _lastHit select 0;
	private _hitTime = _lastHit select 1;	
	_killInfo pushBack [_instigatorInfo select 0, _instigatorInfo select 1];
	private _distance = round (_unit distance (_instigatorInfo select 2));		
	_killInfo pushBack _distance;
	_killInfo pushBack (_instigatorInfo select 3);

	//Player respawns after taking damage or bleeds out
	if ((_timeStamp - _hitTime > DELAY_TIME) && _eventType == INFANTRY_KILL_NUM) then
	{
		_eventType = DELAY_KILL_NUM;
		_timeStamp = [_timeStamp, _hitTime];
	};
} else 
{
	//Road kill check
	if !(_unit isKindOf "Man") exitWith {}; 
	if (isNull _instigator) then { _instigator = (UAVControl (vehicle _killer)) select 0 }; 
	if (isNull _instigator) then { _instigator = _killer }; 
	if (_instigator isKindOf "AllVehicles") then 
	{
		_instigator = [_instigator] call 
		{
			params["_instigator"];
			if(!isNull (driver _instigator)) exitWith { driver _instigator };
			effectiveCommander _instigator //if not in vehicle returns player unit
		};
	};
	if (isPlayer [_instigator] && _unit != _instigator && !isNull (objectParent _instigator)) then
	{
		_killInfo pushBack [name _instigator, side (group _instigator)];
		private _distance = round (_unit distance _instigator);		
		_killInfo pushBack _distance;
		_killInfo pushBack ([objectParent _instigator] call DOTT_tracker_fnc_getName) + " - Roadkill";
	};
};
private _event = [_eventType, _timeStamp, _killInfo];

[_event] spawn DOTT_tracker_fnc_saveEvent;

true