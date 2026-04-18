#include "script_component.hpp"
/*
 * Author: Claude prompted by Bae [29th ID]
 * Initializes the ACE medical overlay while in spectator mode.
 * The panel is hidden by default; press H to toggle it.
 * Polls the ACE spectator camera focus to refresh
 * medical data. Cleans itself up when TN_spectator_exited fires.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_spectator_fnc_aceMedicalInit
 */

if (!hasInterface) exitWith {};

// Remove any leftover PFH from a previous spectator session.
if (!isNil QGVAR(medicalPFH)) then {
    [GVAR(medicalPFH)] call CBA_fnc_removePerFrameHandler;
};

GVAR(medicalFocusedUnit) = objNull;
GVAR(medicalVisible) = false;

private _spectatorDisplay = findDisplay 60000;

// Create the medical panel directly on the spectator display so it renders
// in the same coordinate space as the focus widget (outside the safe zone).
// Three controls: one shared background + right-aligned labels + left-aligned values.
// A single background avoids the seam artifact that appears between two adjacent
// semi-transparent controls. Widths derive from _fontSize so they scale correctly
// at any resolution or aspect ratio.
private _r = (safeZoneW / safeZoneH) min 1.2;
private _fontSize = (_r / 1.2) / 28;
private _medH = 6.35 * (_r / 1.2) / 25;
// Label column: "L.Arm:" is the widest label (~6 wide-glyph chars ≈ 1.7 em).
// 2.2 gives comfortable margin without excess left padding.
private _labelW = _fontSize * 2.2;
// Value column: all values are "X.XX" (4 chars ≈ 1.35 em).
// 1.8 gives comfortable margin without excess right padding.
private _valueW = _fontSize * 1.8;
private _focusPos = ctrlPosition (_spectatorDisplay displayCtrl 60030);
private _medX = (_focusPos # 0) + (_focusPos # 2) + _fontSize * 1;
private _medY = (_focusPos # 1) + (_focusPos # 3) / 2 - _medH / 2;

// Background control: spans full width, created first so it renders behind text.
private _bgCtrl = _spectatorDisplay ctrlCreate ["RscStructuredText", -1];
_bgCtrl ctrlSetBackgroundColor [0, 0, 0, 0.5];
_bgCtrl ctrlSetPosition [_medX, _medY, _labelW + _valueW, _medH];
_bgCtrl ctrlCommit 0;
_bgCtrl ctrlShow false;
uiNamespace setVariable [QGVAR(medicalBgCtrl), _bgCtrl];

// Label control: right-aligned static text, transparent background.
private _labelCtrl = _spectatorDisplay ctrlCreate ["RscStructuredText", -1];
_labelCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
_labelCtrl ctrlSetFont "RobotoCondensed";
_labelCtrl ctrlSetFontHeight _fontSize;
_labelCtrl ctrlSetPosition [_medX, _medY, _labelW, _medH];
_labelCtrl ctrlCommit 0;
_labelCtrl ctrlSetStructuredText parseText (
    "<t align='right'>Blood:</t>" +
    "<br/><t align='right'>Head:</t>" +
    "<br/><t align='right'>Body:</t>" +
    "<br/><t align='right'>L.Arm:</t>" +
    "<br/><t align='right'>R.Arm:</t>" +
    "<br/><t align='right'>L.Leg:</t>" +
    "<br/><t align='right'>R.Leg:</t>"
);
_labelCtrl ctrlShow false;
uiNamespace setVariable [QGVAR(medicalLabelCtrl), _labelCtrl];

// Value control: left-aligned colored values, transparent background, updated per-frame.
private _valueCtrl = _spectatorDisplay ctrlCreate ["RscStructuredText", -1];
_valueCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
_valueCtrl ctrlSetFont "RobotoCondensed";
_valueCtrl ctrlSetFontHeight _fontSize;
_valueCtrl ctrlSetPosition [_medX + _labelW, _medY, _valueW, _medH];
_valueCtrl ctrlCommit 0;
_valueCtrl ctrlShow false;
uiNamespace setVariable [QGVAR(medicalValueCtrl), _valueCtrl];

_spectatorDisplay displayAddEventHandler ["KeyDown", {
    params ["", "_key"];
    if !(_key isEqualTo 35) exitWith { false };
    GVAR(medicalVisible) = !GVAR(medicalVisible);
    if (GVAR(medicalVisible)) then {
        call FUNC(updateMedicalDisplay);
    } else {
        (uiNamespace getVariable [QGVAR(medicalBgCtrl),    controlNull]) ctrlShow false;
        (uiNamespace getVariable [QGVAR(medicalLabelCtrl), controlNull]) ctrlShow false;
        (uiNamespace getVariable [QGVAR(medicalValueCtrl), controlNull]) ctrlShow false;
    };
    true
}];

GVAR(medicalPFH) = [{
    if (!GVAR(medicalVisible)) exitWith {};
    private _target = missionNamespace getVariable ["ace_spectator_camFocus", objNull];
    private _newUnit = if (!isNull _target && {_target isKindOf "CAManBase"}) then { _target } else { objNull };
    if (_newUnit isEqualTo GVAR(medicalFocusedUnit) && { isNull _newUnit }) exitWith {};
    GVAR(medicalFocusedUnit) = _newUnit;
    call FUNC(updateMedicalDisplay);
}] call CBA_fnc_addPerFrameHandler;

GVAR(medicalExitEH) = [QGVAR(exited), {
    if (!isNil QGVAR(medicalPFH)) then {
        [GVAR(medicalPFH)] call CBA_fnc_removePerFrameHandler;
        GVAR(medicalPFH) = nil;
    };
    private _bgCtrl = uiNamespace getVariable [QGVAR(medicalBgCtrl), controlNull];
    if (!isNull _bgCtrl) then { ctrlDelete _bgCtrl };
    uiNamespace setVariable [QGVAR(medicalBgCtrl), nil];
    private _lCtrl = uiNamespace getVariable [QGVAR(medicalLabelCtrl), controlNull];
    if (!isNull _lCtrl) then { ctrlDelete _lCtrl };
    uiNamespace setVariable [QGVAR(medicalLabelCtrl), nil];
    private _vCtrl = uiNamespace getVariable [QGVAR(medicalValueCtrl), controlNull];
    if (!isNull _vCtrl) then { ctrlDelete _vCtrl };
    uiNamespace setVariable [QGVAR(medicalValueCtrl), nil];
    GVAR(medicalFocusedUnit) = nil;
    GVAR(medicalVisible) = nil;
    [QGVAR(exited), GVAR(medicalExitEH)] call CBA_fnc_removeEventHandler;
}] call CBA_fnc_addEventHandler;

nil
