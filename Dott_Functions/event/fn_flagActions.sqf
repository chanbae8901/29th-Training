/**
 * DOTT_event_fnc_flagActions
 *
 * Creates and manages all admin/player scroll-wheel actions
 * on timer objects and the ending object. Actions are added
 * and removed automatically in response to CBA round-
 * lifecycle events (safe start begin/abort/start, game
 * called).
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     DOTT_event_timerObjects (global array)
 *     DOTT_event_endingObject (global object)
 *     DOTT_round_sideReady (global array)
 *     DOTT_round_fnc_isRoundActive
 *     DOTT_round_fnc_manageReady
 *     DOTT_round_fnc_initSafeStart
 *     DOTT_round_fnc_start
 *     DOTT_event_fnc_gui_setSafeStartTime
 *     DOTT_event_fnc_game
 *     DOTT_event_timerLength (global)
 */

{
    //if timer object is nil, set to objNull to
    //avoid errors
    if (isNil {_x}) then
    {
        DOTT_event_timerObjects set
            [_forEachIndex, objNull];
    };
} forEach DOTT_event_timerObjects;

if (isNil "DOTT_event_endingObject") then
{
    DOTT_event_endingObject = objNull;
    systemChat "WARNING: Admin object (endingObject) not found!";
};

private _currentState = switch (true) do
{
    case (call DOTT_round_fnc_isRoundActive):
    {
        2;
    };
    case (!isNil "DOTT_round_safeStartActive"):
    {
        1;
    };
    default { 0 };
};

/*** Side Ready ***/
#define SIDE_READY_ID "DOTT_sideReadyActionId"

private _fnc_addSideReadyActions =
{
    {
        private _actionId = _x addAction [
            "<t color='#bf3eff'>"
                + "Side Ready</t>",
            {
                (_this select 3)
                    call DOTT_round_fnc_manageReady;
            },
            [playerSide, true],
            1.5, true, true, "", "true", 8
        ];
        _x setVariable [SIDE_READY_ID, _actionId];
    } forEach DOTT_event_timerObjects;
};

private _fnc_removeSideReadyActions =
{
    {
        private _actionId = _x getVariable [SIDE_READY_ID, -1];
        _x removeAction _actionId;
        _x setVariable [SIDE_READY_ID, nil];
    } forEach DOTT_event_timerObjects;
};

if (_currentState == 0) then
{
    private _playerSideReady = DOTT_round_sideReady select (playerSide call BIS_fnc_sideID);
    if !(_playerSideReady) then
    {
        call _fnc_addSideReadyActions;
    };
};

if (_currentState < 2) then
{
    [
        "DOTT_round_manageReadyChange",
        {
            params ["_side", "_isReady"];
            _thisArgs params [
                "_fnc_addSideReadyActions",
                "_fnc_removeSideReadyActions"
            ];
            if (_side != playerSide) exitWith {};
            if (_isReady) then
            {
                call _fnc_removeSideReadyActions;
            }
            else
            {
                call _fnc_addSideReadyActions;
            };
        },
        [_fnc_addSideReadyActions,
            _fnc_removeSideReadyActions]
    ] call CBA_fnc_addEventHandlerArgs;

    [
        "DOTT_round_safeStartBegin",
        { call _thisArgs },
        _fnc_removeSideReadyActions
    ] call CBA_fnc_addEventHandlerArgs;
};

/*** Ready All Sides (Admin) ***/
#define ALL_READY_ID "DOTT_allReadyActionId"

private _fnc_addAllReadyActions =
{
    {
        private _actionId = _x addAction [
            "<t color='#bf3eff'>"
                + "Ready All Sides (Admin)</t>",
            { call DOTT_round_fnc_initSafeStart },
            nil,
            1.5, true, true, "",
            "serverCommandAvailable '#lock'", 8
        ];
        _x setVariable [ALL_READY_ID, _actionId];
    } forEach DOTT_event_timerObjects;

    private _actionId =
        DOTT_event_endingObject addAction [
            "<t color='#bf3eff'>"
                + "Ready All Sides (Admin)</t>",
            { call DOTT_round_fnc_initSafeStart },
            nil,
            1.5, true, true, "",
            "serverCommandAvailable '#lock'", 8
        ];
    DOTT_event_endingObject setVariable [
        ALL_READY_ID, _actionId
    ];
};

private _fnc_removeAllReadyActions =
{
    {
        private _actionId = _x getVariable [ALL_READY_ID, -1];
        _x removeAction _actionId;
        _x setVariable [ALL_READY_ID, nil];
    } forEach DOTT_event_timerObjects;

    private _actionId = DOTT_event_endingObject getVariable [ALL_READY_ID, -1];
    DOTT_event_endingObject removeAction _actionId;
    DOTT_event_endingObject setVariable [ALL_READY_ID, nil];
};

if (_currentState == 0) then
{
    call _fnc_addAllReadyActions;
};

[
    "DOTT_round_safeStartBegin",
    _fnc_removeAllReadyActions
] call CBA_fnc_addEventHandler;

[
    "DOTT_round_safeStartAborted",
    _fnc_addAllReadyActions
] call CBA_fnc_addEventHandler;

/*** Cancel Safestart (Admin) ***/
#define CANCEL_SAFESTART_ID "DOTT_cancelSafeStartActionId"

private _fnc_addCancelSafeStart =
{
    private _fnc_unreadyAllSides =
    {
        [west, false, false] call DOTT_round_fnc_manageReady;
        [east, false, false] call DOTT_round_fnc_manageReady;
        [resistance, false, false] call DOTT_round_fnc_manageReady;
    };
    private _actionId =
        DOTT_event_endingObject addAction [
            "<t color='#bf3eff'>"
                + "Cancel Safestart (Admin)</t>",
            { call (_this select 3) },
            _fnc_unreadyAllSides,
            1.5, true, true, "",
            "serverCommandAvailable '#lock'", 8
        ];
    DOTT_event_endingObject setVariable [
        CANCEL_SAFESTART_ID, _actionId
    ];
};

private _fnc_removeCancelSafeStart =
{
    private _actionId = DOTT_event_endingObject getVariable [CANCEL_SAFESTART_ID, -1];
    DOTT_event_endingObject removeAction _actionId;
    DOTT_event_endingObject setVariable [CANCEL_SAFESTART_ID, nil];
};

if (_currentState == 1) then
{
    call _fnc_addCancelSafeStart;
};

[
    "DOTT_round_safeStartBegin",
    _fnc_addCancelSafeStart
] call CBA_fnc_addEventHandler;

[
    "DOTT_round_safeStartAborted",
    _fnc_removeCancelSafeStart
] call CBA_fnc_addEventHandler;

[
    "DOTT_round_started",
    _fnc_removeCancelSafeStart
] call CBA_fnc_addEventHandler;

/*** Change Safestart Time (Admin) ***/
#define CHANGE_SAFESTART_ID "DOTT_changeSafeStartActionId"

private _fnc_addChangeSafeStart =
{
    private _actionId =
        DOTT_event_endingObject addAction [
            "<t color='#bf3eff'>Change Safestart"
                + " Time (Admin)</t>",
            { call DOTT_event_fnc_gui_setSafeStartTime },
            nil,
            1.5, true, true, "",
            "serverCommandAvailable '#lock'", 8
        ];
    DOTT_event_endingObject setVariable [
        CHANGE_SAFESTART_ID, _actionId
    ];
};

private _fnc_removeChangeSafeStart =
{
    private _actionId = DOTT_event_endingObject getVariable [CHANGE_SAFESTART_ID, -1];
    DOTT_event_endingObject removeAction _actionId;
    DOTT_event_endingObject setVariable [CHANGE_SAFESTART_ID, nil];
};

if (_currentState == 1) then
{
    call _fnc_addChangeSafeStart;
};

[
    "DOTT_round_safeStartBegin",
    _fnc_addChangeSafeStart
] call CBA_fnc_addEventHandler;

[
    "DOTT_round_safeStartAborted",
    _fnc_removeChangeSafeStart
] call CBA_fnc_addEventHandler;

[
    "DOTT_round_started",
    _fnc_removeChangeSafeStart
] call CBA_fnc_addEventHandler;

/*** Force End Safestart (Admin) ***/
#define FORCE_END_SAFESTART_ID "DOTT_forceEndSafeStartActionId"

private _fnc_addForceEndSafeStartAction =
{
    private _actionId =
        DOTT_event_endingObject addAction [
            "<t color='#bf3eff'>Force End"
                + " Safestart (Admin)</t>",
            { [DOTT_event_timerLength] call DOTT_round_fnc_start },
            nil,
            1.5, true, true, "",
            "serverCommandAvailable '#lock'", 8
        ];
    DOTT_event_endingObject setVariable [
        FORCE_END_SAFESTART_ID, _actionId
    ];
};

private _fnc_removeForceEndSafeStartAction =
{
    private _actionId = DOTT_event_endingObject getVariable [FORCE_END_SAFESTART_ID, -1];
    DOTT_event_endingObject removeAction _actionId;
    DOTT_event_endingObject setVariable [FORCE_END_SAFESTART_ID, nil];
};

if (_currentState == 1) then
{
    call _fnc_addForceEndSafeStartAction;
};

[
    "DOTT_round_safeStartBegin",
    _fnc_addForceEndSafeStartAction
] call CBA_fnc_addEventHandler;

[
    "DOTT_round_safeStartAborted",
    _fnc_removeForceEndSafeStartAction
] call CBA_fnc_addEventHandler;

[
    "DOTT_round_started",
    _fnc_removeForceEndSafeStartAction
] call CBA_fnc_addEventHandler;

/*** Ending Actions (Admin) ***/

private _fnc_addEndingActions =
{
    DOTT_event_endingObject addAction [
        "<t color='#bf3eff'>"
            + "Neutral Ending (Admin)</t>",
        {
            [true] call DOTT_event_fnc_game;
        },
        nil,
        1.5, true, true, "",
        "serverCommandAvailable '#lock'", 8
    ];

    private _allPlayers = call BIS_fnc_listPlayers;
    private _sides = [
        [west, "BLUFOR", "#155DFC"],
        [east, "OPFOR", "#B40404"],
        [resistance, "GRNFOR", "#088A08"]
    ];

    {
        private _side = _x select 0;
        private _sideName = _x select 1;
        private _sideColor = _x select 2;

        if (({side group _x == _side}
            count _allPlayers) > 0) then
        {
            private _actionText = format [
                "<t color='%1'>"
                    + "%2 Victory (Admin)</t>",
                _sideColor,
                _sideName
            ];
            DOTT_event_endingObject addAction [
                _actionText,
                {
                    [true, _this select 3] call DOTT_event_fnc_game;
                },
                _side,
                1.5, true, true, "",
                "serverCommandAvailable '#lock'", 8
            ];
        };
    } forEach _sides;
};

//if JIP after round start
if (_currentState == 2) then
{
    call _fnc_addEndingActions;
}
else
{
    [
        "DOTT_round_started",
        _fnc_addEndingActions
    ] call CBA_fnc_addEventHandler;
};

[
    //remove all ending options after one is selected
    "DOTT_event_gameCalled",
    {
        removeAllActions DOTT_event_endingObject;
    }
] call CBA_fnc_addEventHandler;
