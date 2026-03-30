#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes a checkbox setting row and wires the
 * CheckedChanged event to write temporary overrides.
 * Runs in uiNamespace.
 *
 * Arguments:
 * 0: Parent controls group for the row <CONTROL>
 * 1: CBA setting name string <STRING>
 * 2: Setting source (e.g. "server") <STRING>
 * 3: Current boolean value <BOOL>
 * 4: Setting data (unused for checkbox type) <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_controlsGroup, _setting, _source, _currentValue, _settingData] call TN_settings_fnc_gui_settingCheckbox
 */

#define SERVER_TEMP \
    (uiNamespace getVariable QGVAR(serverTemp))

params [
    "_controlsGroup", "_setting", "_source",
    "_currentValue", "_settingData"
];

private _ctrlCheckbox =
    _controlsGroup controlsGroupCtrl 5100;
_ctrlCheckbox cbSetChecked _currentValue;

_ctrlCheckbox setVariable [
    "cba_settings_params", [_setting, _source]
];

_ctrlCheckbox ctrlAddEventHandler [
    "CheckedChanged", {
        params ["_ctrlCheckbox", "_state"];
        (_ctrlCheckbox getVariable
            "cba_settings_params") params [
            "_setting", "_source"
        ];

        private _value = _state == 1;
        SERVER_TEMP setVariable [
            _setting,
            [
                _value,
                (SERVER_TEMP getVariable [
                    _setting, [nil, nil]
                ] select 1)
            ]
        ];

        private _controlsGroup =
            ctrlParentControlsGroup _ctrlCheckbox;
        private _ctrlDefault =
            _controlsGroup controlsGroupCtrl 5020;
        private _defaultValue =
            (GVAR(default)
                getVariable _setting) select 0;
        _ctrlDefault ctrlEnable (
            _value isNotEqualTo _defaultValue
        );

        private _ctrlSettingName =
            _controlsGroup controlsGroupCtrl 5010;
        _ctrlSettingName ctrlSetTextColor [
            0.95, 0.95, 0.1, 1
        ];
    }
];

_controlsGroup setVariable [
    "cba_settings_fnc_updateUI", {
        params ["_controlsGroup", "_value"];

        private _ctrlCheckbox =
            _controlsGroup controlsGroupCtrl 5100;
        _ctrlCheckbox cbSetChecked _value;

        private _ctrlDefault =
            _controlsGroup controlsGroupCtrl 5020;
        private _defaultValue =
            (GVAR(default)
                getVariable _setting) select 0;
        _ctrlDefault ctrlEnable (
            _value isNotEqualTo _defaultValue
        );
    }
];

nil
