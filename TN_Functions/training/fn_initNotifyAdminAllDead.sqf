#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Initializes a server-side PFH that notifies the admin whenever
 * every alive player on a populated side is sitting inside an
 * arsenal zone during a LIVE round.
 *
 * Requires TN_base_fnc_initPlayersInBase (called automatically).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_training_fnc_initNotifyAdminAllDead;
 */

#define CHECK_INTERVAL 5

call EFUNC(base,initPlayersInBase);

if (!isServer) exitWith {};

GVAR(sideAllDead) = [false, false, false];

[{
    if (NOT_ROUND_LIVE) exitWith {};

    private _roster = EGVAR(base,playersInBase);

    // Index 0 = east, 1 = west, 2 = resistance.
    private _aliveCounts  = [0, 0, 0];
    private _inBaseCounts = [0, 0, 0];

    // One pass over allPlayers for alive counts per side.
    {
        if (!alive _x) then { continue };
        private _idx = [east, west, resistance] find (side group _x);
        if (_idx > -1) then {
            _aliveCounts set [_idx, (_aliveCounts select _idx) + 1];
        };
    } forEach allPlayers;

    // One pass over the (small) roster for in-base counts per side.
    {
        private _idx = [east, west, resistance] find (side group _x);
        if (_idx > -1) then {
            _inBaseCounts set [_idx, (_inBaseCounts select _idx) + 1];
        };
    } forEach _roster;

    {
        private _aliveCount = _aliveCounts select _forEachIndex;
        if (_aliveCount isEqualTo 0) then { continue };

        private _allDead = (_inBaseCounts select _forEachIndex) isEqualTo _aliveCount;
        private _prevAllDead = GVAR(sideAllDead) select _forEachIndex;

        if (_allDead && !_prevAllDead) then {
            GVAR(sideAllDead) set [_forEachIndex, true];
            private _name = [_x] call EFUNC(common,convertSide);
            [format ["All %1 players currently dead or in base.", _name], true, true] call EFUNC(common,notifyAdmin);
        };
        if (!_allDead && _prevAllDead) then {
            GVAR(sideAllDead) set [_forEachIndex, false];
        };
    } forEach [east, west, resistance];
}, CHECK_INTERVAL, []] call CBA_fnc_addPerFrameHandler;

// Round transitions -> wipe sticky state so next round starts clean
[QEGVAR(round,started), { GVAR(sideAllDead) = [false, false, false]; }] call CBA_fnc_addEventHandler;
[QEGVAR(round,ended),   { GVAR(sideAllDead) = [false, false, false]; }] call CBA_fnc_addEventHandler;

nil
