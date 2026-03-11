/**
 * @description Displays a time remaining notification via BIS
 *     notification system. Currently restricted to admins only.
 * @return None
 * @example call DOTT_round_fnc_timeWarning;
 */

// Admin-only for now.
if (!serverCommandAvailable "#lock") exitWith {};

private _secondsLeft = call DOTT_round_fnc_getTime;
private _minutes = ceil(_secondsLeft / 60);
private _actualMinutes = _secondsLeft / 60;

private _prefix = if (
    (_minutes - _actualMinutes) > 0.25
) then {"Less than "} else {""};

private _plural = if (_minutes != 1) then
    {"s"} else {""};

private _message = format [
    "%1%2 minute%3 remaining!",
    _prefix,
    _minutes,
    _plural
];

["TimeWarning", [_message]] call BIS_fnc_showNotification;
