#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Handles the ace_medical_woundReceived event for tracking
 * non-projectile damage sources (roadkill, fire, explosions).
 *
 * Arguments:
 * ace_medical_woundReceived EH params
 *
 * Return Value:
 * Nothing
 */

#define EXPLOSION_DISTANCE 20
#define COOKOFF_DISTANCE 10
#define INFANTRY_GRENADE_DISTANCE 5

params ["_unit", "", "_instigator", "_ammo"];

if (_ammo isEqualTo "collision") then {
    private _driver = driver _instigator;
    private _sideInstigator =
        _driver call FUNC(findSide);
    if (
        isNull _driver
        || { _driver isEqualTo _instigator }
        || { _driver distance _unit > 5 }
    ) exitWith {};
    // Seems no need to use vehicle/objectParent.
    private _weapon =
        ([_instigator]
            call FUNC(getName))
        + " - Roadkill";
    private _instigatorInfo = [
        _driver call FUNC(getName),
        _sideInstigator,
        getPosASL _driver,
        _weapon,
        round (serverTime - GVAR(startTime))
    ];

    [[_unit], _instigatorInfo] remoteExecCall [QFUNC(sendHit), 2];
};

if (_ammo isEqualTo "burn") then {
    // NOTE: Instigator in this case if null means
    // the damage came from fire on person. Otherwise
    // the instigator is the unit itself, which means
    // that it came from a burning damage source
    // directly.

    // Only care here because in FuelExplosion the
    // woundReceived might happen after death
    // (overkill damage override maybe) + lots of
    // events for burn on dead body.
    if (!alive _unit) exitWith {};

    private _weapon = "?";
    // Usually means damage from fire on person.
    if (isNull _instigator) then {
        _instigator = _unit getVariable
            [QGVAR(burnInstigator), objNull];
        _weapon = _unit getVariable
            [QGVAR(burnWeapon), "Fire"];
    } else {
        // Look for ACE/RHS incendiary grenade.
        private _grenadeResult = [position _unit,
            INFANTRY_GRENADE_DISTANCE]
            call FUNC(findIncendiaryGrenade);
        if (_grenadeResult isNotEqualTo []) then {
            _instigator = _grenadeResult select 0;
            _weapon = _grenadeResult select 1;
        };

        if (_weapon isNotEqualTo "?") exitWith {};

        // Look through cookoffs.
        {
            if (
                (_x select 0)
                    distance (getPosASL _unit)
                < COOKOFF_DISTANCE
            ) exitWith {
                _instigator = _x select 1;
                _weapon = "Cookoff Fire";
            };
        }
        forEach GVAR(cookOffs);

    };
    private _sideInstigator =
        _instigator call FUNC(findSide);
    private _instigatorInfo = [
        _instigator call FUNC(getName),
        _sideInstigator,
        getPosASL _instigator,
        _weapon,
        round (serverTime - GVAR(startTime))
    ];

    [[_unit], _instigatorInfo] remoteExecCall [QFUNC(sendHit), 2];
};

// Burn has a delay of 1 second so if someone dies
// before that it won't register (mostly from close
// RHS Incendiary).
// Fire triggers very frequently and is harder to work
// with so we just want as a minimum backup for the
// above case.
// Instigator is always null.
if (_ammo isEqualTo "fire") then {
    if (!alive _unit) exitWith {};
    // Throttle to avoid spam.
    if (time - GVAR(lastFireCheck) < 2) exitWith {};

    private _weapon = "?";
    // Look for ACE/RHS incendiary grenade.
    private _grenadeResult = [position _unit,
        INFANTRY_GRENADE_DISTANCE]
        call FUNC(findIncendiaryGrenade);
    if (_grenadeResult isNotEqualTo []) then {
        _instigator = _grenadeResult select 0;
        _weapon = _grenadeResult select 1;
    };

    if (_weapon isEqualTo "?") then {
        // Look through cookoffs.
        {
            if (
                (_x select 0)
                    distance (getPosASL _unit)
                < COOKOFF_DISTANCE
            ) exitWith {
                _instigator = _x select 1;
                _weapon = "Cookoff Fire";
            };
        }
        forEach GVAR(cookOffs);
    };

    GVAR(lastFireCheck) = time;

    if (_weapon isEqualTo "?") exitWith {};

    private _sideInstigator =
        _instigator call FUNC(findSide);
    private _instigatorInfo = [
        _instigator call FUNC(getName),
        _sideInstigator,
        getPosASL _instigator,
        _weapon,
        round (serverTime - GVAR(startTime))
    ];

    [[_unit], _instigatorInfo] remoteExecCall [QFUNC(sendHit), 2];
};

// Vehicle explosion.
if (_ammo isEqualTo "FuelExplosion"
    || _ammo isEqualTo "FuelExplosionBig") then {
    if (isNull _instigator) then {
        {
            if (
                (_x select 0)
                    distance (getPosASL _unit)
                < EXPLOSION_DISTANCE
            ) exitWith {
                _instigator = _x select 1;
            };
        }
        forEach GVAR(cookOffs);
    };
    if (isNull _instigator) exitWith {};
    private _weapon = "Vehicle Explosion";
    private _sideInstigator =
        _instigator call FUNC(findSide);
    private _instigatorInfo = [
        _instigator call FUNC(getName),
        _sideInstigator,
        getPosASL _instigator,
        _weapon,
        round (serverTime - GVAR(startTime))
    ];

    [[_unit], _instigatorInfo] remoteExecCall [QFUNC(sendHit), 2];
};

nil
