/**
 * Function: TN_event_fnc_flagActions
 * Author:   Bae [29th ID]
 *
 * Adds a single "Event Menu" scroll-wheel action to timer
 * objects and the ending object. The action opens a GUI
 * dialog (TN_event_fnc_gui_flagMenu) that presents
 * context-sensitive options based on the current round state
 * and admin status.
 *
 * Adds Side Ready and Unready actions to players in
 * BLUFOR, OPFOR, or GRNFOR if round has not started.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     TN_event_timerObjects (global array)
 *     TN_event_endingObject (global object)
 *     TN_event_fnc_gui_flagMenu
 */

{
    if (isNil {_x}) then
    {
        TN_event_timerObjects set
            [_forEachIndex, objNull];
    };
} forEach TN_event_timerObjects;

if (isNil "TN_event_endingObject") then
{
    TN_event_endingObject = objNull;
    systemChat "WARNING: Admin object (endingObject) not found!";
};

/* --- Add actions to all objects --- */

private _validSide =
    playerSide in [west, east, resistance];

private _allObjects =
    TN_event_timerObjects + [TN_event_endingObject];

{
    if (!isNull _x) then
    {
        if (_validSide
            && {!(call TN_round_fnc_isRoundActive)}) then
        {
            private _readyId = _x addAction [
                "<t color='#bf3eff'>"
                    + "Side Ready</t>",
                {
                    [playerSide, true]
                        call TN_round_fnc_manageReady;
                },
                nil,
                1.5, true, true, "",
                "!(TN_round_sideReady select"
                + " (playerSide call BIS_fnc_sideID))",
                8
            ];

            private _unreadyId = _x addAction [
                "<t color='#bf3eff'>"
                    + "Side Unready</t>",
                {
                    [playerSide, false]
                        call TN_round_fnc_manageReady;
                },
                nil,
                1.5, true, true, "",
                "TN_round_sideReady select"
                + " (playerSide call BIS_fnc_sideID)",
                8
            ];

            _x setVariable [
                "TN_event_readyActionIds",
                [_readyId, _unreadyId]
            ];
        };

        _x addAction [
            "<t color='#bf3eff'>"
                + "Event Menu</t>",
            { call TN_event_fnc_gui_flagMenu },
            nil,
            1.5, true, true, "",
            "serverCommandAvailable '#lock'",
            8
        ];
    };
} forEach _allObjects;

/* --- Remove ready actions on round start --- */

[
    "TN_round_started",
    {
        private _objects =
            TN_event_timerObjects
            + [TN_event_endingObject];
        {
            if (!isNull _x) then
            {
                private _obj = _x;
                private _ids = _obj getVariable
                    ["TN_event_readyActionIds", []];
                { _obj removeAction _x }
                    forEach _ids;
            };
        } forEach _objects;
    }
] call CBA_fnc_addEventHandler;

/* --- Remove actions after game is called --- */

[
    "TN_event_gameCalled",
    {
        {
            if (!isNull _x) then
            {
                removeAllActions _x;
            };
        } forEach (
            TN_event_timerObjects
            + [TN_event_endingObject]
        );
    }
] call CBA_fnc_addEventHandler;
