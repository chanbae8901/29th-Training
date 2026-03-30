#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Finds kill count at end of round from events. Units left
 * unconscious at end of round will have their death credited
 * to whoever knocked them unconscious.
 *
 * Arguments:
 * 0: TN_tracker_events from server <ARRAY>
 * 1: TN_tracker_sides from server <ARRAY>
 *
 * Return Value:
 * Sorted kill count array with elements [[unit number, side of unit], numKills] <ARRAY>
 */

#include "..\eventNumbers.hpp"
params ["_events", "_sides"];
// [[unit number, side of unit],
//  [instigator number, side of instigator]]
private _unconsciousAtEnd = [];
// [[unit number, side of unit], numKills]
private _killCounts = createHashMap;

{
    _x params ["_eventType", "_eventTime", "_eventInfo"];

    switch (_eventType) do {
        case INFANTRY_KILL_NUM: {
            if (count _eventInfo <= 1) exitWith {};

            private _unitIndex = _eventInfo select 0;
            private _unitSide = [
                _unitIndex, _eventTime, _sides
            ] call FUNC(getSideAtTime);
            private _instigatorIndex =
                _eventInfo select 1;
            private _instigatorSide = [
                _instigatorIndex, _eventTime, _sides
            ] call FUNC(getSideAtTime);

            private _findUnconIdx =
                _unconsciousAtEnd findIf {
                    (_x select 0) isEqualTo
                        [_unitIndex, _unitSide]
                };
            if (_findUnconIdx isNotEqualTo -1) then {
                _unconsciousAtEnd deleteAt _findUnconIdx;
            };
            if (_unitIndex isEqualTo _instigatorIndex)
                exitWith {};

            private _key =
                [_instigatorIndex, _instigatorSide];
            private _curKills =
                _killCounts getOrDefaultCall
                    [_key, {0}, true];
            private _addPoints =
                [1, -1] select (_unitSide isEqualTo _instigatorSide);
            _killCounts set
                [_key, _curKills + _addPoints];
        };

        case DELAY_KILL_NUM: {
            if (count _eventInfo <= 1) exitWith {};

            private _unitIndex = _eventInfo select 0;
            private _unitSide = [
                _unitIndex, _eventTime select 0, _sides
            ] call FUNC(getSideAtTime);
            private _instigatorIndex =
                _eventInfo select 1;
            private _instigatorSide = [
                _instigatorIndex, _eventTime select 1,
                _sides
            ] call FUNC(getSideAtTime);

            private _findUnconIdx =
                _unconsciousAtEnd findIf {
                    (_x select 0) isEqualTo
                        [_unitIndex, _unitSide]
                };
            if (_findUnconIdx isNotEqualTo -1) then {
                _unconsciousAtEnd deleteAt _findUnconIdx;
            };
            if (_unitIndex isEqualTo _instigatorIndex)
                exitWith {};

            private _key =
                [_instigatorIndex, _instigatorSide];
            private _curKills =
                _killCounts getOrDefaultCall
                    [_key, {0}, true];
            private _addPoints =
                [1, -1] select (_unitSide isEqualTo _instigatorSide);
            _killCounts set
                [_key, _curKills + _addPoints];
        };

        case ACE_CONSCIOUSNESS_NUM: {
            private _unitIndex = _eventInfo select 0;
            private _unitSide = [
                _unitIndex, _eventTime, _sides
            ] call FUNC(getSideAtTime);
            private _state = _eventInfo select 1;
            if (_state && (count _eventInfo) > 2) then {
                private _instigatorIndex =
                    _eventInfo select 2;
                private _instigatorSide = [
                    _instigatorIndex, _eventTime, _sides
                ] call FUNC(getSideAtTime);
                _unconsciousAtEnd pushBack [
                    [_unitIndex, _unitSide],
                    [_instigatorIndex, _instigatorSide]
                ];
            } else {
                private _findUnconIdx =
                    _unconsciousAtEnd findIf {
                        (_x select 0) isEqualTo
                            [_unitIndex, _unitSide]
                    };
                if (_findUnconIdx isNotEqualTo -1) then {
                    _unconsciousAtEnd
                        deleteAt _findUnconIdx;
                };
            };
        };

        case DELAY_ACE_CONSCIOUSNESS_NUM: {
            private _unitIndex = _eventInfo select 0;
            private _unitSide = [
                _unitIndex, _eventTime select 0, _sides
            ] call FUNC(getSideAtTime);

            private _instigatorIndex =
                _eventInfo select 2;
            private _instigatorSide = [
                _instigatorIndex, _eventTime select 1,
                _sides
            ] call FUNC(getSideAtTime);
            _unconsciousAtEnd pushBack [
                [_unitIndex, _unitSide],
                [_instigatorIndex, _instigatorSide]
            ];
        };
        default {};
    };
}
forEach _events;

{
    _x params ["_unit", "_instigator"];
    _unit params ["_unitIndex", "_unitSide"];
    _instigator params ["_instigatorIndex", "_instigatorSide"];
    if (_unitIndex isEqualTo _instigatorIndex) exitWith {};

    private _key = [_instigatorIndex, _instigatorSide];
    private _curKills =
        _killCounts getOrDefaultCall [_key, {0}, true];
    private _addPoints =
        [1, -1] select (_unitSide isEqualTo _instigatorSide);
    _killCounts set [_key, _curKills + _addPoints];
}
forEach _unconsciousAtEnd;

_killCounts = _killCounts toArray false;
_killCounts = [
    _killCounts, [], {_x select 1}, "DESCEND"
] call BIS_fnc_sortBy;
_killCounts
