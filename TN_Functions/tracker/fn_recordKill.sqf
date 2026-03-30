#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Client-side function that constructs a kill event array from
 * an EntityKilled event. Determines the killer by checking
 * stored hit data, prioritizing any engine-provided instigator,
 * and handles special cases like incendiary grenades on vehicles.
 *
 * Arguments:
 * 0: The killed unit <OBJECT>
 * 1: Engine-reported killer <OBJECT>
 * 2: Engine-reported instigator (may be objNull) <OBJECT>
 *
 * Return Value:
 * true if saved, false otherwise <BOOL>
 */

#include "eventNumbers.hpp"
#define VEHICLE_GRENADE_DISTANCE 10
params ["_unit", "_killer", "_instigator"];
if (GVAR(startTime) isEqualTo -1) exitWith { false };

private _timeStamp =
    round (serverTime - GVAR(startTime));

private _eventType =
    if (_unit isKindOf "Man")
        then { INFANTRY_KILL_NUM }
        else { VEHICLE_KILL_NUM };

private _unitName =
    [_unit] call FUNC(getName);

// Need group since ACE3? sets uncon men to CIV but not
// the group.
private _unitSide = side (group _unit);

private _killInfo = [[_unitName, _unitSide]];

private _lastHit = _unit getVariable QGVAR(lastHit);
if !(isNil "_lastHit") then {
    _lastHit append (
        (_unit getVariable QGVAR(hitMap)) get _lastHit
    );
};

// Player manual respawned without taking known damage.
if (
    isNil "_lastHit"
    && _killer isEqualTo _unit
    && isNull _instigator
) exitWith { false };

// Resolve instigator side, handling dead units whose group
// side has already flipped to civilian.
private _fn_resolveInstigatorSide = {
    params ["_instigator"];
    private _side = side (group _instigator);
    if (_side isEqualTo sideUnknown
        || _side isEqualTo civilian) then { // Dead man.
        // Might work improperly if zeus changed
        // player side.
        _side = getNumber (
            configOf _instigator >> "side"
        ) call BIS_fnc_sideType;
    };
    _side
};

if (isNull _instigator) then { // Backup for unknown cases.
    private _crew = crew _killer;
    if (_crew isNotEqualTo []) then {
        _instigator = _crew select 0;
    } else {
        _instigator = _killer;
    };
};

// Special case for incendiary grenades killing vehicles.
private _override = false;
if (_eventType isEqualTo VEHICLE_KILL_NUM
    && isNull _instigator) then {
    // Look for ACE/RHS incendiary grenade.
    private _grenadeResult = [position _unit, VEHICLE_GRENADE_DISTANCE]
        call FUNC(findIncendiaryGrenade);
    private _weapon = "";

    if (_grenadeResult isNotEqualTo []) then {
        _instigator = _grenadeResult select 0;
        _weapon = _grenadeResult select 1;
        _override = true;
    };

    if !(isNull _instigator) then {
        private _distance = round (
            (getPosASL _unit)
                distance (getPosASL _instigator)
        );
        private _side =
            [_instigator] call _fn_resolveInstigatorSide;
        _killInfo append [
            [
                _instigator
                    call FUNC(getName),
                _side
            ],
            _distance,
            _weapon
        ];

        private _instigatorInfo = [
            _instigator call FUNC(getName),
            _side,
            getPosASL _instigator,
            _weapon,
            _timeStamp
        ];

        [crew _unit, _instigatorInfo]
            call FUNC(sendHit);
    };
};

if (!isNil "_lastHit" && !_override) then {
    if !(isNull _instigator) then {
        private _side =
            [_instigator] call _fn_resolveInstigatorSide;
        _lastHit = [
            _instigator call FUNC(getName),
            _side
        ];
        private _hitInfo =
            (_unit getVariable QGVAR(hitMap))
                get _lastHit;
        if (isNil "_hitInfo") then {
            _hitInfo = [
                getPosASL _instigator, "?", _timeStamp
            ];
        };
        _lastHit append (_hitInfo);
        // [name, side, distance, weapon]
        private _hitTime = _lastHit select 4;
        private _distance = round (
            (getPosASL _unit)
                distance (_lastHit select 2)
        );
        _killInfo append [
            [_lastHit select 0, _lastHit select 1],
            _distance,
            _lastHit select 3
        ];

        // Player respawns after taking damage or
        // bleeds out.
        if (
            (_timeStamp - _hitTime > DELAY_TIME)
            && _eventType isEqualTo INFANTRY_KILL_NUM
        ) then {
            _eventType = DELAY_KILL_NUM;
            _timeStamp = [_timeStamp, _hitTime];
        };
    } else {
        // Died to fall damage, burn, ace fragmentation.
        // Give kill credit to last projectile hit if
        // exists.
        private _hitTime = _lastHit select 4;
        private _distance = round (
            (getPosASL _unit)
                distance (_lastHit select 2)
        );
        _killInfo append [
            [_lastHit select 0, _lastHit select 1],
            _distance,
            _lastHit select 3
        ];

        // Player respawns after taking damage or
        // bleeds out.
        if (
            (_timeStamp - _hitTime > DELAY_TIME)
            && _eventType isEqualTo INFANTRY_KILL_NUM
        ) then {
            _eventType = DELAY_KILL_NUM;
            _timeStamp = [_timeStamp, _hitTime];
        };
    };
};

private _event = [_eventType, _timeStamp, _killInfo];

[_event] call FUNC(saveEvent);

true
