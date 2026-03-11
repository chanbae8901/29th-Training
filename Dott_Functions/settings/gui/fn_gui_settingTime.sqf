/**
 * fn_gui_settingTime.sqf
 * Initializes a time-picker setting row (HH:MM:SS).
 * Wires the slider and three text-edit fields to write
 * temporary overrides.  Runs in uiNamespace.
 *
 * Params:
 *   _controlsGroup - parent controls group for the row
 *   _setting       - CBA setting name string
 *   _source        - setting source (e.g. "server")
 *   _currentValue  - current time value in seconds
 *   _settingData   - [_min, _max] range in seconds
 * Return: none
 */

#define SERVER_TEMP \
    (uiNamespace getVariable "DOTT_settings_serverTemp")

params [
    "_controlsGroup", "_setting", "_source",
    "_currentValue", "_settingData"
];
_settingData params ["_min", "_max"];

private _ctrlSlider =
    _controlsGroup controlsGroupCtrl 5140;
_ctrlSlider setVariable [
    "cba_settings_params", [_setting, _source]
];

_ctrlSlider sliderSetRange [_min, _max];
_ctrlSlider sliderSetPosition _currentValue;
private _range = _max - _min;
_ctrlSlider sliderSetSpeed [
    0.05 * _range, 0.1 * _range
];

_ctrlSlider ctrlAddEventHandler [
    "SliderPosChanged",
    {
        params ["_ctrlSlider", "_value"];
        (_ctrlSlider getVariable
            "cba_settings_params") params [
            "_setting", "_source"
        ];
        _value = round _value;

        private _controlsGroup =
            ctrlParentControlsGroup _ctrlSlider;
        (_controlsGroup controlsGroupCtrl 5141)
            ctrlSetText (
                [floor (_value / 3600), 2]
                    call CBA_fnc_formatNumber
            );
        (_controlsGroup controlsGroupCtrl 5142)
            ctrlSetText (
                [floor (_value / 60 % 60), 2]
                    call CBA_fnc_formatNumber
            );
        (_controlsGroup controlsGroupCtrl 5143)
            ctrlSetText (
                [floor (_value % 60), 2]
                    call CBA_fnc_formatNumber
            );

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
    }
];

{
    _x params ["_idc", "_value"];

    private _ctrlEdit =
        _controlsGroup controlsGroupCtrl _idc;
    _ctrlEdit setVariable [
        "cba_settings_params", [_setting, _source]
    ];
    _ctrlEdit ctrlSetText (
        [_value, 2] call CBA_fnc_formatNumber
    );

    _ctrlEdit ctrlAddEventHandler [
        "KillFocus",
        {
            params ["_ctrlEdit"];
            (_ctrlEdit getVariable
                "cba_settings_params") params [
                "_setting", "_source"
            ];

            private _controlsGroup =
                ctrlParentControlsGroup _ctrlEdit;
            private _ctrlSlider =
                _controlsGroup
                controlsGroupCtrl 5140;
            private _ctrlEditHours =
                _controlsGroup
                controlsGroupCtrl 5141;
            private _ctrlEditMinutes =
                _controlsGroup
                controlsGroupCtrl 5142;
            private _ctrlEditSeconds =
                _controlsGroup
                controlsGroupCtrl 5143;

            private _value = round (
                parseNumber ctrlText _ctrlEditHours
                    * 3600
                + parseNumber ctrlText _ctrlEditMinutes
                    * 60
                + parseNumber ctrlText _ctrlEditSeconds
            );
            _ctrlSlider sliderSetPosition _value;
            _value = sliderPosition _ctrlSlider;

            _ctrlEditHours ctrlSetText (
                [floor (_value / 3600), 2]
                    call CBA_fnc_formatNumber
            );
            _ctrlEditMinutes ctrlSetText (
                [floor (_value / 60 % 60), 2]
                    call CBA_fnc_formatNumber
            );
            _ctrlEditSeconds ctrlSetText (
                [floor (_value % 60), 2]
                    call CBA_fnc_formatNumber
            );

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
                _controlsGroup
                controlsGroupCtrl 5020;
            private _defaultValue =
                (DOTT_settings_default
                    getVariable _setting) select 0;
            _ctrlDefault ctrlEnable (
                _value isNotEqualTo _defaultValue
            );
        }
    ];
} forEach [
    [5141, floor (_currentValue / 3600)],
    [5142, floor (_currentValue / 60 % 60)],
    [5143, floor (_currentValue % 60)]
];

_controlsGroup setVariable [
    "cba_settings_fnc_updateUI",
    {
        params ["_controlsGroup", "_value"];

        (_controlsGroup controlsGroupCtrl 5140)
            sliderSetPosition _value;
        (_controlsGroup controlsGroupCtrl 5141)
            ctrlSetText (
                [floor (_value / 3600), 2]
                    call CBA_fnc_formatNumber
            );
        (_controlsGroup controlsGroupCtrl 5142)
            ctrlSetText (
                [floor (_value / 60 % 60), 2]
                    call CBA_fnc_formatNumber
            );
        (_controlsGroup controlsGroupCtrl 5143)
            ctrlSetText (
                [floor (_value % 60), 2]
                    call CBA_fnc_formatNumber
            );

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
