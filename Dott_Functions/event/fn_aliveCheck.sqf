/**
 * Function: TN_event_fnc_aliveCheck
 * Author:   Bae [29th ID], modified from Dott [29th ID]
 *
 * Monitors alive player counts per side and triggers game end
 * when only one side remains. Supports both permadeath (BIRD
 * respawn) and spectate-area-based death detection.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     TN_event_fnc_game
 *     TN_round_fnc_isRoundActive
 *     TN_event_spectateArea (global, if respawn-based)
 *     TN_event_spectateAreaRadius (global, if respawn-based)
 */

if (!isServer) exitWith {};

scopeName "main";

/************************/

private _respawnType = 0 call BIS_fnc_missionRespawnType;
// BIRD respawn = players remain dead.
private _remainDead = (_respawnType == 1);

waitUntil {
    sleep 10;
    call TN_round_fnc_isRoundActive
};


while {call TN_round_fnc_isRoundActive} do
{
    sleep 5;

    private _allPlayers = call BIS_fnc_listPlayers;

    private _bluforPlayers = [];
    private _opforPlayers = [];
    private _resistancePlayers = [];

    {
        private _side = side group _x;
        switch (_side) do
        {
            case west:
            {
                _bluforPlayers pushBack _x;
            };
            case east:
            {
                _opforPlayers pushBack _x;
            };
            case resistance:
            {
                _resistancePlayers pushBack _x;
            };
            default {};
        };
    } forEach _allPlayers;

    private _numBluforDead = 0;
    private _numOpforDead = 0;
    private _numResistanceDead = 0;

    if (_remainDead) then
    {
        _numBluforDead = { !alive _x } count _bluforPlayers;
        _numOpforDead = { !alive _x } count _opforPlayers;
        _numResistanceDead = { !alive _x } count _resistancePlayers;
    }
    else
    {
        _numBluforDead = {
            (_x distance2D TN_event_spectateArea) < TN_event_spectateAreaRadius
        } count _bluforPlayers;

        _numOpforDead = {
            (_x distance2D TN_event_spectateArea) < TN_event_spectateAreaRadius
        } count _opforPlayers;

        _numResistanceDead = {
            (_x distance2D TN_event_spectateArea) < TN_event_spectateAreaRadius
        } count _resistancePlayers;
    };

    private _isBluforAlive = (count _bluforPlayers) > _numBluforDead;
    private _isOpforAlive = (count _opforPlayers) > _numOpforDead;
    private _isResistanceAlive = (count _resistancePlayers) > _numResistanceDead;


    //if all sides are wiped out, return to start
    //of loop. Prevents niche case of last player
    //on either team trading causing an erroneous
    //victory. Admin can call game manually in
    //this case.
    if (!_isBluforAlive
        && !_isOpforAlive
        && !_isResistanceAlive) then
    {
        continue;
    };

    private _winnerSide = civilian;

    if (_isBluforAlive
        && !_isOpforAlive
        && !_isResistanceAlive) then
    {
        _winnerSide = west;
    };
    if (!_isBluforAlive
        && _isOpforAlive
        && !_isResistanceAlive) then
    {
        _winnerSide = east;
    };
    if (!_isBluforAlive
        && !_isOpforAlive
        && _isResistanceAlive) then
    {
        _winnerSide = resistance;
    };

    if (_winnerSide != civilian) then
    {
        [true, _winnerSide] call TN_event_fnc_game;
        breakTo "main";
    };
};
