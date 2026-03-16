/**
 * Function: TN_round_fnc_roundEvents
 * Author:   Bae [29th ID]
 *
 * Manages timed round events (time warnings). Polls each second and
 * fires events when the countdown crosses their trigger thresholds.
 * Handles addTime resets so events re-trigger after time is added.
 * Client-side only for now.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     call TN_round_fnc_roundEvents;
 */

if (!hasInterface) exitWith {};

TN_round_timeAdded = false;

/* --- Event table: [triggerSeconds, function, args] --- */
private _events = [
    [5 * 60, TN_round_fnc_timeWarning, []],
    [1 * 60, TN_round_fnc_timeWarning, []]
];

private _timeLeft = call TN_round_fnc_getTime;
private _eventIndex = 0;

while
{
    _timeLeft > 0 || TN_round_overtimeEnabled == true
} do
{
    // Reset event index when addTime extends the clock.
    if (TN_round_timeAdded) then
    {
        _eventIndex = 0;
        TN_round_timeAdded = false;
    };

    /* --- Fire events whose trigger time has been reached --- */
    while
    {
        (_eventIndex < count _events)
        && {
            ((_events select _eventIndex) select 0)
                >= _timeLeft
        }
    } do
    {
        private _nextEvent = _events select _eventIndex;
        private _eventTime = _nextEvent select 0;
        private _fn = _nextEvent select 1;
        private _params = _nextEvent select 2;

        // Avoid overlapping from addTime; always fire the last event if time > 0.
        if (
            _eventTime - _timeLeft < 30
            || (
                _eventIndex == count _events - 1
                && _timeLeft > 0
            )
        ) then
        {
            _params call _fn;
        };

        _eventIndex = _eventIndex + 1;
    };

    uiSleep 1;
    _timeLeft = call TN_round_fnc_getTime;
};
