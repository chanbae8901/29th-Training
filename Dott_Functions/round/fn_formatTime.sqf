/**
 * Function: TN_round_fnc_formatTime
 * Author:   Bae [29th ID]
 *
 * Formats a time value in seconds into a human-readable string like
 * "20 Minutes" or "1 Hour 30 Minutes 5 Seconds". Omits zero-valued
 * units. Uses singular forms when appropriate.
 *
 * Parameters:
 *     _seconds - Number - Time in seconds to format.
 *     _forceNoS - Boolean - Always use singular form for units.
 *         Default: false
 *
 * Returns:
 *     String - Formatted time string.
 *
 * Example:
 *     [300] call TN_round_fnc_formatTime;
 */

params ["_seconds", ["_forceNoS", false]];

private _hours = floor (_seconds / 3600);
private _mins = floor ((_seconds mod 3600) / 60);
private _secs = _seconds mod 60;

private _timeParts = [];

/* --- Hours --- */
if (_hours > 0) then
{
    private _hourWord = ["Hours", "Hour"]
        select (_hours == 1 || _forceNoS);
    _timeParts pushBack format [
        "%1 %2", _hours, _hourWord
    ];
};

/* --- Minutes --- */
if (_mins > 0) then
{
    private _minWord = ["Minutes", "Minute"]
        select (_mins == 1 || _forceNoS);
    _timeParts pushBack format [
        "%1 %2", _mins, _minWord
    ];
};

/* --- Seconds (always shown if nothing else) --- */
if (_secs > 0 || count _timeParts == 0) then
{
    private _secWord = ["Seconds", "Second"]
        select (_secs == 1 || _forceNoS);
    _timeParts pushBack format [
        "%1 %2", _secs, _secWord
    ];
};

private _timeText = _timeParts joinString " ";

_timeText
