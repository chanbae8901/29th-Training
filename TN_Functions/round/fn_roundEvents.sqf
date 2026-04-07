#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Manages timed round events (time warnings). Registers a 1-second
 * perFrameHandler that fires events when the countdown crosses their
 * trigger thresholds. Handles addTime resets so events re-trigger
 * after time is added. Client-side only for now.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_round_fnc_roundEvents;
 */

if (!hasInterface) exitWith {};

GVAR(timeAdded) = false;

/* --- Event table: [triggerSeconds, function, args] --- */
private _events = [
    [5 * 60, FUNC(timeWarning), []],
    [1 * 60, FUNC(timeWarning), []]
];

[{
    params ["_args", "_handle"];
    _args params ["_events", "_eventIndex"];

    private _timeLeft = call FUNC(getTime);

    if (_timeLeft <= 0) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Reset event index when addTime extends the clock.
    if (GVAR(timeAdded)) then {
        _eventIndex = 0;
        GVAR(timeAdded) = false;
    };

    /* --- Fire events whose trigger time has been reached --- */
    while {
        (_eventIndex < count _events)
        && {
            ((_events select _eventIndex) select 0)
                >= _timeLeft
        }
    } do {
        (_events select _eventIndex)
            params ["_eventTime", "_fn", "_params"];

        // Avoid overlapping from addTime; always fire the last event if time > 0.
        if (
            _eventTime - _timeLeft < 30
            || (
                _eventIndex isEqualTo count _events - 1
                && _timeLeft > 0
            )
        ) then {
            _params call _fn;
        };

        _eventIndex = _eventIndex + 1;
    };

    _args set [1, _eventIndex];
}, 1, [_events, 0]] call CBA_fnc_addPerFrameHandler;

nil
