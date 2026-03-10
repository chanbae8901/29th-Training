/*
 * File: fn_recordKill.sqf
 * Function: DOTT_tracker_fnc_recordKill
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Server-side function that constructs a kill event array from
 * an EntityKilled event. Determines the killer by checking
 * stored hit data, falling back to engine-provided instigator,
 * and handles special cases like incendiary grenades on vehicles.
 *
 * Parameters:
 * _unit (Object): The killed unit.
 * _killer (Object): Engine-reported killer.
 * _instigator (Object): Engine-reported instigator.
 *
 * Returns:
 * true if saved, false otherwise
 */

#include "eventNumbers.hpp"
params ["_unit", "_killer", "_instigator"];
if (DOTT_tracker_startTime == -1) exitWith { false };

private _timeStamp =
    round(serverTime - DOTT_tracker_startTime);

private _eventType =
    if (_unit isKindOf "Man") then
    {
        INFANTRY_KILL_NUM
    }
    else
    {
        VEHICLE_KILL_NUM
    };

private _unitName =
    [_unit] call DOTT_tracker_fnc_getName;

// Need group side since ACE sets unconscious men to CIV
// but leaves their group side intact.
private _unitSide = side (group _unit);

private _killInfo = [[_unitName, _unitSide]];

// ---------------------------------------------------------------
// Retrieve stored hit data for kill attribution
// ---------------------------------------------------------------
private _lastHit = _unit getVariable "DOTT_lastHit";
if !(isNil "_lastHit") then
{
    _lastHit append
        ((_unit getVariable "DOTT_hitMap")
            get _lastHit);
};

// Player manually respawned without taking known damage.
if (isNil "_lastHit"
    && _killer == _unit
    && isNull _instigator) exitWith { false };

// ---------------------------------------------------------------
// Helper: resolve instigator side, handling dead units whose
// group side has already flipped to civilian.
// ---------------------------------------------------------------
private _fn_resolveInstigatorSide =
{
    params ["_instigator"];
    private _side = side (group _instigator);
    if (_side == sideUnknown || _side == civilian) then
    {
        _side = getNumber (
            configFile >> "CfgVehicles"
            >> typeOf _instigator >> "side"
        ) call BIS_fnc_sideType;
    };
    _side
};

// ---------------------------------------------------------------
// Instigator fallback: try crew of killer vehicle
// ---------------------------------------------------------------
if (isNull _instigator) then
{
    private _crew = crew _killer;
    if (count _crew > 0) then
    {
        _instigator = _crew select 0;
    }
    else
    {
        _instigator = _killer;
    };
};

// ---------------------------------------------------------------
// Special case: incendiary grenades killing vehicles
// ---------------------------------------------------------------
private _override = false;
if (_eventType == VEHICLE_KILL_NUM
    && isNull _instigator) then
{
    private _grenades = (position _unit)
        nearObjects ["GrenadeHand", 10];
    private _weapon = "";

    {
        if ((typeOf _x) == "ACE_G_M14") exitWith
        {
            _weapon = "ACE AN-M14";
            _instigator = (getShotParents _x) select 0;
            _override = true;
        };
        if ((typeOf _x) == "rhs_ammo_an_m14_th3") exitWith
        {
            _weapon = "RHS AN-M14";
            _instigator = (getShotParents _x) select 0;
            _override = true;
        };
    }
    forEach _grenades;

    if !(isNull _instigator) then
    {
        private _distance = round (
            (getPosASL _unit) distance
            (getPosASL _instigator)
        );
        private _side =
            [_instigator]
                call _fn_resolveInstigatorSide;
        _killInfo append [
            [_instigator call
                DOTT_tracker_fnc_getName, _side],
            _distance, _weapon
        ];

        private _instigatorInfo = [
            _instigator call DOTT_tracker_fnc_getName,
            _side, getPosASL _instigator,
            _weapon, _timeStamp
        ];

        [crew _unit, _instigatorInfo]
            call DOTT_tracker_fnc_sendHit;
    };
};

// ---------------------------------------------------------------
// Build kill info from hit data or instigator
// ---------------------------------------------------------------
if !(isNil "_lastHit" && !_override) then
{
    if !(isNull _instigator) then
    {
        private _side =
            [_instigator]
                call _fn_resolveInstigatorSide;
        _lastHit = [
            _instigator call DOTT_tracker_fnc_getName,
            _side
        ];
        private _hitInfo =
            (_unit getVariable "DOTT_hitMap")
                get _lastHit;
        if (isNil "_hitInfo") then
        {
            _hitInfo = [
                getPosASL _instigator, "?", _timeStamp
            ];
        };
        _lastHit append _hitInfo;

        // _lastHit: [name, side, firingPos, weapon, time]
        private _hitTime = _lastHit select 4;
        private _distance = round (
            (getPosASL _unit) distance
            (_lastHit select 2)
        );
        _killInfo append [
            [_lastHit select 0, _lastHit select 1],
            _distance, _lastHit select 3
        ];

        // Promote to delayed kill if hit was long ago.
        if ((_timeStamp - _hitTime > DELAY_TIME)
            && _eventType == INFANTRY_KILL_NUM) then
        {
            _eventType = DELAY_KILL_NUM;
            _timeStamp = [_timeStamp, _hitTime];
        };
    }
    else
    {
        // No instigator -- credit last projectile hit
        // (fall damage, burn, ACE fragmentation, etc.)
        private _hitTime = _lastHit select 4;
        private _distance = round (
            (getPosASL _unit) distance
            (_lastHit select 2)
        );
        _killInfo append [
            [_lastHit select 0, _lastHit select 1],
            _distance, _lastHit select 3
        ];

        if ((_timeStamp - _hitTime > DELAY_TIME)
            && _eventType == INFANTRY_KILL_NUM) then
        {
            _eventType = DELAY_KILL_NUM;
            _timeStamp = [_timeStamp, _hitTime];
        };
    };
};

private _event = [_eventType, _timeStamp, _killInfo];

[_event] call DOTT_tracker_fnc_saveEvent;

true
