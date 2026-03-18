/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Displays a time remaining notification via BIS notification system.
 * Currently restricted to admins only.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_round_fnc_timeWarning;
 */

// Admin-only for now.
if (!serverCommandAvailable "#lock") exitWith {};

private _secondsLeft = call TN_round_fnc_getTime;
private _minutes = ceil(_secondsLeft / 60);
private _actualMinutes = _secondsLeft / 60;

private _prefix =
    ["", "Less than "] select ((_minutes - _actualMinutes) > 0.25);

private _plural = ["", "s"] select (_minutes != 1);

private _message = format [
    "%1%2 minute%3 remaining!",
    _prefix,
    _minutes,
    _plural
];

["TimeWarning", [_message]] call BIS_fnc_showNotification;
