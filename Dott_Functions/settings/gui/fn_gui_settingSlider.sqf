/**
 * fn_gui_settingSlider.sqf
 * Initializes a slider setting row.  Wires the slider drag,
 * the text-edit KeyUp, and the KillFocus events to write
 * temporary overrides.  Runs in uiNamespace.
 *
 * Params:
 *   _controlsGroup - parent controls group for the row
 *   _setting       - CBA setting name string
 *   _source        - setting source (e.g. "server")
 *   _currentValue  - the live numeric value
 *   _settingData   - [_min, _max, _trailingDecimals,
 *                     _isPercentage]
 * Return: none
 */

#define SERVER_TEMP \
    (uiNamespace getVariable "DOTT_settings_serverTemp")

params [
    "_controlsGroup", "_setting", "_source",
    "_currentValue", "_settingData"
];
_settingData params [
    "_min", "_max",
    "_trailingDecimals", "_isPercentage"
];

private _range = _max - _min;

private _ctrlSlider =
    _controlsGroup controlsGroupCtrl 5120;
_ctrlSlider sliderSetRange [_min, _max];
_ctrlSlider sliderSetPosition _currentValue;
_ctrlSlider sliderSetSpeed [
    0.05 * _range, 0.1 * _range
];

_ctrlSlider setVariable [
    "cba_settings_params",
    [
        _setting, _source,
        _trailingDecimals, _isPercentage
    ]
];

_ctrlSlider ctrlAddEventHandler [
    "SliderPosChanged",
    {
        params ["_ctrlSlider", "_value"];
        (_ctrlSlider getVariable
            "cba_settings_params") params [
            "_setting", "_source",
            "_trailingDecimals", "_isPercentage"
        ];

        private _editText =
            if (_isPercentage) then
            {
                format [
                    localize
                        "STR_3DEN_percentageUnit",
                    round (_value * 100), "%"
                ]
            }
            else
            {
                if (_trailingDecimals < 0) then
                {
                    _value = round _value;
                };

                [_value, 1, _trailingDecimals max 0]
                    call CBA_fnc_formatNumber
            };

        private _controlsGroup =
            ctrlParentControlsGroup _ctrlSlider;
        private _ctrlSliderEdit =
            _controlsGroup controlsGroupCtrl 5121;
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

        private _ctrlDefault =
            _controlsGroup controlsGroupCtrl 5020;
        private _defaultValue =
            (DOTT_settings_default
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

private _editText = if (_isPercentage) then
{
    format [
        localize "STR_3DEN_percentageUnit",
        round (_currentValue * 100), "%"
    ]
}
else
{
    [_currentValue, 1, _trailingDecimals max 0]
        call CBA_fnc_formatNumber
};

private _ctrlSliderEdit =
    _controlsGroup controlsGroupCtrl 5121;
_ctrlSliderEdit ctrlSetText _editText;

_ctrlSliderEdit setVariable [
    "cba_settings_params",
    [
        _setting, _source,
        _trailingDecimals, _isPercentage
    ]
];

_ctrlSliderEdit ctrlAddEventHandler [
    "KeyUp",
    {
        params ["_ctrlSliderEdit"];
        (_ctrlSliderEdit getVariable
            "cba_settings_params") params [
            "_setting", "_source",
            "_trailingDecimals", "_isPercentage"
        ];

        private _value =
            parseNumber ctrlText _ctrlSliderEdit;

        if (_isPercentage) then
        {
            _value = _value / 100;
        }
        else
        {
            if (_trailingDecimals < 0) then
            {
                _value = round _value;
            };
        };

        private _controlsGroup =
            ctrlParentControlsGroup _ctrlSliderEdit;
        private _ctrlSlider =
            _controlsGroup controlsGroupCtrl 5120;

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

        private _ctrlDefault =
            _controlsGroup controlsGroupCtrl 5020;
        private _defaultValue =
            (DOTT_settings_default
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

_ctrlSliderEdit ctrlAddEventHandler [
    "KillFocus",
    {
        params ["_ctrlSliderEdit"];
        (_ctrlSliderEdit getVariable
            "cba_settings_params") params [
            "_setting", "_source",
            "_trailingDecimals", "_isPercentage"
        ];

        private _controlsGroup =
            ctrlParentControlsGroup _ctrlSliderEdit;
        private _ctrlSlider =
            _controlsGroup controlsGroupCtrl 5120;

        private _value = sliderPosition _ctrlSlider;

        private _editText =
            if (_isPercentage) then
            {
                format [
                    localize
                        "STR_3DEN_percentageUnit",
                    round (_value * 100), "%"
                ]
            }
            else
            {
                if (_trailingDecimals < 0) then
                {
                    _value = round _value;
                };

                [_value, 1, _trailingDecimals max 0]
                    call CBA_fnc_formatNumber
            };

        _ctrlSliderEdit ctrlSetText _editText;

        private _ctrlDefault =
            _controlsGroup controlsGroupCtrl 5020;
        private _defaultValue =
            (DOTT_settings_default
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
    "cba_settings_fnc_updateUI",
    {
        params ["_controlsGroup", "_value"];
        (_controlsGroup getVariable
            "cba_settings_params") params [
            "_min", "_max",
            "_trailingDecimals", "_isPercentage"
        ];

        private _ctrlSlider =
            _controlsGroup controlsGroupCtrl 5120;
        private _ctrlSliderEdit =
            _controlsGroup controlsGroupCtrl 5121;

        _ctrlSlider sliderSetPosition _value;

        private _editText =
            if (_isPercentage) then
            {
                format [
                    localize
                        "STR_3DEN_percentageUnit",
                    round (_value * 100), "%"
                ]
            }
            else
            {
                [_value, 1, _trailingDecimals max 0]
                    call CBA_fnc_formatNumber
            };

        _ctrlSliderEdit ctrlSetText _editText;

        private _ctrlDefault =
            _controlsGroup controlsGroupCtrl 5020;
        private _defaultValue =
            (DOTT_settings_default
                getVariable _setting) select 0;
        _ctrlDefault ctrlEnable (
            _value isNotEqualTo _defaultValue
        );
    }
];
