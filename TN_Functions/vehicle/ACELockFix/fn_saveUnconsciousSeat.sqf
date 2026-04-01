#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Waits for ACE to set the locked-seat variable on an
 * unconscious unit, then snapshots it into a TN variable
 * so it can be restored later if ACE fails to unlock.
 *
 * Arguments:
 * 0: Unit in a vehicle seat <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [_unit] call TN_vehicle_fnc_saveUnconsciousSeat;
 */

params ["_unit"];

private _vehicle = objectParent _unit;

if (isNull _vehicle) exitWith {};
if (alive _unit && {lifeState _unit != "INCAPACITATED"}) exitWith {};

[
    { !isNil { _this getVariable "ace_medical_engine_lockedSeat" } },
    { _this setVariable [QGVAR(lockedSeat), _this getVariable "ace_medical_engine_lockedSeat", true] },
    _unit,
    10
] call CBA_fnc_waitUntilAndExecute;

nil
