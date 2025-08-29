/*
 * Name:	fnc_recordKill
 * Date:	8/26/2025
 * Version: 1.1
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

_instigator = [_unit, _killer, _instigator] call DOTT_tracker_fnc_findInstigator;

private _timeStamp = round(serverTime - DOTT_tracker_startTime);

if (_unit isKindOf "Man") then 
{ DOTT_tracker_deathCloseToUnconscious = true };

private _eventType = if (_unit isKindOf "Man") then {INFANTRY_KILL_NUM} else {VEHICLE_KILL_NUM};
private _event = [_eventType, _timeStamp];

private _unitName = "";
//if unit is not man then name does not work properly
if (_unit isKindOf "Man") then 
{
    _unitName = name _unit;
} else 
{
	_unitName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
	if (_unitName == "") then {_unitName = "Vehicle"}; 
};

private _unitSide = side (group _unit); //need group since ACE3? sets dead men to CIV but not the group

private _killInfo = [[_unitName, _unitSide]]; 

if !(isNull _instigator) then 
{
	private _instigatorName = name _instigator;
	if (_instigatorName == "") then {_unit getVariable ["DOTT_tracker_backupInstigatorName", nil]};
	if (!isNil {_instigatorName}) then 
	{
		_killInfo pushBack [_instigatorName, side (group _instigator)];
		private _distance = _unit getVariable ["DOTT_tracker_lastDistance", 0];
		_killInfo pushBack _distance;
		_killInfo pushBack (_unit getVariable ["DOTT_tracker_lastInstigatorWeapon", "Unknown"]);
	};
};

_event pushBack _killInfo;

//_event is now either
//[[INFANTRY_KILL_NUM, _timeStamp, [[name _unit, side _unit], [name _instigator, side _instigator], _distance]]
//[[INFANTRY_KILL_NUM, _timeStamp, [name _unit, side _unit]]
[_event] remoteExec ["DOTT_tracker_fnc_saveEvent", 2];

true