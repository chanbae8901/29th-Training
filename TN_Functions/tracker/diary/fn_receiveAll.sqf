/*
 * Author: Bae [29th ID]
 * Client-side function that receives all previous round
 * histories at once and processes them sequentially.
 * Called via remoteExec from fn_sendAll.
 *
 * Arguments:
 * 0: TN_tracker_previous from server, each element is [events, names, sides, weapons] <ARRAY>
 *
 * Return Value:
 * Nothing
 */

if (!hasInterface) exitWith {};
params ["_allRounds"];

{
    _x params ["_events", "_names", "_sides", "_weapons"];
    private _roundNum = _forEachIndex + 1;
    [
        _events, _names, _sides,
        _weapons, _roundNum
    ] call TN_tracker_fnc_createDiaryEntries;
} forEach _allRounds;

nil
