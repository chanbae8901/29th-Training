#include "script_component.hpp"

/*
 * Author: Claude prompted by Bae [29th ID]
 * Opens a centered GUI menu showing admin-only event actions
 * based on the current round state. Only accessible to
 * admins via the Event Menu addAction.
 *
 * Listens to CBA round-state events and rebuilds the menu
 * in-place whenever the state changes while the GUI is open.
 *
 * Uses createDialog (TN_RscDisplayFlagMenu, IDD 29140)
 * which overlays on display 46 -- readyUI stays visible.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_gui_flagMenu;
 */

// Prevent double-open
if !(isNull (findDisplay 29140)) exitWith {};

createDialog "TN_RscDisplayFlagMenu";
private _display = findDisplay 29140;
if (isNull _display) exitWith {};

/* --- Close function (define once) --- */

if (isNil QFUNC(closeFlagMenu)) then {
    FUNC(closeFlagMenu) = {
        // Remove CBA event handlers
        {
            _x call CBA_fnc_removeEventHandler;
        } forEach (uiNamespace getVariable [
            QGVAR(flagMenu_ehIds), []
        ]);

        uiNamespace setVariable [
            QGVAR(flagMenu_ehIds), nil
        ];
        uiNamespace setVariable [
            QGVAR(flagMenu_rebuild), nil
        ];

        // Close the dialog — destroys all controls with it
        private _dlg = findDisplay 29140;
        if !(isNull _dlg) then { _dlg closeDisplay 2 };
    };
};

/* --- Rebuild function --- */

private _fnc_rebuild = {
    params ["_display"];

    /* Delete old menu controls */
    private _oldControls = uiNamespace getVariable [
        QGVAR(flagMenu_controls), []
    ];
    { ctrlDelete _x } forEach _oldControls;

    /* --- Build action list: [label, code, colorRGBA] --- */

    private _actions = [];

    switch (EGVAR(round,state)) do {
        case 0: {
            _actions pushBack [
                "Begin Safe Start", {
                    params ["_ctrl"];
                    [GVAR(forcedSafeStart), true]
                        call EFUNC(round,initSafeStart);
                    call FUNC(closeFlagMenu);
                },
                [0.75, 0.25, 1, 1]
            ];
        };

        case 1: {

            _actions pushBack [
                "Cancel Safestart", {
                    params ["_ctrl"];
                    [0] call EFUNC(round,changeForcedSafeStart);
                    if (call EFUNC(round,checkAllSidesReady)) then {
                        {
                            [_x, false] call EFUNC(round,manageReady);
                        }
                        forEach [west, east, resistance];
                        systemChat "Unreadied all sides!";
                    };
                    call FUNC(closeFlagMenu);
                },
                [0.75, 0.25, 1, 1]
            ];


            _actions pushBack [
                "Change Safestart Time", {
                    params ["_ctrl"];
                    call FUNC(closeFlagMenu);
                    call FUNC(gui_setSafeStartTime);
                },
                [0.75, 0.25, 1, 1]
            ];


            _actions pushBack [
                "Force Live", {
                    params ["_ctrl"];
                    [GVAR(timerLength)]
                        call EFUNC(round,start);
                    call FUNC(closeFlagMenu);
                },
                [0.75, 0.25, 1, 1]
            ];
        };

        case 2: {
            _actions pushBack [
                "Neutral Ending", {
                    params ["_ctrl"];
                    [] call FUNC(game);
                    call FUNC(closeFlagMenu);
                },
                [0.75, 0.25, 1, 1]
            ];

            private _allPlayers =
                call BIS_fnc_listPlayers;
            private _sides = [
                [west, "BLUFOR",
                    [0.08, 0.36, 0.99, 1]],
                [east, "OPFOR",
                    [0.70, 0.02, 0.02, 1]],
                [resistance, "GRNFOR",
                    [0.03, 0.54, 0.03, 1]]
            ];

            {
                _x params [
                    "_side", "_sideName", "_sideColor"
                ];

                if (_allPlayers findIf
                    {side group _x isEqualTo _side} isNotEqualTo -1) then {
                    _actions pushBack [
                        _sideName + " Victory", {
                            params ["_ctrl"];
                            private _side = _ctrl getVariable QGVAR(side);
                            [_side] call FUNC(game);
                            call FUNC(closeFlagMenu);
                        },
                        _sideColor,
                        _side
                    ];
                };
            } forEach _sides;
        };
    };

    if (_actions isEqualTo []) exitWith {
        call FUNC(closeFlagMenu);
    };

    /* --- Layout constants --- */

    private _btnW = 0.25;
    private _btnH = 0.035;
    private _gap = 0.005;
    private _padding = 0.015;
    private _titleH = 0.035;

    private _contentH = _titleH + _padding
        + (count _actions * (_btnH + _gap)) - _gap;
    private _totalH = _contentH + _padding * 2;
    private _totalW = _btnW + _padding * 2;

    private _startX = 0.5 - _totalW / 2;
    private _startY = 0.5 - _totalH / 2;

    private _controls = [];

    /* --- Background --- */

    private _bg =
        _display ctrlCreate ["RscText", -1];
    _bg ctrlSetPosition [
        _startX, _startY,
        _totalW, _totalH
    ];
    _bg ctrlSetBackgroundColor [0, 0, 0, 0.8];
    _bg ctrlCommit 0;
    _controls pushBack _bg;

    /* --- Title --- */

    private _title =
        _display ctrlCreate ["RscStructuredText", -1];
    _title ctrlSetPosition [
        _startX + _padding,
        _startY + _padding,
        _btnW,
        _titleH
    ];
    _title ctrlSetStructuredText parseText (
        "<t color='#bf3eff' align='center' size='1.1'>"
        + "Event Menu</t>");
    _title ctrlCommit 0;
    _controls pushBack _title;

    /* --- Buttons --- */

    private _yPos =
        _startY + _padding + _titleH + _padding;

    {
        _x params ["_label", "_code", "_color",
            ["_sideVar", sideUnknown]];

        private _btn =
            _display ctrlCreate ["RscButton", -1];
        _btn ctrlSetText _label;
        _btn ctrlSetPosition [
            _startX + _padding, _yPos,
            _btnW, _btnH
        ];
        _btn ctrlSetBackgroundColor _color;
        if (_sideVar isNotEqualTo sideUnknown) then {
            _btn setVariable [QGVAR(side), _sideVar];
        };
        _btn ctrlCommit 0;
        _btn ctrlAddEventHandler [
            "ButtonClick", _code
        ];
        _controls pushBack _btn;

        _yPos = _yPos + _btnH + _gap;
    } forEach _actions;

    uiNamespace setVariable [
        QGVAR(flagMenu_controls), _controls
    ];
};

/* --- Store rebuild fn in uiNamespace for CBA handlers --- */

uiNamespace setVariable [
    QGVAR(flagMenu_rebuild), _fnc_rebuild
];

/* --- Initial build --- */

[_display] call _fnc_rebuild;

/* --- Subscribe to round-state CBA events --- */

private _stateEvents = [
    QEGVAR(round,safeStartBegin),
    QEGVAR(round,safeStartAborted),
    QEGVAR(round,started),
    QEGVAR(round,ended)
];

private _ehIds = [];

{
    private _id = [_x, {
        private _dlg = findDisplay 29140;
        if !(isNull _dlg) then {
            [_dlg] call (uiNamespace getVariable
                QGVAR(flagMenu_rebuild));
        };
    }] call CBA_fnc_addEventHandler;

    _ehIds pushBack [_x, _id];
} forEach _stateEvents;

uiNamespace setVariable [
    QGVAR(flagMenu_ehIds), _ehIds
];

/* --- Close on ESC --- */

_display displayAddEventHandler [
    "KeyDown", {
        params ["_display", "_key"];
        if (_key isEqualTo 1) then {
            call FUNC(closeFlagMenu);
            true
        } else {
            false
        };
    }
];

/* --- Clean up CBA EHs when dialog closes by any means --- */

_display displayAddEventHandler [
    "Unload", {
        {
            _x call CBA_fnc_removeEventHandler;
        } forEach (uiNamespace getVariable [
            QGVAR(flagMenu_ehIds), []
        ]);

        uiNamespace setVariable [
            QGVAR(flagMenu_controls), nil
        ];
        uiNamespace setVariable [
            QGVAR(flagMenu_ehIds), nil
        ];
        uiNamespace setVariable [
            QGVAR(flagMenu_rebuild), nil
        ];
    }
];

nil
