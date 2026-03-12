/**
 * Function: DOTT_ticket_fnc_count
 * Author:   Dott [29th ID]
 *
 * Description:
 *   Counts tickets and displays them discretly to each team and
 *   the admin. Does not use BIS_fnc_respawnTickets. Called via
 *   remoteExec from the client respawn event handler.
 *
 * Parameters:
 *   _playerSide (Side) - The side of the player who respawned
 *
 * Returns:
 *   Nothing
 *
 * Example:
 *   private _playerSide = playerSide;
 *   [_playerSide] remoteExec ["DOTT_ticket_fnc_count", 2];
 */

params
[
    ["_playerSide", sideUnknown]
];

if (!isServer) exitWith {};

private _clientOwner = remoteExecutedOwner;

// Test each connected client for admin status.
// Default is server, to avoid sending hints to clients when no
// logged admin is present.
private _adminClient = 2;
{
    private _currentID = owner _x;
    private _adminStatus = admin _currentID;

    // If player is logged admin, define their clientOwnerID
    // as admin and exit forEach loop.
    if (_adminStatus isEqualTo 2) exitWith
    {
        _adminClient = _currentID;
    };
} forEach (allPlayers - entities "HeadlessClient_F");

// Map the side to its global variable name and admin-facing label.
// Civilian and unknown sides are ignored.
private _varName = "";
private _adminLabel = "";

switch (_playerSide) do
{
    case west:
    {
        _varName = "DOTT_ticketWEST";
        _adminLabel = "Blufor";
    };
    case east:
    {
        _varName = "DOTT_ticketEAST";
        _adminLabel = "Opfor";
    };
    case resistance:
    {
        _varName = "DOTT_ticketGUER";
        _adminLabel = "Grnfor";
    };
    case civilian: {};
    default {};
};

if (_varName isEqualTo "") exitWith {};

// Decrement, notify player and team.
private _tickets = missionNamespace getVariable [_varName, 0];

if (_tickets isEqualTo 0) then
{
    [
        "<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>",
        "PLAIN",
        0.8
    ] remoteExec [
        "DOTT_common_fnc_displayMsg",
        _clientOwner
    ];
}
else
{
    _tickets = _tickets - 1;
    missionNamespace setVariable [_varName, _tickets];
    publicVariable _varName;

    if (_tickets isEqualTo 0) then
    {
        // Last ticket -- warn team and admin.
        "Your team is out of tickets!" remoteExec ["hint", _playerSide];
        format [
            "ADMIN: %1 is out of tickets!", _adminLabel
        ] remoteExec ["hint", _adminClient];
        [
            "<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>",
            "PLAIN",
            0.8
        ] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
    }
    else
    {
        // Tickets remain -- silent hint to team, message to player.
        format [
            "Your team has %1 tickets remaining!",
            _tickets
        ] remoteExec ["hintSilent", _playerSide];
        [
            "<t color='#ffffff' size='2'>You may leave spawn!</t>",
            "PLAIN",
            0.5
        ] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
    };
};
