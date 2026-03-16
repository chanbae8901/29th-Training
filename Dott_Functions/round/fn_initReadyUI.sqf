#include "defines.hpp"

/*
 * Name:    TN_round_fnc_initReadyUI
 * Date:    03/06/2026
 * Version: 1.0
 * Author:  PFC Wells [29th ID] being nagged at by Bae [29th ID]
 *
 * Description:
 * Creates a top-right HUD overlay showing team ready status during safe start.
 * Anchored to the vanilla MP HUD position (IGUI_GRID_MP layout editor slot) so
 * it sits beside the scoreboard / mission-status area and respects the player's
 * UI layout preferences. Resolution-adaptive via aspect-ratio grid (GRID_W/H).
 *
 * Panel visibility logic:
 *   Shown  — safe start is active OR at least one team is ready
 *   Hidden — round goes live, or neither condition is met
 *   Event-driven PFH lifecycle: the update loop only runs when the panel is
 *   needed. CBA event handlers start/stop the PFH externally — it never
 *   removes itself. Start triggers: safeStartBegin, manageReadyChange (ready).
 *   Stop triggers: round_started (unconditional), manageReadyChange (unready,
 *   when no teams ready + no safe start), safeStartAborted (no teams ready).
 *   Zeus-aware: controls migrate between display 46 (game) and display 312
 *   (Curator) automatically so the overlay stays visible inside Zeus.
 *
 * Layout:
 *   "SAFE START" header (gold, centered) when TN_round_safeStartActive exists
 *   Per-team row: side name (team color, left) + status (right)
 *     - "READY"    (#8BC34A green)  — team has readied
 *     - "READY UP" (#C8A030 amber)  — team still needs to ready
 *   Teams with zero players are hidden unless TN_readyUI_showAllSides is set.
 *
 * Effects:
 *   Pulse — 2s breathing cycle during safe start. Cycles through unready teams;
 *           each team's pulse tint (SIDE_DEFS index 4) is blended over the dark
 *           gold background via a sine wave. When all teams ready, static gold.
 *   Shine — diagonal sword-shine sweep (upper-left → lower-right) when a team
 *           readies up, drawn in that team's flash color (SIDE_DEFS index 5).
 *           Built from 29 horizontal slices staggered by SHINE_STAGGER to form
 *           a diagonal band. Each slice is clipped to panel bounds. Driven by a
 *           CBA per-frame handler for smooth frame-accurate animation.
 *
 * Globals written:
 *   TN_readyUI_initialized      — recompile sentinel
 *   TN_readyUI_pfhHandle        — PFH handle (update loop)
 *   TN_readyUI_shinePFH         — PFH handle (shine animation, transient)
 *   TN_readyUI_dirty            — content rebuild flag (text caching)
 *   TN_readyUI_refreshCounter   — periodic refresh counter (~2s cycle)
 *   TN_readyUI_ehReady          — CBA EH handle (TN_round_manageReadyChange)
 *   TN_readyUI_ehSafeStart      — CBA EH handle (TN_round_safeStartBegin)
 *   TN_readyUI_ehAborted        — CBA EH handle (TN_round_safeStartAborted)
 *   TN_readyUI_ehStarted        — CBA EH handle (TN_round_started)
 *   uiNamespace: TN_readyUI_bg, TN_readyUI_content,
 *                TN_readyUI_shineSlices, TN_readyUI_display,
 *                TN_readyUI_flashActive
 *
 * Dependencies:
 *   CBA_fnc_addPerFrameHandler, CBA_fnc_removePerFrameHandler,
 *   CBA_fnc_addEventHandler, CBA_fnc_removeEventHandler
 *   TN_round_sideReady (array — set by fn_init / fn_manageReady)
 *   TN_round_fnc_isRoundActive
 *
 * Logging:
 *   All status messages go to RPT via diag_log (no systemChat).
 *
 * Client-side only. Recompile-friendly: calling again tears down the old
 * instance automatically (PFHs, EHs, controls), so you can tweak #define
 * values and recompile without running any cleanup commands first.
 *
 * Parameter(s):
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call TN_round_fnc_initReadyUI;
 *
 * Hot-reload (debug console one-liner):
 * call compile preprocessFileLineNumbers "round\fn_initReadyUI.sqf";
 *
 */

if (!hasInterface) exitWith {};

// --- Recompile teardown: clean up previous instance before reinitializing ---
if !(isNil "TN_readyUI_initialized") then
{
    if !(isNil "TN_readyUI_pfhHandle") then
    {
        [TN_readyUI_pfhHandle]
            call CBA_fnc_removePerFrameHandler;
        TN_readyUI_pfhHandle = nil;
    };
    if !(isNil "TN_readyUI_shinePFH") then
    {
        [TN_readyUI_shinePFH]
            call CBA_fnc_removePerFrameHandler;
        TN_readyUI_shinePFH = nil;
    };

    if !(isNil "TN_readyUI_ehReady") then
    {
        [
            "TN_round_manageReadyChange",
            TN_readyUI_ehReady
        ] call CBA_fnc_removeEventHandler;
        TN_readyUI_ehReady = nil;
    };
    if !(isNil "TN_readyUI_ehSafeStart") then
    {
        [
            "TN_round_safeStartBegin",
            TN_readyUI_ehSafeStart
        ] call CBA_fnc_removeEventHandler;
        TN_readyUI_ehSafeStart = nil;
    };
    if !(isNil "TN_readyUI_ehAborted") then
    {
        [
            "TN_round_safeStartAborted",
            TN_readyUI_ehAborted
        ] call CBA_fnc_removeEventHandler;
        TN_readyUI_ehAborted = nil;
    };
    if !(isNil "TN_readyUI_ehStarted") then
    {
        [
            "TN_round_started",
            TN_readyUI_ehStarted
        ] call CBA_fnc_removeEventHandler;
        TN_readyUI_ehStarted = nil;
    };

    private _oldBg = uiNamespace getVariable [
        "TN_readyUI_bg", controlNull
    ];
    private _oldContent = uiNamespace getVariable [
        "TN_readyUI_content", controlNull
    ];
    if !(isNull _oldBg) then { ctrlDelete _oldBg };
    if !(isNull _oldContent) then { ctrlDelete _oldContent };
    {
        if !(isNull _x) then { ctrlDelete _x };
    } forEach (uiNamespace getVariable [
        "TN_readyUI_shineSlices", []
    ]);

    uiNamespace setVariable ["TN_readyUI_bg", nil];
    uiNamespace setVariable ["TN_readyUI_content", nil];
    uiNamespace setVariable ["TN_readyUI_shineSlices", nil];
    uiNamespace setVariable ["TN_readyUI_display", nil];
    uiNamespace setVariable ["TN_readyUI_flashActive", nil];

    TN_readyUI_dirty = nil;
    TN_readyUI_refreshCounter = nil;

    diag_log "[ReadyUI] Teardown complete — reinitializing...";
};

TN_readyUI_initialized = true;

// Side definitions: [side, sideReady index, display name, hex color, pulse tint RGB, flash RGBA]
// Text colors matched to 29th ID forum theme
// Pulse tint = subtle version breathed toward during safe start when that team is unready
// Flash color = bright pop when that specific team readies up
#define SIDE_DEFS [ \
    [west, 1, "BLUFOR", "#5B9BD5", [0.10, 0.16, 0.25], [0.35, 0.61, 0.84, 0.8]], \
    [east, 0, "OPFOR", "#D9634A", [0.25, 0.10, 0.08], [0.85, 0.39, 0.29, 0.8]], \
    [resistance, 2, "GRNFOR", "#6BBF59", [0.10, 0.22, 0.09], [0.42, 0.75, 0.35, 0.8]] \
]

// Aspect-ratio grid matching vanilla HUD (RscMPProgress / RscMissionStatus)
// Scales consistently across all resolutions and interface sizes
#define GRID_W (((safezoneW / safezoneH) min 1.2) / 40)
#define GRID_H ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)

// Anchor to vanilla MP HUD position (from RscMissionStatus)
// Respects the player's layout editor settings via profile variables
// Defaults: X = right edge - 2 grid cols, Y = 5 grid rows + safezoneY
#define MP_ANCHOR_X (profileNamespace getVariable ["IGUI_GRID_MP_X", (safeZoneX + safeZoneW - 2 * GRID_W)])
#define MP_ANCHOR_Y (profileNamespace getVariable ["IGUI_GRID_MP_Y", (5 * GRID_H + safeZoneY)])

// UI positioning relative to MP HUD anchor — tweak multipliers to adjust
#define UI_WIDTH (10 * GRID_W)
#define UI_GAP (0.5 * GRID_W)
#define UI_X (MP_ANCHOR_X - UI_WIDTH - UI_GAP)
#define UI_Y MP_ANCHOR_Y
#define LINE_HEIGHT (1 * GRID_H)
#define PADDING (0.3 * GRID_H)
#define CONTENT_INSET (0.4 * GRID_W)

// Background color — 29th ID gold (always)
#define BG_COLOR [0.067, 0.059, 0.039, 0.75]
#define BG_R 0.067
#define BG_G 0.059
#define BG_B 0.039

// Pulse timing
#define PULSE_SPEED 3.14159
#define PULSE_A_MIN 0.65
#define PULSE_A_MAX 0.80
#define PULSE_CYCLE 2
// Sword shine — diagonal gleam built from horizontal slices
#define SHINE_WIDTH (1.5 * GRID_W)
#define SHINE_DURATION 0.45
// 29 slices because I don't know 20 is already fine but 29 is the unit name so fml
// 69 68 61 74 65 79 6F 75 62 61 65 77 68 79 64 69 64 79 6F 75 6D 61 6B 65 6D 65 64 6F 74 68 69 73
#define SHINE_SLICES 29
#define SHINE_STAGGER (1.0 * GRID_W)

// Returns whichever display is on top — Zeus (312) if open, otherwise game (46).
// Controls must live on the topmost display or they render behind it.
TN_round_fnc_getActiveDisplay =
{
    private _zeus = findDisplay 312;
    if (!isNull _zeus) exitWith {_zeus};
    findDisplay 46
};

// Creates or recreates UI controls on the active display (game or Zeus)
TN_round_fnc_createReadyUIControls =
{
    private _display = call TN_round_fnc_getActiveDisplay;
    if (isNull _display) exitWith {false};

    private _bg = _display ctrlCreate ["RscText", -1];
    _bg ctrlSetBackgroundColor BG_COLOR;
    _bg ctrlShow false;
    _bg ctrlCommit 0;

    private _content =
        _display ctrlCreate ["RscStructuredText", -1];
    _content ctrlShow false;
    _content ctrlCommit 0;

    // Diagonal shine slices — stacked horizontal strips that sweep with offset
    private _shineSlices = [];
    for "_i" from 0 to (SHINE_SLICES - 1) do
    {
        private _slice =
            _display ctrlCreate ["RscText", -1];
        _slice ctrlShow false;
        _slice ctrlCommit 0;
        _shineSlices pushBack _slice;
    };

    uiNamespace setVariable [
        "TN_readyUI_bg", _bg
    ];
    uiNamespace setVariable [
        "TN_readyUI_content", _content
    ];
    uiNamespace setVariable [
        "TN_readyUI_shineSlices", _shineSlices
    ];
    uiNamespace setVariable [
        "TN_readyUI_display", _display
    ];
    uiNamespace setVariable [
        "TN_readyUI_flashActive", false
    ];
    true
};

// Starts the update PFH if it isn't already running.
// Called from event handlers when conditions might require the panel.
TN_round_fnc_startReadyUIPFH =
{
    if !(isNil "TN_readyUI_pfhHandle") exitWith {};
    TN_readyUI_dirty = true;
    TN_readyUI_refreshCounter = 0;
    TN_readyUI_pfhHandle = [
        {call TN_round_fnc_updateReadyUI}, 0
    ] call CBA_fnc_addPerFrameHandler;
};

// Stops the update PFH and hides all controls.
// Called EXTERNALLY by event handlers — never from within the PFH itself.
TN_round_fnc_stopReadyUIPFH =
{
    if (isNil "TN_readyUI_pfhHandle") exitWith {};
    [TN_readyUI_pfhHandle]
        call CBA_fnc_removePerFrameHandler;
    TN_readyUI_pfhHandle = nil;

    // Hide controls
    private _bg = uiNamespace getVariable [
        "TN_readyUI_bg", controlNull
    ];
    private _content = uiNamespace getVariable [
        "TN_readyUI_content", controlNull
    ];
    if !(isNull _bg) then { _bg ctrlShow false };
    if !(isNull _content) then { _content ctrlShow false };
    {
        _x ctrlShow false;
    } forEach (uiNamespace getVariable [
        "TN_readyUI_shineSlices", []
    ]);
    uiNamespace setVariable [
        "TN_readyUI_flashActive", false
    ];

    // Kill in-flight shine animation
    if !(isNil "TN_readyUI_shinePFH") then
    {
        [TN_readyUI_shinePFH]
            call CBA_fnc_removePerFrameHandler;
        TN_readyUI_shinePFH = nil;
    };
};

// Main update function, called by PFH.
// Three-phase structure: (A) display check, (B) content rebuild, (C) pulse animation.
// Phase B only runs when dirty flag is set — avoids rebuilding text every frame.
TN_round_fnc_updateReadyUI =
{
    // === Phase A: Display transition (Zeus enter/exit) ===
    // If the active display changed, destroy old controls so they rebuild below.
    private _activeDisplay =
        call TN_round_fnc_getActiveDisplay;
    private _createdOn = uiNamespace getVariable [
        "TN_readyUI_display", displayNull
    ];
    if (
        !isNull _createdOn
        && {!(_activeDisplay isEqualTo _createdOn)}
    ) then
    {
        private _oldBg = uiNamespace getVariable [
            "TN_readyUI_bg", controlNull
        ];
        private _oldContent = uiNamespace getVariable [
            "TN_readyUI_content", controlNull
        ];
        if !(isNull _oldBg) then { ctrlDelete _oldBg };
        if !(isNull _oldContent) then
        {
            ctrlDelete _oldContent;
        };
        {
            if !(isNull _x) then { ctrlDelete _x };
        } forEach (uiNamespace getVariable [
            "TN_readyUI_shineSlices", []
        ]);
        uiNamespace setVariable [
            "TN_readyUI_bg", controlNull
        ];
        uiNamespace setVariable [
            "TN_readyUI_content", controlNull
        ];
        uiNamespace setVariable [
            "TN_readyUI_shineSlices", []
        ];
        uiNamespace setVariable [
            "TN_readyUI_display", displayNull
        ];
        // Kill in-flight shine — those slices no longer exist
        if !(isNil "TN_readyUI_shinePFH") then
        {
            [TN_readyUI_shinePFH]
                call CBA_fnc_removePerFrameHandler;
            TN_readyUI_shinePFH = nil;
        };
        uiNamespace setVariable [
            "TN_readyUI_flashActive", false
        ];
        TN_readyUI_dirty = true;
    };

    private _bg = uiNamespace getVariable [
        "TN_readyUI_bg", controlNull
    ];
    private _content = uiNamespace getVariable [
        "TN_readyUI_content", controlNull
    ];

    // Recreate controls if destroyed (display transitions, respawn, etc.)
    if (isNull _bg || isNull _content) then
    {
        if !(call TN_round_fnc_createReadyUIControls)
            exitWith {};
        _bg = uiNamespace getVariable "TN_readyUI_bg";
        _content = uiNamespace getVariable
            "TN_readyUI_content";
        TN_readyUI_dirty = true;
    };

    // Guard: sideReady array must exist (JIP race condition / init order)
    if (isNil "TN_round_sideReady") exitWith
    {
        _bg ctrlShow false;
        _content ctrlShow false;
    };

    private _isSafeStart =
        TN_round_safeStartActive;
    private _anyReady =
        ({_x} count TN_round_sideReady) > 0;
    private _isRoundActive =
        call TN_round_fnc_isRoundActive;

    // Safety net: hide if PFH is somehow still running when panel shouldn't show.
    // Primary lifecycle control is via external event handlers.
    if (
        !(_isSafeStart || _anyReady) || _isRoundActive
    ) exitWith
    {
        _bg ctrlShow false;
        _content ctrlShow false;
        {
            _x ctrlShow false;
        } forEach (uiNamespace getVariable [
            "TN_readyUI_shineSlices", []
        ]);
        uiNamespace setVariable [
            "TN_readyUI_flashActive", false
        ];
        if !(isNil "TN_readyUI_shinePFH") then
        {
            [TN_readyUI_shinePFH]
                call CBA_fnc_removePerFrameHandler;
            TN_readyUI_shinePFH = nil;
        };
    };

    // Periodic refresh — catches player count changes (join/leave/side switch)
    // Every ~60 frames (~2s at 30fps) mark dirty to recheck team populations
    TN_readyUI_refreshCounter =
        (TN_readyUI_refreshCounter + 1) mod 60;
    if (TN_readyUI_refreshCounter == 0) then
    {
        TN_readyUI_dirty = true;
    };

    // === Phase B: Content rebuild (only when dirty) ===
    if (TN_readyUI_dirty) then
    {
        TN_readyUI_dirty = false;

        private _lines = [];

        if (_isSafeStart) then
        {
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
                _side countSide allPlayers == 0
                && {isNil "TN_readyUI_showAllSides"}
            ) then { continue };

            // Bounds check sideReady array before accessing
            if (_idx >= count TN_round_sideReady) then
            {
                continue;
            };

            private _ready =
                TN_round_sideReady select _idx;
            private _status = if (_ready) then
            {
                "<t color='#8BC34A' size='0.85' align='right'>READY</t>"
            }
            else
            {
                "<t color='#C8A030' size='0.85' align='right'>READY UP</t>"
            };

            _lines pushBack format [
                "<t color='%1' size='0.85' shadow='1' align='left'>%2</t>%3",
                _color, _name, _status
            ];
        } forEach SIDE_DEFS;

        // Nothing to show (no players on any side)
        if (count _lines == 0) then
        {
            _bg ctrlShow false;
            _content ctrlShow false;
        }
        else
        {
            _content ctrlSetStructuredText
                parseText (_lines joinString "<br/>");

            // Dynamic height based on line count
            private _totalHeight =
                (count _lines * LINE_HEIGHT)
                + (PADDING * 2);

            // Center horizontally when in Zeus, otherwise anchor to MP HUD
            private _posX = if (
                !isNull findDisplay 312
            ) then
            {
                safeZoneX + (safeZoneW / 2)
                    - (UI_WIDTH / 2)
            }
            else
            {
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
        "TN_readyUI_flashActive", false
    ];

    // Flash overrides pulse — don't touch background color while shine is active
    if (!_flashActive) then
    {
        if (_isSafeStart) then
        {
            // Collect pulse tint colors from unready teams with players
            private _unreadyTints = [];
            {
                _x params [
                    "_side", "_idx", "", "", "_pulseTint"
                ];
                if (
                    _side countSide allPlayers > 0
                    || {!(isNil "TN_readyUI_showAllSides")}
                ) then
                {
                    if (
                        _idx < count TN_round_sideReady
                    ) then
                    {
                        if !(
                            TN_round_sideReady select _idx
                        ) then
                        {
                            _unreadyTints pushBack
                                _pulseTint;
                        };
                    };
                };
            } forEach SIDE_DEFS;

            if (count _unreadyTints > 0) then
            {
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
            }
            else
            {
                // All teams ready — static gold bg
                _bg ctrlSetBackgroundColor BG_COLOR;
                _bg ctrlCommit 0;
            };
        }
        else
        {
            _bg ctrlSetBackgroundColor BG_COLOR;
            _bg ctrlCommit 0;
        };
    };
};

// Sword shine effect — diagonal gleam sweeps across the panel
// Built from SHINE_SLICES horizontal strips, each offset by SHINE_STAGGER
// to form a diagonal band of light (upper-left to lower-right angle).
// Each slice is clipped to the panel bounds so nothing leaks outside.
// Accepts: [flashColorRGBA] — the readied team's bright color
TN_round_fnc_flashReadyUI =
{
    params [["_flashColor", [0.91, 0.78, 0.25, 0.8]]];

    private _bg = uiNamespace getVariable [
        "TN_readyUI_bg", controlNull
    ];
    private _shineSlices = uiNamespace getVariable [
        "TN_readyUI_shineSlices", []
    ];
    if (
        isNull _bg || count _shineSlices == 0
    ) exitWith {};

    // Don't flash if panel isn't visible (round is live, etc.)
    if !(ctrlShown _bg) exitWith {};

    // Cancel any in-progress shine animation
    if !(isNil "TN_readyUI_shinePFH") then
    {
        [TN_readyUI_shinePFH]
            call CBA_fnc_removePerFrameHandler;
        TN_readyUI_shinePFH = nil;
    };

    uiNamespace setVariable [
        "TN_readyUI_flashActive", true
    ];

    // Get current panel bounds
    private _bgPos = ctrlPosition _bg;
    _bgPos params [
        "_panelX", "_panelY", "_panelW", "_panelH"
    ];

    private _sliceH = _panelH / SHINE_SLICES;
    // Total distance each slice must travel (enough for the most-offset slice to clear the panel)
    private _maxOffset =
        (SHINE_SLICES - 1) * SHINE_STAGGER;
    private _totalTravel =
        SHINE_WIDTH + _panelW + _maxOffset;
    private _startTime = diag_tickTime;
    _flashColor params ["_fr", "_fg", "_fb", "_fa"];

    // Initially hide all slices (PFH will show them as they enter the panel)
    {
        _x ctrlShow false;
        _x ctrlCommit 0;
    } forEach _shineSlices;

    // Per-frame animation: sweep the diagonal band across the panel
    TN_readyUI_shinePFH = [
        {
            params ["_args", "_pfhHandle"];
            _args params [
                "_shineSlices",
                "_panelX", "_panelY",
                "_panelW", "_panelH",
                "_sliceH", "_totalTravel",
                "_startTime",
                "_fr", "_fg", "_fb", "_fa"
            ];

            private _elapsed =
                diag_tickTime - _startTime;
            private _progress =
                (_elapsed / SHINE_DURATION) min 1;

            {
                private _i = _forEachIndex;
                private _sliceY =
                    _panelY + (_i * _sliceH);

                // Each lower slice starts further left — creates the diagonal angle
                private _idealX =
                    (_panelX - SHINE_WIDTH)
                    - (_i * SHINE_STAGGER)
                    + (_totalTravel * _progress);

                // Clip to panel bounds so nothing leaks outside the box
                private _leftEdge =
                    _idealX max _panelX;
                private _rightEdge =
                    (_idealX + SHINE_WIDTH)
                    min (_panelX + _panelW);
                private _visW =
                    _rightEdge - _leftEdge;

                if (_visW > 0) then
                {
                    _x ctrlSetPosition [
                        _leftEdge, _sliceY,
                        _visW, _sliceH
                    ];
                    _x ctrlSetBackgroundColor [
                        _fr, _fg, _fb, _fa
                    ];
                    _x ctrlShow true;
                }
                else
                {
                    _x ctrlShow false;
                };
                _x ctrlCommit 0;
            } forEach _shineSlices;

            // Animation complete — hide all slices and clean up
            if (_progress >= 1) then
            {
                {
                    _x ctrlShow false;
                    _x ctrlCommit 0;
                } forEach _shineSlices;
                uiNamespace setVariable [
                    "TN_readyUI_flashActive", false
                ];
                TN_readyUI_shinePFH = nil;
                [_pfhHandle]
                    call CBA_fnc_removePerFrameHandler;
            };
        },
        0,
        [
            _shineSlices,
            _panelX, _panelY,
            _panelW, _panelH,
            _sliceH, _totalTravel,
            _startTime,
            _fr, _fg, _fb, _fa
        ]
    ] call CBA_fnc_addPerFrameHandler;
};

// Wait for game display, then wire event-driven PFH lifecycle
[] spawn
{
    waitUntil {!isNull findDisplay 46};
    sleep 0.1;
    call TN_round_fnc_createReadyUIControls;

    // Only start PFH at init if UI is actually needed right now (JIP into safe start, etc.)
    if (
        TN_round_safeStartActive
        || {
            !(isNil "TN_round_sideReady")
            && {({_x} count TN_round_sideReady) > 0}
        }
    ) then
    {
        call TN_round_fnc_startReadyUIPFH;
    };

    // --- Event handlers drive PFH lifecycle ---

    // Safe start begins -> wake PFH so panel appears
    TN_readyUI_ehSafeStart = [
        "TN_round_safeStartBegin",
        {
            TN_readyUI_dirty = true;
            call TN_round_fnc_startReadyUIPFH;
        }
    ] call CBA_fnc_addEventHandler;

    // Ready state changes -> wake PFH, flash on ready, stop if nothing to show
    TN_readyUI_ehReady = [
        "TN_round_manageReadyChange",
        {
            params ["_side", "_isReady"];
            TN_readyUI_dirty = true;
            call TN_round_fnc_startReadyUIPFH;
            if (_isReady) then
            {
                // Find flash color for the team that just readied (index 5 in SIDE_DEFS)
                private _flashColor = [
                    0.91, 0.78, 0.25, 0.8
                ];
                {
                    if (
                        (_x select 0) isEqualTo _side
                    ) exitWith
                    {
                        _flashColor = _x select 5;
                    };
                } forEach SIDE_DEFS;
                [_flashColor]
                    call TN_round_fnc_flashReadyUI;
            }
            else
            {
                // Team unreadied — if no teams ready and no safe start, stop PFH
                if (
                    !(isNil "TN_round_sideReady")
                    && {
                        ({_x} count
                            TN_round_sideReady) == 0
                    }
                    && {!TN_round_safeStartActive}
                ) then
                {
                    call TN_round_fnc_stopReadyUIPFH;
                };
            };
        }
    ] call CBA_fnc_addEventHandler;

    // Safe start aborted -> stop PFH if no teams are still ready
    TN_readyUI_ehAborted = [
        "TN_round_safeStartAborted",
        {
            TN_readyUI_dirty = true;
            if (
                !(isNil "TN_round_sideReady")
                && {
                    ({_x} count
                        TN_round_sideReady) > 0
                }
            ) then
            {
                // Teams still ready — keep PFH alive to show their status
            }
            else
            {
                call TN_round_fnc_stopReadyUIPFH;
            };
        }
    ] call CBA_fnc_addEventHandler;

    // Round started -> unconditionally stop PFH (fn_start.sqf already unreadies all sides)
    TN_readyUI_ehStarted = [
        "TN_round_started",
        {
            call TN_round_fnc_stopReadyUIPFH;
        }
    ] call CBA_fnc_addEventHandler;
};

true
