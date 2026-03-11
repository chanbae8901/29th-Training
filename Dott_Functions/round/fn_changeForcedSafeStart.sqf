/**
 * @description Changes or cancels/unforces a currently active safe
 *     start. Will not start a new safe start if one is not already
 *     active. Passing 0 or less unforces the safe start so it ends
 *     if teams are not all ready.
 * @param {Number} _seconds - New safe start duration in seconds.
 *     0 or less cancels/unforces. Default: 0
 * @return {Boolean} true if safe start was changed, false otherwise.
 * @example [60] call DOTT_round_fnc_changeForcedSafeStart;
 */

params [["_seconds", 0, [0]]];

private _changed = false;

if (_seconds > 0) then
{
    if (call DOTT_round_fnc_isRoundActive) exitWith {};

    // Don't call a new safe start; redirect to initSafeStart for that.
    if (isNil "DOTT_round_safeStartActive") exitWith {};

    [_seconds] call BIS_fnc_countdown;

    private _formattedTime =
        [_seconds] call DOTT_round_fnc_formatTime;
    private _text = format [
        "<t color='#ffffff' size='2'>Forced Safe Start changed to %1!</t>",
        _formattedTime
    ];

    [
        _text,
        "PLAIN",
        0.5,
        false
    ] remoteExecCall ["DOTT_common_fnc_displayMsg"];

    _changed = true;
}
else
{
    if !(isNil "DOTT_round_safeStartActive") then
    {
        DOTT_round_ignoreReadiness = false;
        publicVariable "DOTT_round_ignoreReadiness";
        _changed = true;
    };
};

_changed
