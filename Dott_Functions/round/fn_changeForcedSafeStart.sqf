/**
 * Function: TN_round_fnc_changeForcedSafeStart
 * Author:   Bae [29th ID]
 *
 * Changes or cancels/unforces a currently active safe start. Will not
 * start a new safe start if one is not already active. Passing 0 or
 * less unforces the safe start so it ends if teams are not all ready.
 *
 * Parameters:
 *     _seconds - Number - New safe start duration in seconds. 0 or less
 *         cancels/unforces. Default: 0
 *
 * Returns:
 *     Boolean - true if safe start was changed, false otherwise.
 *
 * Example:
 *     [60] call TN_round_fnc_changeForcedSafeStart;
 */

params [["_seconds", 0, [0]]];

private _changed = false;

if (_seconds > 0) then
{
    if (call TN_round_fnc_isRoundActive) exitWith {};

    // Don't call a new safe start; redirect to initSafeStart for that.
    if (!TN_round_safeStartActive) exitWith {};

    [_seconds] call BIS_fnc_countdown;

    private _formattedTime =
        [_seconds] call TN_round_fnc_formatTime;
    private _text = format [
        "<t color='#ffffff' size='2'>Forced Safe Start changed to %1!</t>",
        _formattedTime
    ];

    [
        _text,
        "PLAIN",
        0.5,
        false
    ] remoteExecCall ["TN_common_fnc_displayMsg"];

    _changed = true;
}
else
{
    if (TN_round_safeStartActive) then
    {
        TN_round_ignoreReadiness = false;
        publicVariable "TN_round_ignoreReadiness";
        _changed = true;
    };
};

_changed
