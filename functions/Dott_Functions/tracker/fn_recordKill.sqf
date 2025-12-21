/*
 * Name:	DOTT_tracker_fnc_recordKill
 * Date:	9/30/2025
 * Version: 1.3
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

private _unitSide = side (group _unit); //need group since ACE3? sets uncon men to CIV but not the group

private _killInfo = [[_unitName, _unitSide]]; 

private _lastHit = _unit getVariable "DOTT_lastHit";
if !(isNil "_lastHit") then {
	_lastHit append ((_unit getVariable "DOTT_hitMap") get _lastHit);
};

//Player manual respawned without taking known damage
if (isNil "_lastHit" && _killer == _unit && isNull _instigator) exitWith { false }; 

if (isNull _instigator) then //backup for unknown cases
{ 
	private _crew = crew _killer;
	if (count _crew > 0) then 
	{
		_instigator = _crew select 0; 
	} 
	else 
	{
		_instigator = _killer; 
	};
}; 

//Special case for incendiary grenades killing vehicles
private _override = false;
if (_eventType == VEHICLE_KILL_NUM && isNull _instigator) then
{
	//look for ACE/RHS incendiary grenade
	private _grenades = (position _unit) nearObjects ["GrenadeHand", 10];
	private _weapon = "";

	{
		if ((typeOf _x) == "ACE_G_M14") exitWith { _weapon = "ACE AN-M14"; _instigator = (getShotParents _x) select 0; _override = true };
		if ((typeOf _x) == "rhs_ammo_an_m14_th3") exitWith { _weapon = "RHS AN-M14"; _instigator = (getShotParents _x) select 0; _override = true };					
	}
	forEach _grenades;

	if !(isNull _instigator) then 
	{
		private _distance = round ((getPosASL _unit) distance (getPosASL _instigator));
		private _side = side (group _instigator);
		if (_side == sideUnknown) then //dead man
		{
			//might work improperly if zeus changed player side
			_side = getNumber (configFile >> "CfgVehicles" >> typeOf _instigator >> "side") call BIS_fnc_sideType;
		};
		_killInfo append [[_instigator call DOTT_tracker_fnc_getName, _side], _distance, _weapon];

		private _instigatorInfo = [_instigator call DOTT_tracker_fnc_getName, _side, getPosASL _instigator, _weapon, _timeStamp];

		{
			[_x, _instigatorInfo] call DOTT_tracker_fnc_sendHit;
		}
		forEach (crew _unit);
	};
};

if !(isNil "_lastHit" && !_override) then 
{
	if !(isNull _instigator) then 
	{
		private _side = side (group _instigator);
		if (_side == sideUnknown) then //dead man
		{
			//might work improperly if zeus changed player side
			_side = getNumber (configFile >> "CfgVehicles" >> typeOf _instigator >> "side") call BIS_fnc_sideType;
		};
		_lastHit = [_instigator call DOTT_tracker_fnc_getName, _side];
		private _hitInfo = (_unit getVariable "DOTT_hitMap") get _lastHit;
		if (isNil "_hitInfo") then { _hitInfo = [getPosASL _instigator, "?", _timeStamp] }; 
		_lastHit append (_hitInfo);
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

[_event] call DOTT_tracker_fnc_saveEvent;

true