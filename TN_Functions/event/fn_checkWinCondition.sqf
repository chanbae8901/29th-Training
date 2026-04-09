#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Evaluates win conditions each tick during an active round.
 * Supports point-based victory via sector ownership and kill
 * tracking. Conditions can trigger mid-round (loopChecks) or
 * at round end (endChecks).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_checkWinCondition;
 */

private _loopChecks = [[{ false }], [{ false }], [{ false }]];
private _endChecks = [[{ false }], [{ false }], [{ false }]];

{
    private _pointValue = _x getVariable [QGVARMAIN(pointValue), 0];

    if (_pointValue isEqualTo 0) then { continue };

    switch (typeOf _x) do {
        case "ModuleSector_F": {
            [_x, "ownerChanged", {
                    params [
                        "_sector",
                        "_newOwner",
                        "_oldOwner"
                    ];
                    private _pointValue = _sector getVariable [QGVARMAIN(pointValue), 0];
                    private _newOwnerId = _newOwner call BIS_fnc_sideId;
                    private _oldOwnerId = _oldOwner call BIS_fnc_sideId;

                    if (_newOwnerId <= 2) then {
                        GVAR(score) set [
                            _newOwnerId,
                            (GVAR(score)
                                select _newOwnerId)
                                + _pointValue
                        ];
                    };
                    if (_oldOwnerId <= 2) then {
                        GVAR(score) set [
                            _oldOwnerId,
                            (GVAR(score)
                                select _oldOwnerId)
                                - _pointValue
                        ];
                    };
                }
            ] call BIS_fnc_addScriptedEventHandler;

            private _owner = _x getVariable ["owner", sideUnknown];
            private _idx = _owner call BIS_fnc_sideID;
            if (_idx <= 2) then {
                GVAR(score) set [
                    _idx,
                    (GVAR(score) select _idx)
                        + _pointValue
                ];
            };
        };
        default {
            _x addEventHandler ["Killed", {
                params [
                    "_unit", "_killer", "_instigator"
                ];
                private _pointValue = _unit getVariable [QGVARMAIN(pointValue), 0];
                private _awardTeam = _unit getVariable [QGVARMAIN(awardTeam), sideUnknown];
                private _idx = _awardTeam call BIS_fnc_sideID;
                if (_idx <= 2) then {
                    GVAR(score) set [
                        _idx,
                        (GVAR(score) select _idx)
                            + _pointValue
                    ];
                };
            }];
        };
    };
} forEach (allMissionObjects "all");

private _sideSettings =
[
    GVAR(opforWinConditions),
    GVAR(bluforWinConditions),
    GVAR(grnforWinConditions)
];

{
    if (_x isEqualType "") then { continue };

    _x params ["_winCon", "_winArgs", "_atEnd"];
    _winCon = toLowerANSI _winCon;

    private _checkFn = switch (_winCon) do {
        case "points": {
            [{
                params ["_sideId", "_pointsRequired"];
                GVAR(score) select _sideId >= _pointsRequired
            }, [_forEachIndex, _winArgs]];
        };
        default {
            [{ false }];
        };
    };

    if (_atEnd) then {
        _endChecks set [_forEachIndex, _checkFn];
    } else {
        _loopChecks set [_forEachIndex, _checkFn];
    };
} forEach _sideSettings;

[
    QEGVAR(round,ended), {
        private _endChecks = _thisArgs;
        {
            _x params ["_fnCheck", ["_args", []]];
            if (_args call _fnCheck) exitWith {
                private _winningSide = _forEachIndex call BIS_fnc_sideType;
                [_winningSide] call FUNC(game);
            };
        } forEach _endChecks;

        [] call FUNC(game);
    }, _endChecks
] call CBA_fnc_addEventHandlerArgs;

if (isNil QGVAR(winCheckInterval)) then {
    GVAR(winCheckInterval) = 0.5;
};

[{
    private _loopChecks = _this getVariable "params";

    {
        _x params ["_fnCheck", ["_args", []]];
        if (_args call _fnCheck) exitWith {
            private _winningSide = _forEachIndex call BIS_fnc_sideType;
            [_winningSide] call FUNC(game);
        };
    } forEach _loopChecks;
}, GVAR(winCheckInterval), _loopChecks, {}, {}, {true}, {NOT_ROUND_LIVE}] call CBA_fnc_createPerFrameHandlerObject;

nil
