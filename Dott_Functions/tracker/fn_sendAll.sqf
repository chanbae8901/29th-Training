/**
 * File: fn_sendAll.sqf
 * Function: DOTT_tracker_fnc_sendAll
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Server-side function (called via remoteExec from client) that
 * sends all previous round histories to a joining/reconnecting
 * client so they can view past round diaries.
 *
 * Parameters:
 * _player (Object): The client's player object to send data to.
 *
 * Returns:
 * true
 */

params ["_player"];

private _numRounds = count DOTT_tracker_previous;

for "_i" from 0 to (_numRounds - 1) do
{
    private _roundInfo =
        DOTT_tracker_previous select _i;
    private _events = _roundInfo select 0;
    private _names = _roundInfo select 1;
    private _sides = _roundInfo select 2;
    private _weapons = _roundInfo select 3;
    private _numRound = _i + 1;
    [
        _events, _names, _sides,
        _weapons, _numRound
    ] remoteExec [
        "DOTT_tracker_fnc_createDiaryEntries",
        _player
    ];
};

true
