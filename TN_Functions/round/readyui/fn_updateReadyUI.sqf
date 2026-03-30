#include "script_component.hpp"
#include "readyui_defines.hpp"
#include "..\..\..\data\roundState.hpp"

/*
 * Author: PFC Wells [29th ID]
 * Main update function for the ready UI panel, called by PFH.
 * Three-phase structure: (A) display check, (B) content rebuild, (C) pulse animation.
 * Phase B only runs when dirty flag is set — avoids rebuilding text every frame.
 *
 * Arguments:
 * None (reads global state)
 *
 * Return Value:
 * None
 *
 * Example:
 * call TN_round_fnc_updateReadyUI;
 */

// === Phase A: Display transition (Zeus enter/exit) ===
// If the active display changed, destroy old controls so they rebuild below.
private _activeDisplay =
    call FUNC(getActiveDisplay);
private _createdOn = uiNamespace getVariable [
    QGVAR(readyUI_display), displayNull
];
if (
    !isNull _createdOn
    && {_activeDisplay isNotEqualTo _createdOn}
) then {
    private _oldBg = uiNamespace getVariable [
        QGVAR(readyUI_bg), controlNull
    ];
    private _oldContent = uiNamespace getVariable [
        QGVAR(readyUI_content), controlNull
    ];
    if !(isNull _oldBg) then { ctrlDelete _oldBg };
    if !(isNull _oldContent) then {
        ctrlDelete _oldContent;
    };
    {
        if !(isNull _x) then { ctrlDelete _x };
    } forEach (uiNamespace getVariable [
        QGVAR(readyUI_shineSlices), []
    ]);
    uiNamespace setVariable [
        QGVAR(readyUI_bg), controlNull
    ];
    uiNamespace setVariable [
        QGVAR(readyUI_content), controlNull
    ];
    uiNamespace setVariable [
        QGVAR(readyUI_shineSlices), []
    ];
    uiNamespace setVariable [
        QGVAR(readyUI_display), displayNull
    ];
    // Kill in-flight shine — those slices no longer exist
    if !(isNil QGVAR(readyUI_shinePFH)) then {
        [GVAR(readyUI_shinePFH)]
            call CBA_fnc_removePerFrameHandler;
        GVAR(readyUI_shinePFH) = nil;
    };
    uiNamespace setVariable [
        QGVAR(readyUI_flashActive), false
    ];
    GVAR(readyUI_dirty) = true;
};

private _bg = uiNamespace getVariable [
    QGVAR(readyUI_bg), controlNull
];
private _content = uiNamespace getVariable [
    QGVAR(readyUI_content), controlNull
];

// Recreate controls if destroyed (display transitions, respawn, etc.)
if (isNull _bg || isNull _content) then {
    if !(call FUNC(createReadyUIControls))
        exitWith {};
    _bg = uiNamespace getVariable QGVAR(readyUI_bg);
    _content = uiNamespace getVariable
        QGVAR(readyUI_content);
    GVAR(readyUI_dirty) = true;
};

// Guard: sideReady array must exist (JIP race condition / init order)
if (isNil QGVAR(sideReady)) exitWith {
    _bg ctrlShow false;
    _content ctrlShow false;
};

private _isSafeStart = ROUND_SAFE;

// Safety net: hide if PFH is somehow still running when panel shouldn't show.
// Primary lifecycle control is via external event handlers.
if (
    !(_isSafeStart || {true in GVAR(sideReady)}) || ROUND_LIVE
) exitWith {
    _bg ctrlShow false;
    _content ctrlShow false;
    {
        _x ctrlShow false;
    } forEach (uiNamespace getVariable [
        QGVAR(readyUI_shineSlices), []
    ]);
    uiNamespace setVariable [
        QGVAR(readyUI_flashActive), false
    ];
    if !(isNil QGVAR(readyUI_shinePFH)) then {
        [GVAR(readyUI_shinePFH)]
            call CBA_fnc_removePerFrameHandler;
        GVAR(readyUI_shinePFH) = nil;
    };
};

// Periodic refresh — catches player count changes (join/leave/side switch)
// Every ~60 frames (~2s at 30fps) mark dirty to recheck team populations
GVAR(readyUI_refreshCounter) =
    (GVAR(readyUI_refreshCounter) + 1) mod 60;
if (GVAR(readyUI_refreshCounter) isEqualTo 0) then {
    GVAR(readyUI_dirty) = true;
};

// === Phase B: Content rebuild (only when dirty) ===
if (GVAR(readyUI_dirty)) then {
    GVAR(readyUI_dirty) = false;

    private _lines = [];

    if (ROUND_SAFE) then {
        private _remaining = ceil ([0] call BIS_fnc_countdown) max 0;
        private _timerStr = [_remaining, "MM:SS"] call BIS_fnc_secondsToString;
        _lines pushBack format [
            "<t color='#E8C840' size='0.9' align='center' shadow='1'>SAFE START - %1</t>",
            _timerStr
        ];
    };

    {
        _x params [
            "_side", "_idx", "_name", "_color"
        ];
        if (
            _side countSide allPlayers isEqualTo 0
            && {isNil QGVAR(readyUI_showAllSides)}
        ) then { continue };

        // Bounds check sideReady array before accessing
        if (_idx >= count GVAR(sideReady)) then {
            continue;
        };

        private _ready =
            GVAR(sideReady) select _idx;
        private _status = if (_ready) then {
            "<t color='#8BC34A' size='0.85' align='right'>READY</t>"
        } else {
            "<t color='#C8A030' size='0.85' align='right'>READY UP</t>"
        };

        _lines pushBack format [
            "<t color='%1' size='0.85' shadow='1' align='left'>%2</t>%3",
            _color, _name, _status
        ];
    } forEach SIDE_DEFS;

    // Nothing to show (no players on any side)
    if (_lines isEqualTo []) then {
        _bg ctrlShow false;
        _content ctrlShow false;
    } else {
        _content ctrlSetStructuredText
            parseText (_lines joinString "<br/>");

        // Dynamic height based on line count
        private _totalHeight =
            (count _lines * LINE_HEIGHT)
            + (PADDING * 2);

        // Center horizontally when in Zeus, otherwise anchor to MP HUD
        private _posX = if (
            !isNull findDisplay 312
        ) then {
            safeZoneX + (safeZoneW / 2)
                - (UI_WIDTH / 2)
        } else {
            UI_X
        };

        _bg ctrlSetPosition [
            _posX, UI_Y, UI_WIDTH, _totalHeight
        ];
        _bg ctrlCommit 0;

        _content ctrlSetPosition [
            _posX + CONTENT_INSET,
            UI_Y + PADDING,
            UI_WIDTH - (CONTENT_INSET * 2),
            _totalHeight - (PADDING * 2)
        ];
        _content ctrlCommit 0;

        _bg ctrlShow true;
        _content ctrlShow true;
    };
};

// === Phase C: Pulse animation (every frame, cheap math) ===
// Skip if panel isn't visible (no-lines edge case, or Phase B hid controls)
if !(ctrlShown _bg) exitWith {};

private _flashActive = uiNamespace getVariable [
    QGVAR(readyUI_flashActive), false
];

// Flash overrides pulse — don't touch background color while shine is active
if (!_flashActive) then {
    if (ROUND_SAFE) then {
        // Collect pulse tint colors from unready teams with players
        private _unreadyTints = [];
        {
            _x params [
                "_side", "_idx", "", "", "_pulseTint"
            ];
            if (
                _side countSide allPlayers > 0
                || {!(isNil QGVAR(readyUI_showAllSides))}
            ) then {
                if (
                    _idx < count GVAR(sideReady)
                ) then {
                    if !(
                        GVAR(sideReady) select _idx
                    ) then {
                        _unreadyTints pushBack
                            _pulseTint;
                    };
                };
            };
        } forEach SIDE_DEFS;

        if (_unreadyTints isNotEqualTo []) then {
            // Cycle through unready teams — each gets one full breath
            private _cycleIdx =
                floor(diag_tickTime / PULSE_CYCLE)
                mod count _unreadyTints;
            private _tint =
                _unreadyTints select _cycleIdx;

            // Breathing intensity (sine wave)
            private _t = 0.5 + 0.5 * sin (
                diag_tickTime * PULSE_SPEED
                * 180 / 3.14159
            );
            private _r = BG_R
                + ((_tint select 0) - BG_R) * _t;
            private _g = BG_G
                + ((_tint select 1) - BG_G) * _t;
            private _b = BG_B
                + ((_tint select 2) - BG_B) * _t;
            private _a = PULSE_A_MIN
                + (PULSE_A_MAX - PULSE_A_MIN) * _t;
            _bg ctrlSetBackgroundColor [
                _r, _g, _b, _a
            ];
            _bg ctrlCommit 0;
        } else {
            // All teams ready — static gold bg
            _bg ctrlSetBackgroundColor BG_COLOR;
            _bg ctrlCommit 0;
        };
    } else {
        _bg ctrlSetBackgroundColor BG_COLOR;
        _bg ctrlCommit 0;
    };
};

nil
