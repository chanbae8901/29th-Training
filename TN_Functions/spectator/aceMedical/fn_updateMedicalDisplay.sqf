#include "script_component.hpp"
/*
 * Author: Claude prompted by Bae [29th ID]
 * Updates the ACE medical overlay panel with the focused unit's
 * blood volume and body part damage. Clears the panel when no
 * CAManBase is focused.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_spectator_fnc_updateMedicalDisplay
 */

private _bgCtrl    = uiNamespace getVariable [QGVAR(medicalBgCtrl),    controlNull];
private _labelCtrl = uiNamespace getVariable [QGVAR(medicalLabelCtrl), controlNull];
private _valueCtrl = uiNamespace getVariable [QGVAR(medicalValueCtrl), controlNull];
if (isNull _bgCtrl || {isNull _labelCtrl} || {isNull _valueCtrl}) exitWith {};
private _unit = GVAR(medicalFocusedUnit);

if (isNull _unit) exitWith {
    _bgCtrl    ctrlShow false;
    _labelCtrl ctrlShow false;
    _valueCtrl ctrlShow false;
};

// Blood volume: 0-6 L, normal = 6.
private _bloodVol = _unit getVariable ["ace_medical_bloodVolume", 6];
private _bloodColor = switch (true) do {
    case (_bloodVol > 5.1): {"#44ff44"};
    case (_bloodVol > 4.2): {"#ffff44"};
    case (_bloodVol > 3.6): {"#ff8800"};
    default {"#ff4444"};
};

// Body part damage array: [head, body, leftArm, rightArm, leftLeg, rightLeg].
private _bodyPartDamage = _unit getVariable ["ace_medical_bodyPartDamage", [0,0,0,0,0,0]];

private _fnDamageColor = {
    private _dmg = _this select 0;
    if (_dmg < 0.01) exitWith {"#44ff44"};
    if (_dmg < 0.5)  exitWith {"#ffff44"};
    if (_dmg < 1)    exitWith {"#ff8800"};
    "#ff4444"
};

private _lines = [format ["<t color='%1'>%2</t>", _bloodColor, _bloodVol toFixed 2]];
{
    _lines pushBack format ["<br/><t color='%1'>%2</t>", [_x] call _fnDamageColor, _x toFixed 2];
} forEach _bodyPartDamage;

_valueCtrl ctrlSetStructuredText parseText (_lines joinString "");
_bgCtrl    ctrlShow true;
_labelCtrl ctrlShow true;
_valueCtrl ctrlShow true;
