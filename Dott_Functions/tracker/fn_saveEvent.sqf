/*
 * File: fn_saveEvent.sqf
 * Function: DOTT_tracker_fnc_saveEvent
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Server-side function that converts an event array's human-
 * readable names/sides/weapons into compact numeric indices
 * (referencing DOTT_tracker_names, _sides, _weapons) and stores
 * the result in DOTT_tracker_events.
 *
 * Parameters:
 * _event (Array): Event array created by other tracker functions.
 *
 * Returns:
 * true if event was saved, false otherwise
 */

#include "eventNumbers.hpp"
params ["_event"];
private _eventType = _event select 0;
private _eventTime = _event select 1;
private _eventInfo = _event select 2;

private _saveEvent = true;

// ---------------------------------------------------------------
// Helper: convert unit/instigator names and weapon strings to
// numeric indices. Shared across all event type cases to avoid
// repeating the same conversion logic five times.
//
// _unitTime: time value for nameToNum on the unit
// _instigatorTime: time value for nameToNum on the instigator
// _instigatorIdx: index of instigator array in _eventInfo
// _weaponIdx: index of weapon string in _eventInfo
// _instigatorCountThreshold: minimum _eventInfo count to process
//                            instigator (differs between event
//                            types: kills use 1, uncon uses 2)
// ---------------------------------------------------------------
private _fn_convertEventInfo =
{
    params [
        "_eventInfo", "_unitTime", "_instigatorTime",
        "_instigatorIdx", "_weaponIdx",
        "_instigatorCountThreshold"
    ];

    // Convert unit name+side to numeric index.
    private _unit = _eventInfo select 0;
    private _unitName = _unit select 0;
    private _unitSide = _unit select 1;
    _eventInfo set [0,
        [_unitName, _unitSide, _unitTime]
            call DOTT_tracker_fnc_nameToNum
    ];

    // Convert instigator name+side and weapon if present.
    if (count _eventInfo > _instigatorCountThreshold) then
    {
        private _instigator =
            _eventInfo select _instigatorIdx;
        private _instigatorName = _instigator select 0;
        private _instigatorSide = _instigator select 1;
        private _weaponName = _eventInfo select _weaponIdx;
        _eventInfo set [_instigatorIdx,
            [_instigatorName, _instigatorSide,
             _instigatorTime]
                call DOTT_tracker_fnc_nameToNum
        ];
        _eventInfo set [_weaponIdx,
            [_weaponName]
                call DOTT_tracker_fnc_weaponToNum
        ];
    };
};

// ---------------------------------------------------------------
// Helper: scan recent events for a conflicting event near this
// one in time. Used to suppress unconscious events that arrive
// after a death (network race), or to remove stale unconscious
// records when a death comes in.
//
// _filterTypes: event types to look for
// _afterTime: only consider events at or after this time
// _unitNum: converted unit index to match against
// _action: code block to run when a match is found
// ---------------------------------------------------------------
private _fn_scanRecentEvents =
{
    params [
        "_filterTypes", "_afterTime",
        "_unitNum", "_action"
    ];
    for "_i" from (count DOTT_tracker_events - 1)
        to 0 step -1 do
    {
        private _pastEvent =
            DOTT_tracker_events select _i;
        private _pastType = _pastEvent select 0;
        if !(_pastType in _filterTypes) then
        {
            continue;
        };
        private _pastTime = _pastEvent select 1;
        if (_pastType == DELAY_KILL_NUM
            || _pastType == DELAY_ACE_CONSCIOUSNESS_NUM)
            then
        {
            _pastTime = _pastTime select 0;
        };
        if (_pastTime < _afterTime) exitWith {};
        private _pastUnitNum =
            (_pastEvent select 2) select 0;
        if (_unitNum == _pastUnitNum) exitWith
        {
            _i call _action;
        };
    };
};

// ---------------------------------------------------------------
// Main switch: convert + validate per event type
// ---------------------------------------------------------------
switch (_eventType) do
{
    // -- Unconscious (immediate) --
    case ACE_CONSCIOUSNESS_NUM:
    {
        [
            _eventInfo, _eventTime, _eventTime,
            2, 4, 2
        ] call _fn_convertEventInfo;

        // Suppress if unit already died within 2 seconds.
        [
            [INFANTRY_KILL_NUM, DELAY_KILL_NUM],
            _eventTime - 2,
            _eventInfo select 0,
            { _saveEvent = false }
        ] call _fn_scanRecentEvents;
    };

    // -- Unconscious (delayed hit) --
    case DELAY_ACE_CONSCIOUSNESS_NUM:
    {
        [
            _eventInfo,
            _eventTime select 0,
            _eventTime select 1,
            2, 4, 2
        ] call _fn_convertEventInfo;

        [
            [INFANTRY_KILL_NUM, DELAY_KILL_NUM],
            (_eventTime select 0) - 2,
            _eventInfo select 0,
            { _saveEvent = false }
        ] call _fn_scanRecentEvents;
    };

    // -- Infantry kill (immediate) --
    case INFANTRY_KILL_NUM:
    {
        [
            _eventInfo, _eventTime, _eventTime,
            1, 3, 1
        ] call _fn_convertEventInfo;

        // Remove unconscious events close to this death
        // since they're redundant noise in the log.
        [
            [ACE_CONSCIOUSNESS_NUM,
             DELAY_ACE_CONSCIOUSNESS_NUM],
            _eventTime - 2,
            _eventInfo select 0,
            { DOTT_tracker_events deleteAt _this }
        ] call _fn_scanRecentEvents;
    };

    // -- Infantry kill (delayed hit) --
    case DELAY_KILL_NUM:
    {
        [
            _eventInfo,
            _eventTime select 0,
            _eventTime select 1,
            1, 3, 1
        ] call _fn_convertEventInfo;

        [
            [ACE_CONSCIOUSNESS_NUM,
             DELAY_ACE_CONSCIOUSNESS_NUM],
            (_eventTime select 0) - 2,
            _eventInfo select 0,
            { DOTT_tracker_events deleteAt _this }
        ] call _fn_scanRecentEvents;
    };

    // -- Vehicle kill --
    case VEHICLE_KILL_NUM:
    {
        [
            _eventInfo, _eventTime, _eventTime,
            1, 3, 1
        ] call _fn_convertEventInfo;
    };

    default {};
};

if (!_saveEvent) exitWith { false };

DOTT_tracker_events pushBack _event;

true
