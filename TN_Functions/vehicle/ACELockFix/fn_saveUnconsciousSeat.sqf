params ["_unit"];

private _vehicle = objectParent _unit;

if (isNull _vehicle) exitWith {};
if (alive _unit && {lifeState _unit != "INCAPACITATED"}) exitWith {};

[
    { !isNil { _this getVariable "ace_medical_engine_lockedSeat" } },
    { _this setVariable ["TN_vehicle_lockedSeat", _this getVariable "ace_medical_engine_lockedSeat", true] },
    _unit
] call CBA_fnc_waitUntilAndExecute;
