#include "script_component.hpp"
#include "readyui_defines.hpp"

/*
 * Author: PFC Wells [29th ID]
 * Creates or recreates UI controls on the active display (game or Zeus).
 * Builds the background panel, structured text content area, and diagonal
 * shine slices, then stores them in uiNamespace for persistence.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * true on success, false if no display available <BOOL>
 *
 * Example:
 * call TN_round_fnc_createReadyUIControls;
 */

private _display = call FUNC(getActiveDisplay);
if (isNull _display) exitWith {false};

private _bg = _display ctrlCreate ["RscText", -1];
_bg ctrlSetBackgroundColor BG_COLOR;
_bg ctrlShow false;
_bg ctrlCommit 0;

private _content = _display ctrlCreate ["RscStructuredText", -1];
_content ctrlShow false;
_content ctrlCommit 0;

// Diagonal shine slices — stacked horizontal strips that sweep with offset
private _shineSlices = [];
for "_i" from 0 to (SHINE_SLICES - 1) do {
    private _slice = _display ctrlCreate ["RscText", -1];
    _slice ctrlShow false;
    _slice ctrlCommit 0;
    _shineSlices pushBack _slice;
};

uiNamespace setVariable [QGVAR(readyUI_bg), _bg];
uiNamespace setVariable [QGVAR(readyUI_content), _content];
uiNamespace setVariable [QGVAR(readyUI_shineSlices), _shineSlices];
uiNamespace setVariable [QGVAR(readyUI_display), _display];
uiNamespace setVariable [QGVAR(readyUI_flashActive), false];
true
