#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
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

private _ctrl = uiNamespace getVariable [QGVAR(medicalCtrl), controlNull];
if (isNull _ctrl) exitWith {};
private _unit = GVAR(medicalFocusedUnit);

if (isNull _unit) exitWith {
    _ctrl ctrlSetStructuredText parseText "";
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
private _partNames = ["Head", "Body", "L.Arm", "R.Arm", "L.Leg", "R.Leg"];

private _fnDamageColor = {
    params ["_dmg"];
    if (_dmg < 0.01) exitWith {"#44ff44"};
    if (_dmg < 0.5) exitWith {"#ffff44"};
    if (_dmg < 1)  exitWith {"#ff8800"};
    "#ff4444"
};

private _html = format [
    "<t color='%1'>Blood: %2 / 6.0 L</t>",
    _bloodColor,
    _bloodVol toFixed 1
];

{
    _html = _html + format [
        "<br/><t color='%1'>%2: %3</t>",
        [_x] call _fnDamageColor,
        _partNames select _forEachIndex,
        _x toFixed 2
    ];
} forEach _bodyPartDamage;

_ctrl ctrlSetStructuredText parseText _html;
_ctrl ctrlShow true;
