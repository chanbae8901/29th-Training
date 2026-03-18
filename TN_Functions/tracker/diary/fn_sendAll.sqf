/*
 * Author: Bae [29th ID]
 * Server-side function (called via remoteExec from client) that
 * sends all previous round histories to a joining/reconnecting
 * client so they can view past round diaries.
 *
 * Arguments:
 * 0: The client's player object to send data to <OBJECT>
 *
 * Return Value:
 * true <BOOL>
 */

params ["_player"];

[TN_tracker_previous] remoteExecCall [
    "TN_tracker_fnc_receiveAll",
    _player
];

true
