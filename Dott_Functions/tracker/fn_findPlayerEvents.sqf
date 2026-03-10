/*
 * File: fn_findPlayerEvents.sqf
 * Function: DOTT_tracker_fnc_findPlayerEvents
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Finds all events relevant to a specific player from the event
 * list. Includes direct involvement (killed, knocked out, etc.)
 * and also tracks the fate of anyone the player incapacitated
 * (regain consciousness or death).
 *
 * Parameters:
 * _playerIndex (Number): Index in stored event arrays (-1 = absent).
 * _events (Array): DOTT_tracker_events from server.
 *
 * Returns:
 * Array of indices into _events for relevant events.
 */

#include "eventNumbers.hpp"
params ["_playerIndex", "_events"];
if (_playerIndex == -1) exitWith { [] };

private _playerEventIndexes = [];
// Track who the player knocked out so we can include
// their wake-up or death events in the player's log.
private _knockedUnconscious = [];

private _numEvents = count _events;
for "_i" from 0 to (_numEvents - 1) do
{
    private _event = _events select _i;
    private _eventType = _event select 0;
    private _eventInfo = _event select 2;

    switch (_eventType) do
    {
        case ACE_CONSCIOUSNESS_NUM:
        {
            private _unitIndex = _eventInfo select 0;
            private _state = _eventInfo select 1;
            if (_unitIndex == _playerIndex) exitWith
            {
                _playerEventIndexes pushBack _i;
            };

            // Check if this unit was previously knocked
            // out by the player.
            private _knockedIndex =
                _knockedUnconscious find _unitIndex;
            if (_knockedIndex != -1) exitWith
            {
                _playerEventIndexes pushBack _i;
                _knockedUnconscious
                    deleteAt _knockedIndex;
            };

            // Check if the player is the one knocking
            // this unit out.
            if (_state
                && (count _eventInfo) > 2) then
            {
                private _instigatorIndex =
                    _eventInfo select 2;
                if (_instigatorIndex != _playerIndex)
                    exitWith {};
                _playerEventIndexes pushBack _i;
                _knockedUnconscious
                    pushBack _unitIndex;
            };
        };

        case DELAY_ACE_CONSCIOUSNESS_NUM:
        {
            private _unitIndex = _eventInfo select 0;
            if (_unitIndex == _playerIndex) exitWith
            {
                _playerEventIndexes pushBack _i;
            };

            private _instigatorIndex =
                _eventInfo select 2;
            if (_instigatorIndex != _playerIndex)
                exitWith {};
            _playerEventIndexes pushBack _i;
            _knockedUnconscious pushBack _unitIndex;
        };

        // Infantry and delayed kills share the same
        // relevance logic: unit died, or was previously
        // knocked out by player, or player was the
        // instigator.
        case INFANTRY_KILL_NUM;
        case DELAY_KILL_NUM:
        {
            private _unitIndex = _eventInfo select 0;
            if (_unitIndex == _playerIndex) exitWith
            {
                _playerEventIndexes pushBack _i;
            };

            private _knockedIndex =
                _knockedUnconscious find _unitIndex;
            if (_knockedIndex != -1) exitWith
            {
                _playerEventIndexes pushBack _i;
                _knockedUnconscious
                    deleteAt _knockedIndex;
            };

            if (count _eventInfo > 1) then
            {
                private _instigatorIndex =
                    _eventInfo select 1;
                if (_instigatorIndex == _playerIndex)
                    exitWith
                {
                    _playerEventIndexes pushBack _i;
                };
            };
        };

        case VEHICLE_KILL_NUM:
        {
            if (count _eventInfo > 1) then
            {
                private _instigatorIndex =
                    _eventInfo select 1;
                if (_instigatorIndex == _playerIndex)
                    exitWith
                {
                    _playerEventIndexes pushBack _i;
                };
            };
        };

        default {};
    };
};

_playerEventIndexes
