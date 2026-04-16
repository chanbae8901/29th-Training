#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Saves SW or LR radio settings when a frequency change is
 * detected. Checks whether the changed radio is the active SW
 * or LR and persists the appropriate settings.
 *
 * Arguments:
 * 0: Unit whose radio changed <OBJECT>
 * 1: Radio that changed <STRING>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [player, "TFAR_anprc152"] call TN_radio_fnc_onFrequencyChanged;
 */

params ["_unit", "_radio"];
if (_unit isNotEqualTo player) exitWith {};

private _sw = call TFAR_fnc_activeSwRadio;
if (_sw isEqualTo _radio) exitWith {
    GVAR(savedActiveSrSettings) =
        _sw call TFAR_fnc_getSwSettings;
};

private _lr = call TFAR_fnc_activeLrRadio;
if (_lr isEqualTo _radio) exitWith {
    GVAR(savedActiveLrSettings) =
        _lr call TFAR_fnc_getLrSettings;
};

nil
