#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Server-side function that constructs an ace_unconscious event
 * array for the tracker. Records when a player goes unconscious
 * or regains consciousness, attributing the cause via stored
 * hit data when available.
 *
 * Arguments:
 * 0: The unit changing consciousness state <OBJECT>
 * 1: true = went unconscious, false = woke up <BOOL>
 *
 * Return Value:
 * true if saved, false otherwise <BOOL>
 */

#include "eventNumbers.hpp"
params ["_unit", "_state"];
if (GVAR(startTime) isEqualTo -1) exitWith { false };
if (!isPlayer _unit) exitWith { false };

private _timeStamp =
    round(serverTime - GVAR(startTime));

// Need group since ACE3? sets unconscious men to CIV but
// not the group.
private _eventInfo = [
    [name _unit, side (group _unit)], _state
];
private _eventType = ACE_CONSCIOUSNESS_NUM;

if (_state) then {
    private _lastHit =
        _unit getVariable QGVAR(lastHit);

    if !(isNil "_lastHit") then {
        _lastHit append
            ((_unit getVariable QGVAR(hitMap))
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

        if (_timeStamp - _hitTime > DELAY_TIME) then {
            _eventType = DELAY_ACE_CONSCIOUSNESS_NUM;
            _timeStamp = [_timeStamp, _hitTime];
        };
    };
};

private _event = [_eventType, _timeStamp, _eventInfo];
[_event] call FUNC(saveEvent);

true
