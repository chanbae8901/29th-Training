/**
 * Function: TN_tracker_fnc_sendAll
 * Author:   Bae [29th ID]
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

[TN_tracker_previous] remoteExecCall [
    "TN_tracker_fnc_receiveAll",
    _player
];

true
