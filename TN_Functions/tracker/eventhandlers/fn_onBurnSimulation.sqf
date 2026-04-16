#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Handles the ace_fire_burnSimulation event.
 * Broadcasts burn instigator variables since burning bodies
 * can set people on fire and we need to track that too.
 *
 * Arguments:
 * ace_fire_burnSimulation EH params
 *
 * Return Value:
 * Nothing
 */

#define COOKOFF_DISTANCE 10
#define INFANTRY_GRENADE_DISTANCE 5

params ["_unit", "_instigator"];
if (!alive _unit) exitWith {};

if (!isNull _instigator) then {
    _unit setVariable [QGVAR(burnInstigator), _instigator, true];
    _unit setVariable [QGVAR(burnInstigatorTime), time];
    _unit setVariable [QGVAR(burnWeapon), "Fire", true];
} else {
    // Skip expensive spatial searches if we recently
    // cached who set this unit on fire.
    if (
        !isNull (_unit getVariable
            [QGVAR(burnInstigator), objNull])
        && {
            time - (_unit getVariable
                [QGVAR(burnInstigatorTime), -999])
            < 5
        }
    ) exitWith {};
    // Look for nearby ACE incendiary grenade (RHS one
    // doesn't set people on fire).
    private _grenades = (position _unit)
        nearObjects [
            "ACE_G_M14", INFANTRY_GRENADE_DISTANCE
        ];
    if (_grenades isNotEqualTo []) then {
        private _grenade = _grenades select 0;
        _unit setVariable [
            QGVAR(burnInstigator),
            (getShotParents _grenade) select 0,
            true
        ];
        _unit setVariable [QGVAR(burnInstigatorTime), time];
        _unit setVariable [QGVAR(burnWeapon), "ACE AN-M14", true];
    } else {
        // Look through cookoffs.
        {
            if (
                (_x select 0)
                    distance (getPosASL _unit)
                < COOKOFF_DISTANCE
            ) exitWith {
                _unit setVariable [
                    QGVAR(burnInstigator),
                    _x select 1, true
                ];
                _unit setVariable [
                    QGVAR(burnInstigatorTime), time
                ];
                _unit setVariable [
                    QGVAR(burnWeapon),
                    "Cookoff Fire", true
                ];
            };
        }
        forEach GVAR(cookOffs);

        // Look for nearby burning people.
        if (isNull _instigator) then {
            private _men = (position _unit) nearObjects ["CAManBase", 5];
            {
                private _burnInstigator = _x getVariable [QGVAR(burnInstigator), objNull];
                if (!isNull _burnInstigator) exitWith {
                    private _burnWeapon = _x getVariable [QGVAR(burnWeapon), "Fire"];
                    _unit setVariable [QGVAR(burnInstigator), _burnInstigator, true];
                    _unit setVariable [QGVAR(burnInstigatorTime), time];
                    _unit setVariable [QGVAR(burnWeapon), _burnWeapon, true];
                };
            }
            forEach _men;
        };
    };
};

nil
