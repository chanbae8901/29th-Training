#include "script_component.hpp"
#include "readyui_defines.hpp"

/*
 * Author: PFC Wells [29th ID]
 * Sword shine effect — diagonal gleam sweeps across the ready UI panel.
 * Built from SHINE_SLICES horizontal strips, each offset by SHINE_STAGGER
 * to form a diagonal band of light (upper-left to lower-right angle).
 * Each slice is clipped to the panel bounds so nothing leaks outside.
 *
 * Arguments:
 * 0: Flash color RGBA <ARRAY> (default: [0.91, 0.78, 0.25, 0.8])
 *
 * Return Value:
 * None
 *
 * Example:
 * [[0.35, 0.61, 0.84, 0.8]] call TN_round_fnc_flashReadyUI;
 */

params [["_flashColor", [0.91, 0.78, 0.25, 0.8]]];

private _bg = uiNamespace getVariable [QGVAR(readyUI_bg), controlNull];
private _shineSlices = uiNamespace getVariable [QGVAR(readyUI_shineSlices), []];
if (
    isNull _bg || _shineSlices isEqualTo []
) exitWith {};

// Don't flash if panel isn't visible (round is live, etc.)
if !(ctrlShown _bg) exitWith {};

// Cancel any in-progress shine animation
if !(isNil QGVAR(readyUI_shinePFH)) then {
    [GVAR(readyUI_shinePFH)] call CBA_fnc_removePerFrameHandler;
    GVAR(readyUI_shinePFH) = nil;
};

uiNamespace setVariable [QGVAR(readyUI_flashActive), true];

// Get current panel bounds
private _bgPos = ctrlPosition _bg;
_bgPos params [
    "_panelX", "_panelY", "_panelW", "_panelH"
];

private _sliceH = _panelH / SHINE_SLICES;
// Total distance each slice must travel (enough for the most-offset slice to clear the panel)
private _maxOffset = (SHINE_SLICES - 1) * SHINE_STAGGER;
private _totalTravel = SHINE_WIDTH + _panelW + _maxOffset;
private _startTime = diag_tickTime;
_flashColor params ["_fr", "_fg", "_fb", "_fa"];

// Initially hide all slices (PFH will show them as they enter the panel)
{
    _x ctrlShow false;
    _x ctrlCommit 0;
} forEach _shineSlices;

// Per-frame animation: sweep the diagonal band across the panel
GVAR(readyUI_shinePFH) = [ {
        params ["_args", "_pfhHandle"];
        _args params [
            "_shineSlices",
            "_panelX", "_panelY",
            "_panelW", "_panelH",
            "_sliceH", "_totalTravel",
            "_startTime",
            "_fr", "_fg", "_fb", "_fa"
        ];

        private _elapsed = diag_tickTime - _startTime;
        private _progress = (_elapsed / SHINE_DURATION) min 1;

        {
            private _i = _forEachIndex;
            private _sliceY = _panelY + (_i * _sliceH);

            // Each lower slice starts further left — creates the diagonal angle
            private _idealX =
                (_panelX - SHINE_WIDTH)
                - (_i * SHINE_STAGGER)
                + (_totalTravel * _progress);

            // Clip to panel bounds so nothing leaks outside the box
            private _leftEdge = _idealX max _panelX;
            private _rightEdge = (_idealX + SHINE_WIDTH) min (_panelX + _panelW);
            private _visW = _rightEdge - _leftEdge;

            if (_visW > 0) then {
                _x ctrlSetPosition [
                    _leftEdge, _sliceY,
                    _visW, _sliceH
                ];
                _x ctrlSetBackgroundColor [
                    _fr, _fg, _fb, _fa
                ];
                _x ctrlShow true;
            } else {
                _x ctrlShow false;
            };
            _x ctrlCommit 0;
        } forEach _shineSlices;

        // Animation complete — hide all slices and clean up
        if (_progress >= 1) then {
            {
                _x ctrlShow false;
                _x ctrlCommit 0;
            } forEach _shineSlices;
            uiNamespace setVariable [QGVAR(readyUI_flashActive), false];
            GVAR(readyUI_shinePFH) = nil;
            [_pfhHandle] call CBA_fnc_removePerFrameHandler;
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

nil
