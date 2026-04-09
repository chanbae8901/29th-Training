#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Adds Side Ready and Unready actions to
 * timer objects for BLUFOR, OPFOR, or GRNFOR players
 * if round has not started.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_flagActions;
 */

{
    if (isNil {_x}) then {
        GVAR(timerObjects) set
            [_forEachIndex, objNull];
    };
} forEach GVAR(timerObjects);

/* --- Add actions to all objects --- */

private _validSide =
    playerSide in [west, east, resistance];

{
    if (!isNull _x) then {
        if (_validSide
            && NOT_ROUND_LIVE) then {
            private _readyId = _x addAction [
                "<t color='#bf3eff'>"
                    + "Side Ready</t>", {
                    [playerSide, true]
                        call EFUNC(round,manageReady);
                },
                nil,
                1.5, true, true, "",
                "!(" + QEGVAR(round,sideReady) + " select"
                + " (playerSide call BIS_fnc_sideID))",
                8
            ];

            private _unreadyId = _x addAction [
                "<t color='#bf3eff'>"
                    + "Side Unready</t>", {
                    [playerSide, false]
                        call EFUNC(round,manageReady);
                },
                nil,
                1.5, true, true, "",
                QEGVAR(round,sideReady) + " select"
                + " (playerSide call BIS_fnc_sideID)",
                8
            ];

            _x setVariable [
                QGVAR(readyActionIds),
                [_readyId, _unreadyId]
            ];
        };
    };
} forEach GVAR(timerObjects);

/* --- Remove ready actions on round start --- */

[
    QEGVAR(round,started), {
        private _objects =
            GVAR(timerObjects);
        {
            if (!isNull _x) then {
                private _obj = _x;
                private _ids = _obj getVariable
                    [QGVAR(readyActionIds), []];
                { _obj removeAction _x }
                    forEach _ids;
            };
        } forEach _objects;
    }
] call CBA_fnc_addEventHandler;

/* --- Remove actions after game is called --- */

[
    QGVAR(missionEnded), {
        {
            if (!isNull _x) then {
                removeAllActions _x;
            };
        } forEach (
            GVAR(timerObjects)
        );

        if (!isNil QGVAR(adminMenuActionId)) then {
            player removeAction GVAR(adminMenuActionId);
            GVAR(adminMenuActionId) = nil;
        };
    }
] call CBA_fnc_addEventHandler;

nil
