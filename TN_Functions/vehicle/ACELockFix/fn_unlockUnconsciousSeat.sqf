params ["_unit"];

private _seat = _unit getVariable ["TN_vehicle_lockedSeat", []];
_seat params ["_vehicle", "_type", "_position"];

if (_seat isEqualTo []) exitWith {};

_unit setVariable ["ace_medical_engine_lockedSeat", _seat];

_unit call ace_medical_engine_fnc_unlockUnconsciousSeat;
