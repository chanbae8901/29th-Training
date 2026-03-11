/**
 * fn_gui_settingDefault.sqf
 * Wires the "Reset to default" button for a single setting
 * row.  Clicking it restores the server's initial value and
 * invokes the row's updateUI callback.
 *
 * Params:
 *   _controlsGroup - parent controls group for the row
 *   _setting       - CBA setting name string
 *   _source        - setting source (e.g. "server")
 *   _currentValue  - the live value being displayed
 *   _defaultValue  - the server's initial value
 * Return: none
 */

#define DEFAULT_INDEX 0
#define SERVER_TEMP \
    (uiNamespace getVariable "DOTT_settings_serverTemp")

params [
    "_controlsGroup", "_setting", "_source",
    "_currentValue", "_defaultValue"
];

private _ctrlDefault =
    _controlsGroup controlsGroupCtrl 5020;

_ctrlDefault setVariable [
    "cba_settings_params", [_setting, _source]
];

_ctrlDefault ctrlAddEventHandler [
    "ButtonClick",
    {
        params ["_ctrlDefault"];
        (_ctrlDefault getVariable
            "cba_settings_params") params [
            "_setting", "_source"
        ];

        private _defaultValue =
            (DOTT_settings_default
                getVariable _setting)
            select DEFAULT_INDEX;
        SERVER_TEMP setVariable [
            _setting,
            [
                _defaultValue,
                (SERVER_TEMP getVariable [
                    _setting, [nil, nil]
                ] select 1)
            ]
        ];

        _ctrlDefault ctrlEnable false;
        ctrlSetFocus (
            ctrlParent _ctrlDefault displayCtrl 999
        );

        private _controlsGroup =
            ctrlParentControlsGroup _ctrlDefault;
        [_controlsGroup, _defaultValue] call (
            _controlsGroup getVariable
                "cba_settings_fnc_updateUI"
        );

        //[_controlsGroup] call (_controlsGroup getVariable "cba_settings_fnc_updateUI_locked");

        private _ctrlSettingName =
            _controlsGroup controlsGroupCtrl 5010;
        _ctrlSettingName ctrlSetTextColor [
            0.95, 0.95, 0.1, 1
        ];
    }
];

if (_currentValue isEqualTo _defaultValue) then
{
    _ctrlDefault ctrlEnable false;
};
