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
 * Uses createDialog (TN_RscDisplayEventMenu, IDD 29140)
 * which overlays on display 46 -- readyUI stays visible.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_gui_eventMenu;
 */

#define COLOR_NEUTRAL [0.75, 0.25, 1, 1]
#define COLOR_BLUFOR  [0.08, 0.36, 0.99, 1]
#define COLOR_OPFOR   [0.70, 0.02, 0.02, 1]
#define COLOR_GRNFOR  [0.03, 0.54, 0.03, 1]
#define COLOR_BG      [0, 0, 0, 0.8]

if !(isNull (findDisplay 29140)) exitWith {};

createDialog "TN_RscDisplayEventMenu";
private _display = findDisplay 29140;
if (isNull _display) exitWith {};

if (isNil QFUNC(closeEventMenu)) then {
    FUNC(closeEventMenu) = {
        private _dlg = findDisplay 29140;
        if !(isNull _dlg) then { _dlg closeDisplay 2 };
    };
};

private _fnc_buildActions = {
    private _actions = [];

    private _fnc_add = {
        params ["_label", "_code", "_color", ["_sideVar", sideUnknown]];
        _actions pushBack [_label, _code, _color, _sideVar];
    };

    private _fnc_appendEndings = {
        [
            "Neutral Ending",
            { [] call FUNC(game) },
            COLOR_NEUTRAL
        ] call _fnc_add;

        private _allPlayers = call BIS_fnc_listPlayers;
        private _sides = [
            [west,       "BLUFOR", COLOR_BLUFOR],
            [east,       "OPFOR",  COLOR_OPFOR],
            [resistance, "GRNFOR", COLOR_GRNFOR]
        ];

        {
            _x params ["_side", "_sideName", "_sideColor"];

            if (_allPlayers findIf
                {side group _x isEqualTo _side} isNotEqualTo -1) then {
                [
                    _sideName + " Victory",
                    {
                        params ["_ctrl"];
                        private _side = _ctrl getVariable QGVAR(side);
                        [_side] call FUNC(game);
                    },
                    _sideColor,
                    _side
                ] call _fnc_add;
            };
        } forEach _sides;
    };

    if (GVAR(hasTimer)) then {
        switch (EGVAR(round,state)) do {
            case 0: {
                [
                    "Begin Safe Start",
                    {
                        [GVAR(forcedSafeStart), true]
                            call EFUNC(round,initSafeStart);
                    },
                    COLOR_NEUTRAL
                ] call _fnc_add;
            };

            case 1: {
                [
                    "Cancel Safestart",
                    {
                        [0] call EFUNC(round,changeForcedSafeStart);
                        if (call EFUNC(round,checkAllSidesReady)) then {
                            {
                                [_x, false] call EFUNC(round,manageReady);
                            } forEach [west, east, resistance];
                            systemChat "Unreadied all sides!";
                        };
                    },
                    COLOR_NEUTRAL
                ] call _fnc_add;

                [
                    "Change Safestart Time",
                    {
                        [
                            "New Safe Start Time:",
                            "<t color='#ffffff' size='2.5'>Safe Start Time changed to %1!</t>",
                            { NOT_ROUND_SAFE }
                        ] call FUNC(gui_setTime);
                    },
                    COLOR_NEUTRAL
                ] call _fnc_add;

                [
                    "Force Live",
                    { [GVAR(timerLength)] call EFUNC(round,start) },
                    COLOR_NEUTRAL
                ] call _fnc_add;
            };

            case 2: {
                [
                    "Change Round Time",
                    {
                        [
                            "New Round Time:",
                            "<t color='#ffffff' size='2.5'>Round Time changed to %1!</t>",
                            { NOT_ROUND_LIVE }
                        ] call FUNC(gui_setTime);
                    },
                    COLOR_NEUTRAL
                ] call _fnc_add;

                call _fnc_appendEndings;
            };
        };
    } else {
        call _fnc_appendEndings;
    };

    _actions
};

private _fnc_render = {
    params ["_display", "_actions"];

    private _oldControls = uiNamespace getVariable [
        QGVAR(eventMenu_controls), []
    ];
    { ctrlDelete _x } forEach _oldControls;

    if (_actions isEqualTo []) exitWith {
        systemChat "Event Menu: no actions currently available.";
        call FUNC(closeEventMenu);
    };

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

    private _bg = _display ctrlCreate ["RscText", -1];
    _bg ctrlSetPosition [_startX, _startY, _totalW, _totalH];
    _bg ctrlSetBackgroundColor COLOR_BG;
    _bg ctrlCommit 0;
    _controls pushBack _bg;

    private _title = _display ctrlCreate ["RscStructuredText", -1];
    _title ctrlSetPosition [
        _startX + _padding, _startY + _padding, _btnW, _titleH
    ];
    _title ctrlSetStructuredText parseText
        "<t color='#bf3eff' align='center' size='1.1'>Event Menu</t>";
    _title ctrlCommit 0;
    _controls pushBack _title;

    private _yPos = _startY + _padding + _titleH + _padding;

    {
        _x params ["_label", "_code", "_color", "_sideVar"];

        private _btn = _display ctrlCreate ["RscButton", -1];
        _btn ctrlSetText _label;
        _btn ctrlSetPosition [
            _startX + _padding, _yPos, _btnW, _btnH
        ];
        _btn ctrlSetBackgroundColor _color;
        _btn setVariable [QGVAR(clickCode), _code];
        if (_sideVar isNotEqualTo sideUnknown) then {
            _btn setVariable [QGVAR(side), _sideVar];
        };
        _btn ctrlCommit 0;
        _btn ctrlAddEventHandler ["ButtonClick", {
            params ["_ctrl"];
            [_ctrl] call (_ctrl getVariable QGVAR(clickCode));
            call FUNC(closeEventMenu);
        }];
        _controls pushBack _btn;

        _yPos = _yPos + _btnH + _gap;
    } forEach _actions;

    uiNamespace setVariable [QGVAR(eventMenu_controls), _controls];
};

private _fnc_rebuild = {
    params ["_display"];
    [_display, call _fnc_buildActions] call _fnc_render;
};

uiNamespace setVariable [QGVAR(eventMenu_rebuild), _fnc_rebuild];

[_display] call _fnc_rebuild;

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
            [_dlg] call (uiNamespace getVariable QGVAR(eventMenu_rebuild));
        };
    }] call CBA_fnc_addEventHandler;
    _ehIds pushBack [_x, _id];
} forEach _stateEvents;

uiNamespace setVariable [QGVAR(eventMenu_ehIds), _ehIds];

_display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key"];
    if (_key isEqualTo 1) then {
        call FUNC(closeEventMenu);
        true
    } else {
        false
    };
}];

_display displayAddEventHandler ["Unload", {
    {
        _x call CBA_fnc_removeEventHandler;
    } forEach (uiNamespace getVariable [QGVAR(eventMenu_ehIds), []]);

    uiNamespace setVariable [QGVAR(eventMenu_controls), nil];
    uiNamespace setVariable [QGVAR(eventMenu_ehIds), nil];
    uiNamespace setVariable [QGVAR(eventMenu_rebuild), nil];
}];

nil
