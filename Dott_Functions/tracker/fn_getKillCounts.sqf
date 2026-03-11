/**
 * File: fn_getKillCounts.sqf
 * Function: DOTT_tracker_fnc_getKillCounts
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Finds kill count at end of round from events. Units left
 * unconscious at end of round will have their death credited
 * to whoever knocked them unconscious.
 *
 * Parameters:
 * _events (Array): DOTT_tracker_events from server.
 * _sides (Array): DOTT_tracker_sides from server.
 *
 * Returns:
 * Sorted kill count array with elements
 * [[unit number, side of unit], numKills]
 */

#include "eventNumbers.hpp"
params ["_events", "_sides"];
// [[unit number, side of unit],
//  [instigator number, side of instigator]]
private _unconsciousAtEnd = [];
// [[unit number, side of unit], numKills]
private _killCounts = createHashMap;

{
    private _event = _x;
    private _eventType = _event select 0;
    private _eventTime = _event select 1;
    private _eventInfo = _event select 2;

    switch (_eventType) do
    {
        case INFANTRY_KILL_NUM:
        {
            if !(count _eventInfo > 1) exitWith {};

            private _unitIndex = _eventInfo select 0;
            private _unitSide = [
                _unitIndex, _eventTime, _sides
            ] call DOTT_tracker_fnc_getSideAtTime;
            private _instigatorIndex =
                _eventInfo select 1;
            private _instigatorSide = [
                _instigatorIndex, _eventTime, _sides
            ] call DOTT_tracker_fnc_getSideAtTime;

            private _findUnconIdx =
                _unconsciousAtEnd findIf {
                    (_x select 0) isEqualTo
                        [_unitIndex, _unitSide]
                };
            if (_findUnconIdx != -1) then
            {
                _unconsciousAtEnd deleteAt _findUnconIdx;
            };
            if (_unitIndex == _instigatorIndex)
                exitWith {};

            private _key =
                [_instigatorIndex, _instigatorSide];
            private _curKills =
                _killCounts getOrDefaultCall
                    [_key, {0}, true];
            private _addPoints =
                if (_unitSide == _instigatorSide)
                    then {-1} else {1};
            _killCounts set
                [_key, _curKills + _addPoints];
        };

        case DELAY_KILL_NUM:
        {
            if !(count _eventInfo > 1) exitWith {};

            private _unitIndex = _eventInfo select 0;
            private _unitSide = [
                _unitIndex, _eventTime select 0, _sides
            ] call DOTT_tracker_fnc_getSideAtTime;
            private _instigatorIndex =
                _eventInfo select 1;
            private _instigatorSide = [
                _instigatorIndex, _eventTime select 1,
                _sides
            ] call DOTT_tracker_fnc_getSideAtTime;

            private _findUnconIdx =
                _unconsciousAtEnd findIf {
                    (_x select 0) isEqualTo
                        [_unitIndex, _unitSide]
                };
            if (_findUnconIdx != -1) then
            {
                _unconsciousAtEnd deleteAt _findUnconIdx;
            };
            if (_unitIndex == _instigatorIndex)
                exitWith {};

            private _key =
                [_instigatorIndex, _instigatorSide];
            private _curKills =
                _killCounts getOrDefaultCall
                    [_key, {0}, true];
            private _addPoints =
                if (_unitSide == _instigatorSide)
                    then {-1} else {1};
            _killCounts set
                [_key, _curKills + _addPoints];
        };

        case ACE_CONSCIOUSNESS_NUM:
        {
            private _unitIndex = _eventInfo select 0;
            private _unitSide = [
                _unitIndex, _eventTime, _sides
            ] call DOTT_tracker_fnc_getSideAtTime;
            private _state = _eventInfo select 1;
            if (_state && (count _eventInfo) > 2) then
            {
                private _instigatorIndex =
                    _eventInfo select 2;
                private _instigatorSide = [
                    _instigatorIndex, _eventTime, _sides
                ] call DOTT_tracker_fnc_getSideAtTime;
                _unconsciousAtEnd pushBack [
                    [_unitIndex, _unitSide],
                    [_instigatorIndex, _instigatorSide]
                ];
            }
            else
            {
                private _findUnconIdx =
                    _unconsciousAtEnd findIf {
                        (_x select 0) isEqualTo
                            [_unitIndex, _unitSide]
                    };
                if (_findUnconIdx != -1) then
                {
                    _unconsciousAtEnd
                        deleteAt _findUnconIdx;
                };
            };
        };

        case DELAY_ACE_CONSCIOUSNESS_NUM:
        {
            private _unitIndex = _eventInfo select 0;
            private _unitSide = [
                _unitIndex, _eventTime select 0, _sides
            ] call DOTT_tracker_fnc_getSideAtTime;

            private _instigatorIndex =
                _eventInfo select 2;
            private _instigatorSide = [
                _instigatorIndex, _eventTime select 1,
                _sides
            ] call DOTT_tracker_fnc_getSideAtTime;
            _unconsciousAtEnd pushBack [
                [_unitIndex, _unitSide],
                [_instigatorIndex, _instigatorSide]
            ];
        };
    };
}
forEach _events;

{
    private _unit = _x select 0;
    private _unitIndex = _unit select 0;
    private _unitSide = _unit select 1;
    private _instigator = _x select 1;
    private _instigatorIndex = _instigator select 0;
    private _instigatorSide = _instigator select 1;
    if (_unitIndex == _instigatorIndex) exitWith {};

    private _key = [_instigatorIndex, _instigatorSide];
    private _curKills =
        _killCounts getOrDefaultCall [_key, {0}, true];
    private _addPoints =
        if (_unitSide == _instigatorSide)
            then {-1} else {1};
    _killCounts set [_key, _curKills + _addPoints];
}
forEach _unconsciousAtEnd;

_killCounts = _killCounts toArray false;
_killCounts = [
    _killCounts, [], {_x select 1}, "DESCEND"
] call BIS_fnc_sortBy;
_killCounts
