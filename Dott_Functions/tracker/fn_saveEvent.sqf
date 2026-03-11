/**
 * File: fn_saveEvent.sqf
 * Function: DOTT_tracker_fnc_saveEvent
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Server-side function that converts an event array and stores
 * it in DOTT_tracker_events. The stored array replaces info with
 * index numbers that can be dereferenced in DOTT_tracker_names
 * and DOTT_tracker_sides. Hopefully reduces total storage for
 * network transmission.
 *
 * Parameters:
 * _event (Array): Array of event created by other tracker
 *     functions.
 *
 * Returns:
 * true if event saved, false otherwise
 */

#include "eventNumbers.hpp"
params ["_event"];
private _eventType = _event select 0;
private _eventTime = _event select 1;
private _eventInfo = _event select 2;

private _saveEvent = true;

switch (_eventType) do
{
    case ACE_CONSCIOUSNESS_NUM:
    {
        private _unit = _eventInfo select 0;
        private _unitName = _unit select 0;
        private _unitSide = _unit select 1;
        _eventInfo set [
            0,
            [_unitName, _unitSide, _eventTime]
                call DOTT_tracker_fnc_nameToNum
        ];
        if (count _eventInfo > 2) then
        {
            private _instigator = _eventInfo select 2;
            private _instigatorName = _instigator select 0;
            private _instigatorSide = _instigator select 1;
            private _weaponName = _eventInfo select 4;
            _eventInfo set [
                2,
                [_instigatorName, _instigatorSide, _eventTime]
                    call DOTT_tracker_fnc_nameToNum
            ];
            _eventInfo set [
                4,
                [_weaponName]
                    call DOTT_tracker_fnc_weaponToNum
            ];
        };
        // Remove unconscious if happened after death
        // (bad network rare case).
        private _afterTime = _eventTime - 2;
        private _unitNum = _eventInfo select 0;
        for "_i" from (count DOTT_tracker_events - 1)
            to 0 step -1 do
        {
            private _pastEvent =
                DOTT_tracker_events select _i;
            private _pastType = _pastEvent select 0;
            if !(
                _pastType == INFANTRY_KILL_NUM
                || _pastType == DELAY_KILL_NUM
            ) then { continue };
            private _pastTime = _pastEvent select 1;
            if (_pastType == DELAY_KILL_NUM) then
            {
                _pastTime = _pastTime select 0;
            };
            if (_pastTime < _afterTime) exitWith {};
            private _pastUnitNum =
                (_pastEvent select 2) select 0;
            if (_unitNum == _pastUnitNum) exitWith
            {
                _saveEvent = false;
            };
        };
    };

    case DELAY_ACE_CONSCIOUSNESS_NUM:
    {
        private _unit = _eventInfo select 0;
        private _unitName = _unit select 0;
        private _unitSide = _unit select 1;
        _eventInfo set [
            0,
            [_unitName, _unitSide, _eventTime select 0]
                call DOTT_tracker_fnc_nameToNum
        ];
        if (count _eventInfo > 2) then
        {
            private _instigator = _eventInfo select 2;
            private _instigatorName = _instigator select 0;
            private _instigatorSide = _instigator select 1;
            private _weaponName = _eventInfo select 4;
            _eventInfo set [
                2,
                [
                    _instigatorName,
                    _instigatorSide,
                    _eventTime select 1
                ] call DOTT_tracker_fnc_nameToNum
            ];
            _eventInfo set [
                4,
                [_weaponName]
                    call DOTT_tracker_fnc_weaponToNum
            ];
        };
        // Remove unconscious if happened after death
        // (bad network rare case).
        private _afterTime = (_eventTime select 0) - 2;
        private _unitNum = _eventInfo select 0;
        for "_i" from (count DOTT_tracker_events - 1)
            to 0 step -1 do
        {
            private _pastEvent =
                DOTT_tracker_events select _i;
            private _pastType = _pastEvent select 0;
            if !(
                _pastType == INFANTRY_KILL_NUM
                || _pastType == DELAY_KILL_NUM
            ) then { continue };
            private _pastTime = _pastEvent select 1;
            if (_pastType == DELAY_KILL_NUM) then
            {
                _pastTime = _pastTime select 0;
            };
            if (_pastTime < _afterTime) exitWith {};
            private _pastUnitNum =
                (_pastEvent select 2) select 0;
            if (_unitNum == _pastUnitNum) exitWith
            {
                _saveEvent = false;
            };
        };
    };

    case INFANTRY_KILL_NUM:
    {
        private _unit = _eventInfo select 0;
        private _unitName = _unit select 0;
        private _unitSide = _unit select 1;
        _eventInfo set [
            0,
            [_unitName, _unitSide, _eventTime]
                call DOTT_tracker_fnc_nameToNum
        ];
        if (count _eventInfo > 1) then
        {
            private _instigator = _eventInfo select 1;
            private _instigatorName = _instigator select 0;
            private _instigatorSide = _instigator select 1;
            private _weaponName = _eventInfo select 3;
            _eventInfo set [
                1,
                [_instigatorName, _instigatorSide, _eventTime]
                    call DOTT_tracker_fnc_nameToNum
            ];
            _eventInfo set [
                3,
                [_weaponName]
                    call DOTT_tracker_fnc_weaponToNum
            ];
        };
        // Remove unconscious close to death.
        private _afterTime = _eventTime - 2;
        private _unitNum = _eventInfo select 0;
        for "_i" from (count DOTT_tracker_events - 1)
            to 0 step -1 do
        {
            private _pastEvent =
                DOTT_tracker_events select _i;
            private _pastType = _pastEvent select 0;
            if !(
                _pastType == ACE_CONSCIOUSNESS_NUM
                || _pastType == DELAY_ACE_CONSCIOUSNESS_NUM
            ) then { continue };
            private _pastTime = _pastEvent select 1;
            if (_pastType == DELAY_ACE_CONSCIOUSNESS_NUM)
                then
            {
                _pastTime = _pastTime select 0;
            };
            if (_pastTime < _afterTime) exitWith {};
            private _pastUnitNum =
                (_pastEvent select 2) select 0;
            if (_unitNum == _pastUnitNum) exitWith
            {
                DOTT_tracker_events deleteAt _i;
            };
        };
    };
    case DELAY_KILL_NUM:
    {
        private _unit = _eventInfo select 0;
        private _unitName = _unit select 0;
        private _unitSide = _unit select 1;
        _eventInfo set [
            0,
            [_unitName, _unitSide, _eventTime select 0]
                call DOTT_tracker_fnc_nameToNum
        ];
        if (count _eventInfo > 1) then
        {
            private _instigator = _eventInfo select 1;
            private _instigatorName = _instigator select 0;
            private _instigatorSide = _instigator select 1;
            private _weaponName = _eventInfo select 3;
            _eventInfo set [
                1,
                [
                    _instigatorName,
                    _instigatorSide,
                    _eventTime select 1
                ] call DOTT_tracker_fnc_nameToNum
            ];
            _eventInfo set [
                3,
                [_weaponName]
                    call DOTT_tracker_fnc_weaponToNum
            ];
        };
        // Remove unconscious close to death.
        private _afterTime = (_eventTime select 0) - 2;
        private _unitNum = _eventInfo select 0;
        for "_i" from (count DOTT_tracker_events - 1)
            to 0 step -1 do
        {
            private _pastEvent =
                DOTT_tracker_events select _i;
            private _pastType = _pastEvent select 0;
            if !(
                _pastType == ACE_CONSCIOUSNESS_NUM
                || _pastType == DELAY_ACE_CONSCIOUSNESS_NUM
            ) then { continue };
            private _pastTime = _pastEvent select 1;
            if (_pastType == DELAY_ACE_CONSCIOUSNESS_NUM)
                then
            {
                _pastTime = _pastTime select 0;
            };
            if (_pastTime < _afterTime) exitWith {};
            private _pastUnitNum =
                (_pastEvent select 2) select 0;
            if (_unitNum == _pastUnitNum) exitWith
            {
                DOTT_tracker_events deleteAt _i;
            };
        };
    };

    case VEHICLE_KILL_NUM:
    {
        private _unit = _eventInfo select 0;
        private _unitName = _unit select 0;
        private _unitSide = _unit select 1;
        _eventInfo set [
            0,
            [_unitName, _unitSide, _eventTime]
                call DOTT_tracker_fnc_nameToNum
        ];
        if (count _eventInfo > 1) then
        {
            private _instigator = _eventInfo select 1;
            private _instigatorName = _instigator select 0;
            private _instigatorSide = _instigator select 1;
            private _weaponName = _eventInfo select 3;
            _eventInfo set [
                1,
                [_instigatorName, _instigatorSide, _eventTime]
                    call DOTT_tracker_fnc_nameToNum
            ];
            _eventInfo set [
                3,
                [_weaponName]
                    call DOTT_tracker_fnc_weaponToNum
            ];
        };
    };
};

if (!_saveEvent) exitWith { false };

DOTT_tracker_events pushBack _event;

true
