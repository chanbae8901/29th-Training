#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Adds client-side event handlers for the tracker system.
 * Attaches instigator/weapon info to projectiles on fire,
 * propagates that info through submunitions, and handles
 * non-projectile damage sources (roadkill, fire, explosions).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 */

player addEventHandler ["FiredMan", FUNC(onFiredMan)];

["ace_advanced_throwing_throwFiredXEH", {
    if (!local (_this select 0)) exitWith {};
    call FUNC(onFiredMan);
}] call CBA_fnc_addEventHandler;

["ace_explosives_place",
    FUNC(onExplosivesPlace)] call CBA_fnc_addEventHandler;

GVAR(lastFireCheck) = 0;

// Easiest way to detect roadkill event.
// Will arrive on server later than projectile hit events
// however.
["ace_medical_woundReceived",
    FUNC(onWoundReceived)] call CBA_fnc_addEventHandler;

["ace_fire_burnSimulation",
// We broadcast these variables since burning bodies can
// set people on fire and we need to track that too.
    FUNC(onBurnSimulation)] call CBA_fnc_addEventHandler;

addMissionEventHandler ["EntityKilled", FUNC(onVehicleKilled)];

player addEventHandler ["Respawn", {
    params ["_unit"];
    _unit setVariable [QGVAR(burnInstigator), nil];
    _unit setVariable [QGVAR(burnInstigatorTime), nil];
    _unit setVariable [QGVAR(burnWeapon), nil];
}];

nil
