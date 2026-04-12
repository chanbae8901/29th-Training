#include "script_component.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Ends the mission with a specific side victory, neutral
 * ending, or named ending class. Redirects to server if
 * called on a client. Prevents duplicate endings via the
 * TN_event_missionEnded guard.
 *
 * Arguments:
 * 0: Winning side or ending class, omit for neutral ending <SIDE|STRING> (default: sideUnknown)
 * 1: Delay before calling game <NUMBER> (default: 0)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [west] call TN_event_fnc_endMission;
 */

params
[
    ["_ending", "EndNeutral", [sideUnknown, ""]],
    ["_delay", 0, [0]]
];

if (!isServer) exitWith {
    _this remoteExecCall [QFUNC(endMission), 2];
};

/******** CONFIG ********/
#define END_NEUTRAL     "EndNeutral"
#define END_WEST        "EndWestVictory"
#define END_EAST        "EndEastVictory"
#define END_RESISTANCE  "EndGuerVictory"

/************************/

// Prevents duplicate endings.
if (GVAR(missionEnded)) exitWith {};
GVAR(missionEnded) = true;
publicVariable QGVAR(gameCalled);
[QGVAR(missionEnded), []] call CBA_fnc_globalEvent;

if (_ending isEqualType sideUnknown) then {
    _ending = switch (_ending) do {
        case west: {
            END_WEST;
        };
        case east: {
            END_EAST;
        };
        case resistance: {
            END_RESISTANCE;
        };
        default {
            END_NEUTRAL;
        };
    };
};

[{_this remoteExecCall ["BIS_fnc_endMission", 0, true]}, [_ending], _delay]
    call CBA_fnc_waitAndExecute;

nil
