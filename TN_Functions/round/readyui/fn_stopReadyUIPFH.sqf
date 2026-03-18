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
