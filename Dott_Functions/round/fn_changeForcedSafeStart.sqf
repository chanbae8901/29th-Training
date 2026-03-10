/*
 * Name:	DOTT_round_fnc_changedForcedSafeStart
 * Date:	03/06/2026
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Changes or cancel/unforces current safe start. Will not start a new safe start if one is not active.
 *
 * Parameter(s): 
 * _seconds (Number) - value to change safe start timer to in seconds. If 0 or less, will cancel/unforce safe start.
 *
 * Returns:
 * true if safe start changed by function, false otherwise
 *
 * Example:
 * [500] call DOTT_round_fnc_changeForcedSafeStart;
 * 
 */

params [["_seconds", 0, [0]]];

private _changed = false;

if (_seconds > 0) then
{
    if (call DOTT_round_fnc_isRoundActive) exitWith {};
    //do not call a new safe start, we don't have the logic here, don't want to redirect to initSafeStart for now
    if (isNil "DOTT_round_safeStartActive") exitWith {}; 

    [_seconds] call BIS_fnc_countdown;

    private _formattedTime = [_seconds] call DOTT_round_fnc_formatTime;
    private _text = format ["<t color='#ffffff' size='2'>Forced Safe Start changed to %1!</t>", _formattedTime];

    [
        _text,
        "PLAIN",
        0.5,
        false
    ] remoteExecCall ["DOTT_common_fnc_displayMsg"];

    _changed = true;
} else
{
    if !(isNil "DOTT_round_safeStartActive") then
    {					
        DOTT_round_ignoreReadiness = false; publicVariable "DOTT_round_ignoreReadiness";
        _changed = true;
    }
};

_changed