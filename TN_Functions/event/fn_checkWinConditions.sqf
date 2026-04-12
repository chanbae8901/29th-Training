#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Evaluates pre-built win condition arrays. Called reactively
 * from sector/kill event handlers and on round end.
 *
 * Arguments:
 * 0: Game/round has ended <BOOL> (default: false)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [false] call TN_event_fnc_checkWinConditions;
 * [true] call TN_event_fnc_checkWinConditions;
 */

params [["_gameEnded", false, [false]]];

if (GVAR(useRoundSystem)
    && {NOT_ROUND_LIVE}
    && {!_gameEnded}) exitWith {};

private _checks = if (_gameEnded) then {
    GVAR(endChecks)
} else {
    GVAR(loopChecks)
};

{
    if (call _x) exitWith {
        private _winningSide = _forEachIndex call BIS_fnc_sideType;
        if (!GVAR(missionEnded)) then {
            [{
                params["_winningSide"];
                private _sideName = _winningSide call EFUNC(common,convertSide);
                private _msg = format ["%1 has completed the necessary objectives!", _sideName];
                _msg remoteExecCall [QEFUNC(common,timedHint)];
                _msg remoteExecCall ["systemChat"];
                [_winningSide, ENDING_DELAY] call FUNC(endMission);
            }, _winningSide, 5] call CBA_fnc_waitAndExecute;
        };

    };
} forEach _checks;

if (_gameEnded) then {
    [nil, ENDING_DELAY] call FUNC(endMission);
};

nil
