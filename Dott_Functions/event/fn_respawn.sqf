/**
 * Function: TN_event_fnc_respawn
 * Author:   Bae [29th ID], modified from Dott [29th ID]
 *
 * Tracks player deaths during a live round and teleports
 * the player to the spectate area when they exhaust their
 * limited lives. Optionally strips weapons on final respawn.
 *
 * Parameters:
 *     _storeDeaths (bool) - When true, records the player's
 *         current death count and exits. Used at round start
 *         to baseline.
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     TN_event_numberOfLives (global)
 *     TN_event_spectateArea (global object)
 *     TN_event_liveDeaths (global, set at round start)
 *     TN_event_respawnDisarmPlayers (global bool)
 *     TN_round_fnc_isRoundActive
 */

params
[
    ["_storeDeaths", false, [false]]
];

if (!hasInterface) exitWith {};

//exit script if the number of lives setting should
//permit unlimited respawns (just in case)
if (TN_event_numberOfLives isEqualTo 0) exitWith {};

if !(call TN_round_fnc_isRoundActive) exitWith {};

if (_storeDeaths) exitWith
{
    TN_event_liveDeaths = getPlayerScores Player select 4;
};

private _playerDeaths = getPlayerScores player select 4;

if (isNil "TN_event_liveDeaths") then
{
    TN_event_liveDeaths = 0;
};

_playerDeaths = (_playerDeaths - TN_event_liveDeaths);

if (_playerDeaths >= TN_event_numberOfLives) then
{
    private _point = getPosASL TN_event_spectateArea;

    titleText [
        "<t color='#ffffff' size='4'>"
            + "Out of Lives!</t>",
        "BLACK OUT", 0.5, true, true
    ];
    player allowDamage false;
    sleep 0.2;

    // Prevent death/accidents during teleport
    player enableSimulationGlobal false;
    sleep 0.3;

    private _dir = random 360;
    player SetPosASL [
        (_point select 0) - 6 * sin(_dir),
        (_point select 1) - 6 * cos(_dir),
        (_point select 2)
    ];
    sleep 0.1;

    player enableSimulationGlobal true;
    sleep 0.4;

    private _ground = isTouchingGround player;

    if (!_ground) then
    {
        private _curr = getPos player;
        private _height = _curr select 2;

        if (_height > 2) then
        {
            player setPos [
                _curr select 0,
                _curr select 1,
                0
            ];
        }
        //otherwise a little extra time to fall
        else
        {
            sleep 0.4;
        };
    };

    sleep 0.2;

    player allowDamage true;
    titleText [
        "<t color='#ffffff' size='4'>"
            + "Out of Lives!</t>",
        "BLACK IN", 0.5, true, true
    ];

    if (TN_event_respawnDisarmPlayers) then
    {
        removeAllWeapons player;
    };
};
