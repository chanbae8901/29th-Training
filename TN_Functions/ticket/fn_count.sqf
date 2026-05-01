#include "script_component.hpp"
/*
 * Author: Dott [29th ID]
 * Counts tickets and displays them discretly to each team and
 * the admin. Does not use BIS_fnc_respawnTickets. Called via
 * remoteExec from the client respawn event handler.
 *
 * Arguments:
 * 0: The side of the player who respawned <SIDE>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * private _playerSide = playerSide;
 * [_playerSide] remoteExec ["TN_ticket_fnc_count", 2];
 */

params
[
    ["_playerSide", sideUnknown]
];

if (!isServer) exitWith {};
if (NOT_ROUND_LIVE) exitWith {};

private _clientOwner = remoteExecutedOwner;

// Map the side to its ID and admin-facing label.
// Civilian and unknown sides are ignored.
private _sideName = [_playerSide] call EFUNC(common,convertSide);
private _sideID = _playerSide call BIS_fnc_sideID;

if (_sideID < 0 || _sideID > 2) exitWith {};

// Decrement, notify player and team.
private _tickets = GVAR(counts) select _sideID;

if (_tickets isEqualTo 0) then {
    [
        "<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>",
        "PLAIN",
        0.8
    ] remoteExecCall [
        QEFUNC(common,displayMsg),
        _clientOwner
    ];
} else {
    _tickets = _tickets - 1;
    GVAR(counts) set [_sideID, _tickets];
    publicVariable QGVAR(counts);

    if (_tickets isEqualTo 0) then {
        // Last ticket -- warn team and admin.
        ["Your team is out of tickets!", 10] remoteExecCall [QEFUNC(common,timedHint), _playerSide];
        format [
            "ADMIN: %1 is out of tickets!", _sideName
        ] remoteExecCall [QEFUNC(common,timedHint), EGVAR(common,adminClient)];
        [
            "<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>",
            "PLAIN",
            0.8
        ] remoteExecCall [QEFUNC(common,displayMsg), _clientOwner];
    } else {
        // Tickets remain -- silent hint to team, message to player.
        format [
            "Your team has %1 tickets remaining!",
            _tickets
        ] remoteExecCall [QEFUNC(common,timedHint), _playerSide];
        [
            "<t color='#ffffff' size='2'>You may leave spawn!</t>",
            "PLAIN",
            0.5
        ] remoteExecCall [QEFUNC(common,displayMsg), _clientOwner];
    };
};

nil
