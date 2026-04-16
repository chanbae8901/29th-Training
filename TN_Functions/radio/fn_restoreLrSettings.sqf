#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Restores LR radio settings and fixes encryption after a
 * loadout change. TFAR can assign the wrong side's encryption
 * code; this detects and corrects it.
 *
 * Arguments:
 * CBA player "loadout" event args (unused)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_radio_fnc_restoreLrSettings;
 */

// Ref: https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/878f98e/addons/core/functions/fnc_getDefaultRadioSettings.sqf#L62
#define TFAR_CODE_OFFSET 4

private _lr = player call TFAR_fnc_backpackLr;
if (isNil "_lr") exitWith {};

private _settings = GVAR(savedActiveLrSettings);
if (isNil "_settings") then {
    _settings = _lr call TFAR_fnc_getLrSettings;
};

// Resolve the correct encryption code for this radio.
private _correctCode = [
    typeOf (_lr select 0),
    "tf_encryptionCode", ""
] call TFAR_fnc_getVehicleConfigProperty;

// Legacy alias -- may no longer be needed.
if (_correctCode isEqualTo "tf_guer_radio_code") then {
    _correctCode = "tf_independent_radio_code";
};
_correctCode = missionNamespace getVariable [
    _correctCode, ""
];

private _currentCode = _lr call TFAR_fnc_getLrRadioCode;

if (_currentCode isNotEqualTo _correctCode) then {
    _settings set [TFAR_CODE_OFFSET, _correctCode];
};

[_lr, _settings] call TFAR_fnc_setLrSettings;

nil
