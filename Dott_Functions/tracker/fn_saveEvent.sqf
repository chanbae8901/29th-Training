/**
 * Function: TN_tracker_fnc_saveEvent
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Server-side function that converts an event array's human-
 * readable names/sides/weapons into compact numeric indices
 * (referencing TN_tracker_names, _sides, _weapons) and stores
 * the result in TN_tracker_events.
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

// Shared across all event type cases to avoid repeating the same
// conversion logic five times.
private _fn_convertEventInfo =
{
    params ["_eventInfo", "_unitTime", "_instigatorTime", "_isKillType"];

    private _unit = _eventInfo select 0;
    private _unitName = _unit select 0;
    private _unitSide = _unit select 1;
    _eventInfo set [0, [_unitName, _unitSide, _unitTime] call TN_tracker_fnc_nameToNum];

    // Kill types: instigator at 1, weapon at 3.
    // Consciousness types: instigator at 2, weapon at 4.
    private _instigatorIdx = [2, 1] select _isKillType;
    private _weaponIdx = _instigatorIdx + 2;

    if (count _eventInfo > _instigatorIdx) then
    {
        private _instigator = _eventInfo select _instigatorIdx;
        private _instigatorName = _instigator select 0;
        private _instigatorSide = _instigator select 1;
        private _weaponName = _eventInfo select _weaponIdx;
        _eventInfo set [_instigatorIdx,
            [_instigatorName, _instigatorSide, _instigatorTime] call TN_tracker_fnc_nameToNum
        ];
        _eventInfo set [_weaponIdx, [_weaponName] call TN_tracker_fnc_weaponToNum];
    };
};

// Scan recent events for a conflicting event near this one in time.
// Used to suppress unconscious events that arrive after a death
// (network race), or to remove stale unconscious records when a
// death comes in.
private _fn_scanRecentEvents =
{
    params ["_filterTypes", "_afterTime", "_unitNum", "_action"];
    for "_i" from (count TN_tracker_events - 1)
        to 0 step -1 do
    {
        private _pastEvent = TN_tracker_events select _i;
        private _pastType = _pastEvent select 0;
        private _pastTime = _pastEvent select 1;
        if (_pastType == DELAY_KILL_NUM
            || _pastType == DELAY_ACE_CONSCIOUSNESS_NUM) then
        {
            _pastTime = _pastTime select 0;
        };
        // Events are chronological — once we're past the
        // time window, nothing older can match.
        if (_pastTime < _afterTime) exitWith {};
        if !(_pastType in _filterTypes) then { continue };
        private _pastUnitNum = (_pastEvent select 2) select 0;
        if (_unitNum == _pastUnitNum) exitWith
        {
            _i call _action;
        };
    };
};

switch (_eventType) do
{
    case ACE_CONSCIOUSNESS_NUM:
    {
        [_eventInfo, _eventTime, _eventTime, false] call _fn_convertEventInfo;

        // Suppress if unit already died within 2 seconds.
        [
            [INFANTRY_KILL_NUM, DELAY_KILL_NUM],
            _eventTime - 2,
            _eventInfo select 0,
            { _saveEvent = false }
        ] call _fn_scanRecentEvents;
    };

    case DELAY_ACE_CONSCIOUSNESS_NUM:
    {
        [_eventInfo, _eventTime select 0, _eventTime select 1, false] call _fn_convertEventInfo;

        [
            [INFANTRY_KILL_NUM, DELAY_KILL_NUM],
            (_eventTime select 0) - 2,
            _eventInfo select 0,
            { _saveEvent = false }
        ] call _fn_scanRecentEvents;
    };

    case INFANTRY_KILL_NUM:
    {
        [_eventInfo, _eventTime, _eventTime, true] call _fn_convertEventInfo;

        // Remove unconscious events close to this death.
        [
            [ACE_CONSCIOUSNESS_NUM, DELAY_ACE_CONSCIOUSNESS_NUM],
            _eventTime - 2,
            _eventInfo select 0,
            { TN_tracker_events deleteAt _this }
        ] call _fn_scanRecentEvents;
    };

    case DELAY_KILL_NUM:
    {
        [_eventInfo, _eventTime select 0, _eventTime select 1, true] call _fn_convertEventInfo;

        [
            [ACE_CONSCIOUSNESS_NUM, DELAY_ACE_CONSCIOUSNESS_NUM],
            (_eventTime select 0) - 2,
            _eventInfo select 0,
            { TN_tracker_events deleteAt _this }
        ] call _fn_scanRecentEvents;
    };

    case VEHICLE_KILL_NUM:
    {
        [_eventInfo, _eventTime, _eventTime, true] call _fn_convertEventInfo;
    };

    default {};
};

if (!_saveEvent) exitWith { false };

TN_tracker_events pushBack _event;

true
