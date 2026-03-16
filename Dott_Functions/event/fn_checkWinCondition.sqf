/**
 * Function: TN_event_fnc_checkWinCondition
 * Author:   Bae [29th ID]
 *
 * Evaluates win conditions each tick during an active round.
 * Supports point-based victory via sector ownership and kill
 * tracking. Conditions can trigger mid-round (loopChecks) or
 * at round end (endChecks).
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     TN_event_score (global array)
 *     TN_event_opforWinConditions (global)
 *     TN_event_bluforWinConditions (global)
 *     TN_event_grnforWinConditions (global)
 *     TN_event_winCheckInterval (global, seconds)
 *     TN_event_fnc_game
 *     TN_round_fnc_isRoundActive
 */

private _loopChecks = [[{ false }], [{ false }], [{ false }]];
private _endChecks = [[{ false }], [{ false }], [{ false }]];

{
    private _pointValue = _x getVariable ["TN_pointValue", 0];

    if (_pointValue == 0) then { continue };

    switch (typeOf _x) do
    {
        case "ModuleSector_F":
        {
            [_x, "ownerChanged",
                {
                    params [
                        "_sector",
                        "_newOwner",
                        "_oldOwner"
                    ];
                    private _pointValue = _sector getVariable ["TN_pointValue", 0];
                    private _newOwnerId = _newOwner call BIS_fnc_sideId;
                    private _oldOwnerId = _oldOwner call BIS_fnc_sideId;

                    if (_newOwnerId <= 2) then
                    {
                        TN_event_score set [
                            _newOwnerId,
                            (TN_event_score
                                select _newOwnerId)
                                + _pointValue
                        ];
                    };
                    if (_oldOwnerId <= 2) then
                    {
                        TN_event_score set [
                            _oldOwnerId,
                            (TN_event_score
                                select _oldOwnerId)
                                - _pointValue
                        ];
                    };
                }
            ] call BIS_fnc_addScriptedEventHandler;

            private _owner = _x getVariable ["owner", sideUnknown];
            private _idx = _owner call BIS_fnc_sideID;
            if (_idx <= 2) then
            {
                TN_event_score set [
                    _idx,
                    (TN_event_score select _idx)
                        + _pointValue
                ];
            };
        };
        default
        {
            _x addEventHandler ["Killed",
            {
                params [
                    "_unit", "_killer", "_instigator"
                ];
                private _pointValue = _unit getVariable ["TN_pointValue", 0];
                private _awardTeam = _unit getVariable ["TN_awardTeam", sideUnknown];
                private _idx = _awardTeam call BIS_fnc_sideID;
                if (_idx <= 2) then
                {
                    TN_event_score set [
                        _idx,
                        (TN_event_score select _idx)
                            + _pointValue
                    ];
                };
            }];
        };
    };
} forEach (allMissionObjects "all");

fn_numPoints =
{
    params ["_sideId", "_pointsRequired"];
    TN_event_score select _sideId >= _pointsRequired
};

private _sideSettings =
[
    TN_event_opforWinConditions,
    TN_event_bluforWinConditions,
    TN_event_grnforWinConditions
];

{
    if (_x isEqualType "") then { continue };

    private _winCon = toLower (_x select 0);
    private _winArgs = _x select 1;
    private _atEnd = _x select 2;

    private _checkFn = switch (_winCon) do
    {
        case "points":
        {
            [fn_numPoints,
                [_forEachIndex, _winArgs]];
        };
        default
        {
            [{ false }];
        };
    };

    if (_atEnd) then
    {
        _endChecks set [_forEachIndex, _checkFn];
    }
    else
    {
        _loopChecks set [_forEachIndex, _checkFn];
    };
} forEach _sideSettings;

[
    "TN_round_ended",
    {
        private _endChecks = _thisArgs;
        {
            private _fnCheck = _x select 0;
            private _args = [];
            if (count _x >= 2) then
            {
                _args = _x select 1;
            };
            if (_args call _fnCheck) exitWith
            {
                private _winningSide = _forEachIndex call BIS_fnc_sideType;
                [true, _winningSide] call TN_event_fnc_game;
            };
        } forEach _endChecks;

        [true] call TN_event_fnc_game;
    }, _endChecks
] call CBA_fnc_addEventHandlerArgs;

if (isNil "TN_event_winCheckInterval") then
{
    TN_event_winCheckInterval = 0.5;
};

while {call TN_round_fnc_isRoundActive} do
{
    sleep TN_event_winCheckInterval;

    {
        private _fnCheck = _x select 0;
        private _args = [];
        if (count _x >= 2) then
        {
            _args = _x select 1;
        };
        if (_args call _fnCheck) exitWith
        {
            private _winningSide = _forEachIndex call BIS_fnc_sideType;
            [true, _winningSide] call TN_event_fnc_game;
        };
    } forEach _loopChecks;
};
