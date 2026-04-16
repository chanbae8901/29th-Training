#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Handles EntityKilled for vehicle cookoff tracking.
 * Records destroyed vehicles and their instigators for
 * delayed explosion attribution.
 *
 * Arguments:
 * EntityKilled EH params
 *
 * Return Value:
 * Nothing
 */

#define VEHICLE_GRENADE_DISTANCE 10

params ["_unit", "_killer", "_instigator"];
if !(_unit isKindOf "AllVehicles") exitWith {};
if (_unit isKindOf "CAManBase") exitWith {};
// Delayed vehicle explosions seem to not have
// instigator.
if (isNull _instigator) then {
    _instigator = effectiveCommander _killer;
};
if (isNull _instigator) then {
    // Look for ACE/RHS incendiary grenade.
    private _grenades = (position _unit) nearObjects ["GrenadeHand", VEHICLE_GRENADE_DISTANCE];
    {
        if (
            (typeOf _x) isEqualTo "ACE_G_M14"
            || (typeOf _x) isEqualTo "rhs_ammo_an_m14_th3"
        ) exitWith {
            _instigator = (getShotParents _x) select 0;
        };
    }
    forEach _grenades;
};
if (isNull _instigator) exitWith {};

GVAR(cookOffs) pushBack [getPosASL _unit, _instigator];

nil
