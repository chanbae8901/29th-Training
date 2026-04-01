#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Finds all events relevant to a specific player from the event
 * list. Includes direct involvement (killed, knocked out, etc.)
 * and also tracks the fate of anyone the player incapacitated
 * (regain consciousness or death).
 *
 * Arguments:
 * 0: Reference index of player in stored event arrays, can be -1 to indicate player is not there <NUMBER>
 * 1: TN_tracker_events from server <ARRAY>
 *
 * Return Value:
 * Indexes of relevant events in _events <ARRAY>
 */

#include "..\eventNumbers.hpp"
params ["_playerIndex", "_events"];
if (_playerIndex isEqualTo -1) exitWith { [] };

private _playerEventIndexes = [];
// Keep track of who the player knocked out so that if they
// regain consciousness we add it to player events.
private _knockedUnconscious = [];

private _numEvents = count _events;
for "_i" from 0 to (_numEvents - 1) do {
    (_events select _i) params ["_eventType", "", "_eventInfo"];
    switch (_eventType) do {
        case ACE_CONSCIOUSNESS_NUM: {
            private _unitIndex = _eventInfo select 0;
            private _state = _eventInfo select 1;
            if (_unitIndex isEqualTo _playerIndex) exitWith {
                _playerEventIndexes pushBack _i;
            };

            // Check if unit was knocked out by player
            // before.
            private _knockedIndex = _knockedUnconscious find _unitIndex;
            if (_knockedIndex isNotEqualTo -1) exitWith {
                _playerEventIndexes pushBack _i;
                _knockedUnconscious deleteAt _knockedIndex;
            };

            // Check if player is knocking out unit, add
            // to _knockedUnconscious.
            if (_state && (count _eventInfo) > 2) then {
                private _instigatorIndex = _eventInfo select 2;
                if (_instigatorIndex isNotEqualTo _playerIndex)
                    exitWith {};
                _playerEventIndexes pushBack _i;
                _knockedUnconscious pushBack _unitIndex;
            };
        };

        case DELAY_ACE_CONSCIOUSNESS_NUM: {
            private _unitIndex = _eventInfo select 0;
            if (_unitIndex isEqualTo _playerIndex) exitWith {
                _playerEventIndexes pushBack _i;
            };

            private _instigatorIndex =
                _eventInfo select 2;
            if (_instigatorIndex isNotEqualTo _playerIndex)
                exitWith {};
            _playerEventIndexes pushBack _i;
            _knockedUnconscious pushBack _unitIndex;
        };

        // Infantry and delayed kills share the same
        // relevance logic.
        case INFANTRY_KILL_NUM;
        case DELAY_KILL_NUM: {
            private _unitIndex = _eventInfo select 0;
            if (_unitIndex isEqualTo _playerIndex) exitWith {
                _playerEventIndexes pushBack _i;
            };
            private _knockedIndex = _knockedUnconscious find _unitIndex;
            // Check if unit was knocked out by player
            // before.
            if (_knockedIndex isNotEqualTo -1) exitWith {
                _playerEventIndexes pushBack _i;
                _knockedUnconscious deleteAt _knockedIndex;
            };
            if (count _eventInfo > 1) then {
                private _instigatorIndex = _eventInfo select 1;
                if (_instigatorIndex isEqualTo _playerIndex)
                    exitWith {
                    _playerEventIndexes pushBack _i;
                };
            };
        };

        case VEHICLE_KILL_NUM: {
            if (count _eventInfo > 1) then {
                private _instigatorIndex = _eventInfo select 1;
                if (_instigatorIndex isEqualTo _playerIndex)
                    exitWith {
                    _playerEventIndexes pushBack _i;
                };
            };
        };

        default {};
    };
};

_playerEventIndexes
