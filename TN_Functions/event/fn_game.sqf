#include "script_component.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Ends the mission with a specific side victory, neutral
 * ending, or named ending class. Redirects to server if
 * called on a client. Prevents duplicate endings via the
 * TN_event_gameCalled guard.
 *
 * Arguments:
 * 0: Winning side, omit for neutral ending <SIDE> (default: sideUnknown)
 * 1: Named ending class from CfgDebriefing, overrides side victory if set <STRING> (default: "")
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [west] call TN_event_fnc_game;
 */

params
[
    ["_sideVictory", sideUnknown],
    ["_endingClass", "", [""]]
];

if (!isServer) exitWith {
    _this remoteExecCall [QFUNC(game), 2];
};

/******** CONFIG ********/
private _endNeutral = "EndNeutral";
private _endWest = "EndWestVictory";
private _endEast = "EndEastVictory";
private _endResistance = "EndGuerVictory";

/************************/

// Prevents duplicate endings.
if (isNil QGVAR(gameCalled)) then {
    GVAR(gameCalled) = false;
};
if (GVAR(gameCalled)) exitWith {};
GVAR(gameCalled) = true;
publicVariable QGVAR(gameCalled);
[QGVAR(missionEnded), []] call CBA_fnc_globalEvent;

if (_endingClass isNotEqualTo "") then {
    [_endingClass] remoteExecCall ["BIS_fnc_endMission"];
} else {
    switch (_sideVictory) do {
        case west: {
            [_endWest] remoteExecCall ["BIS_fnc_endMission"];
        };
        case east: {
            [_endEast] remoteExecCall ["BIS_fnc_endMission"];
        };
        case resistance: {
            [_endResistance] remoteExecCall ["BIS_fnc_endMission"];
        };
        default {
            [_endNeutral] remoteExecCall ["BIS_fnc_endMission"];
        };
    };
};

nil
