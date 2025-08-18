/*
 * Name:	fnc_getCurrentSide
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Finds current side of unit at _time given the units' index in _sides.
 *
 * Parameter(s): 
 * _unitIndex (Number): Where to find _unitSides in _sides
 * _time (Number): Time to check unit's side
 * _sides (Array): Array containing side history of all units
 *
 * Returns:
 * (Side) side of unit at _time 
 *
 * Example:
 * [0, 5, _sides] call DOTT_tracker_fnc_getCurrentSide;
 * 
 */

params ["_unitIndex", "_time", "_sides"];

private _unitSides = _sides select _unitIndex;
private _currentSide = sideUnknown;
for "_i" from (count _unitSides - 1) to 0 step - 1 do {
	private _sideTime = (_unitSides select _i) select 1;
	if (_time >= _sideTime) exitWith {_currentSide = (_unitSides select _i) select 0};
};

_currentSide
