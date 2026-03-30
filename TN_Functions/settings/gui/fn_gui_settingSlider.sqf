#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes a slider setting row. Wires the slider drag,
 * the text-edit KeyUp, and the KillFocus events to write
 * temporary overrides. Runs in uiNamespace.
 *
 * Arguments:
 * 0: Parent controls group for the row <CONTROL>
 * 1: CBA setting name string <STRING>
 * 2: Setting source (e.g. "server") <STRING>
 * 3: The live numeric value <NUMBER>
 * 4: Setting data [min, max, trailingDecimals, isPercentage] <ARRAY>
 *
 * Return Value:
 * None
 */

#define SERVER_TEMP \
    (uiNamespace getVariable QGVAR(serverTemp))
#define IDC_SLIDER 5120
#define IDC_SLIDER_EDIT 5121
#define IDC_NAME 5010
#define IDC_DEFAULT 5020
#define COLOR_MODIFIED [0.95, 0.95, 0.1, 1]

params [
    "_controlsGroup", "_setting", "_source",
    "_currentValue", "_settingData"
];
_settingData params [
    "_min", "_max",
    "_trailingDecimals", "_isPercentage"
];

private _range = _max - _min;

private _ctrlSlider = _controlsGroup controlsGroupCtrl IDC_SLIDER;
_ctrlSlider sliderSetRange [_min, _max];
_ctrlSlider sliderSetPosition _currentValue;
_ctrlSlider sliderSetSpeed [
    0.05 * _range, 0.1 * _range
];

// Shared formatter stored in uiNamespace so event handlers can access it.
if (isNil {uiNamespace getVariable QGVARMAIN(fnc_formatEditText)}) then {
    uiNamespace setVariable [QGVARMAIN(fnc_formatEditText), {
        params ["_val", "_decimals", "_pct"];
        if (_pct) then {
            format [localize "STR_3DEN_percentageUnit", round (_val * 100), "%"]
        } else {
            if (_decimals < 0) then {
                _val = round _val;
            };
            [_val, 1, _decimals max 0] call CBA_fnc_formatNumber
        };
    }];
};

_ctrlSlider setVariable [
    "cba_settings_params",
    [
        _setting, _source,
        _trailingDecimals, _isPercentage
    ]
];

_ctrlSlider ctrlAddEventHandler [
    "SliderPosChanged", {
        params ["_ctrlSlider", "_value"];
        (_ctrlSlider getVariable "cba_settings_params") params [
            "_setting", "_source",
            "_trailingDecimals", "_isPercentage"
        ];

        private _editText = [
            _value, _trailingDecimals, _isPercentage
        ] call (uiNamespace getVariable QGVARMAIN(fnc_formatEditText));

        private _controlsGroup = ctrlParentControlsGroup _ctrlSlider;
        private _ctrlSliderEdit = _controlsGroup controlsGroupCtrl IDC_SLIDER_EDIT;
        _ctrlSliderEdit ctrlSetText _editText;

        SERVER_TEMP setVariable [
            _setting,
            [
                _value,
                (SERVER_TEMP getVariable [
                    _setting, [nil, nil]
                ] select 1)
            ]
        ];

        private _ctrlDefault = _controlsGroup controlsGroupCtrl IDC_DEFAULT;
        private _defaultValue = (GVAR(default) getVariable _setting) select 0;
        _ctrlDefault ctrlEnable (_value isNotEqualTo _defaultValue);

        private _ctrlSettingName = _controlsGroup controlsGroupCtrl IDC_NAME;
        _ctrlSettingName ctrlSetTextColor COLOR_MODIFIED;
    }
];

private _editText = [
    _currentValue, _trailingDecimals, _isPercentage
] call (uiNamespace getVariable QGVARMAIN(fnc_formatEditText));

private _ctrlSliderEdit = _controlsGroup controlsGroupCtrl IDC_SLIDER_EDIT;
_ctrlSliderEdit ctrlSetText _editText;

_ctrlSliderEdit setVariable [
    "cba_settings_params",
    [
        _setting, _source,
        _trailingDecimals, _isPercentage
    ]
];

_ctrlSliderEdit ctrlAddEventHandler [
    "KeyUp", {
        params ["_ctrlSliderEdit"];
        (_ctrlSliderEdit getVariable "cba_settings_params") params [
            "_setting", "_source",
            "_trailingDecimals", "_isPercentage"
        ];

        private _value = parseNumber ctrlText _ctrlSliderEdit;

        if (_isPercentage) then {
            _value = _value / 100;
        } else {
            if (_trailingDecimals < 0) then {
                _value = round _value;
            };
        };

        private _controlsGroup = ctrlParentControlsGroup _ctrlSliderEdit;
        private _ctrlSlider = _controlsGroup controlsGroupCtrl IDC_SLIDER;

        _ctrlSlider sliderSetPosition _value;
        _value = sliderPosition _ctrlSlider;

        SERVER_TEMP setVariable [
            _setting,
            [
                _value,
                (SERVER_TEMP getVariable [
                    _setting, [nil, nil]
                ] select 1)
            ]
        ];

        private _ctrlDefault = _controlsGroup controlsGroupCtrl IDC_DEFAULT;
        private _defaultValue = (GVAR(default) getVariable _setting) select 0;
        _ctrlDefault ctrlEnable (_value isNotEqualTo _defaultValue);

        private _ctrlSettingName = _controlsGroup controlsGroupCtrl IDC_NAME;
        _ctrlSettingName ctrlSetTextColor COLOR_MODIFIED;
    }
];

_ctrlSliderEdit ctrlAddEventHandler [
    "KillFocus", {
        params ["_ctrlSliderEdit"];
        (_ctrlSliderEdit getVariable "cba_settings_params") params [
            "_setting", "_source",
            "_trailingDecimals", "_isPercentage"
        ];

        private _controlsGroup = ctrlParentControlsGroup _ctrlSliderEdit;
        private _ctrlSlider = _controlsGroup controlsGroupCtrl IDC_SLIDER;

        private _value = sliderPosition _ctrlSlider;

        private _editText = [
            _value, _trailingDecimals, _isPercentage
        ] call (uiNamespace getVariable QGVARMAIN(fnc_formatEditText));

        _ctrlSliderEdit ctrlSetText _editText;

        private _ctrlDefault = _controlsGroup controlsGroupCtrl IDC_DEFAULT;
        private _defaultValue = (GVAR(default) getVariable _setting) select 0;
        _ctrlDefault ctrlEnable (_value isNotEqualTo _defaultValue);

        private _ctrlSettingName = _controlsGroup controlsGroupCtrl IDC_NAME;
        _ctrlSettingName ctrlSetTextColor COLOR_MODIFIED;
    }
];

_controlsGroup setVariable [
    "cba_settings_fnc_updateUI", {
        params ["_controlsGroup", "_value"];
        (_controlsGroup getVariable "cba_settings_params") params [
            "_min", "_max",
            "_trailingDecimals", "_isPercentage"
        ];

        private _ctrlSlider = _controlsGroup controlsGroupCtrl IDC_SLIDER;
        private _ctrlSliderEdit = _controlsGroup controlsGroupCtrl IDC_SLIDER_EDIT;

        _ctrlSlider sliderSetPosition _value;

        private _editText = [
            _value, _trailingDecimals, _isPercentage
        ] call (uiNamespace getVariable QGVARMAIN(fnc_formatEditText));

        _ctrlSliderEdit ctrlSetText _editText;

        private _ctrlDefault = _controlsGroup controlsGroupCtrl IDC_DEFAULT;
        private _defaultValue = (GVAR(default) getVariable _setting) select 0;
        _ctrlDefault ctrlEnable (_value isNotEqualTo _defaultValue);
    }
];

nil
