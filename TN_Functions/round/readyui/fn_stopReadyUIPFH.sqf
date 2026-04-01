#include "script_component.hpp"

/*
 * Author: PFC Wells [29th ID]
 * Stops the ready UI update PFH and hides all controls.
 * Called EXTERNALLY by event handlers — never from within the PFH itself.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call TN_round_fnc_stopReadyUIPFH;
 */

if (isNil QGVAR(readyUI_pfhHandle)) exitWith {};
[GVAR(readyUI_pfhHandle)] call CBA_fnc_removePerFrameHandler;
GVAR(readyUI_pfhHandle) = nil;

// Hide controls
private _bg = uiNamespace getVariable [QGVAR(readyUI_bg), controlNull];
private _content = uiNamespace getVariable [QGVAR(readyUI_content), controlNull];
if !(isNull _bg) then { _bg ctrlShow false };
if !(isNull _content) then { _content ctrlShow false };
{
    _x ctrlShow false;
} forEach (uiNamespace getVariable [QGVAR(readyUI_shineSlices), []]);
uiNamespace setVariable [QGVAR(readyUI_flashActive), false];

// Kill in-flight shine animation
if !(isNil QGVAR(readyUI_shinePFH)) then {
    [GVAR(readyUI_shinePFH)] call CBA_fnc_removePerFrameHandler;
    GVAR(readyUI_shinePFH) = nil;
};

nil
