/*
 * Author: Bae [29th ID]
 * Restores the saved locked-seat variable on a unit and
 * calls ACE's unlock function to free the vehicle seat.
 *
 * Arguments:
 * 0: Unit whose seat should be unlocked <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [_unit] call TN_vehicle_fnc_unlockUnconsciousSeat;
 */

params ["_unit"];

private _seat = _unit getVariable ["TN_vehicle_lockedSeat", []];
_seat params ["_vehicle", "_type", "_position"];

if (_seat isEqualTo []) exitWith {};

_unit setVariable ["ace_medical_engine_lockedSeat", _seat];

_unit call ace_medical_engine_fnc_unlockUnconsciousSeat;
