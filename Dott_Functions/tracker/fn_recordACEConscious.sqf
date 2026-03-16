/**
 * Function: TN_tracker_fnc_recordACEConscious
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Server-side function that constructs an ace_unconscious event
 * array for the tracker. Records when a player goes unconscious
 * or regains consciousness, attributing the cause via stored
 * hit data when available.
 *
 * Parameters:
 * _unit (Object): The unit changing consciousness state.
 * _state (Bool): true = went unconscious, false = woke up.
 *
 * Returns:
 * true if saved, false otherwise
 */

#include "eventNumbers.hpp"
params ["_unit", "_state"];
if (TN_tracker_startTime == -1) exitWith { false };
if (!isPlayer _unit) exitWith { false };

private _timeStamp =
    round(serverTime - TN_tracker_startTime);

// Need group since ACE3? sets unconscious men to CIV but
// not the group.
private _eventInfo = [
    [name _unit, side (group _unit)], _state
];
private _eventType = ACE_CONSCIOUSNESS_NUM;

if (_state) then
{
    private _lastHit =
        _unit getVariable "TN_lastHit";

    if !(isNil "_lastHit") then
    {
        _lastHit append
            ((_unit getVariable "TN_hitMap")
                get _lastHit);

        // [name, side, distance, weapon, time]
        private _hitTime = _lastHit select 4;
        _eventInfo append [
            [_lastHit select 0, _lastHit select 1],
            round (
                (getPosASL _unit) distance
                (_lastHit select 2)
            ),
            _lastHit select 3
        ];

        if (_timeStamp - _hitTime > DELAY_TIME) then
        {
            _eventType = DELAY_ACE_CONSCIOUSNESS_NUM;
            _timeStamp = [_timeStamp, _hitTime];
        };
    };
};

private _event = [_eventType, _timeStamp, _eventInfo];
[_event] call TN_tracker_fnc_saveEvent;

true
