#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Wires the "Reset to default" button for a single setting
 * row.  Clicking it restores the server's initial value and
 * invokes the row's updateUI callback.
 *
 * Arguments:
 * 0: Parent controls group for the row <CONTROL>
 * 1: CBA setting name string <STRING>
 * 2: Setting source (e.g. "server") <STRING>
 * 3: The live value being displayed <ANY>
 * 4: The server's initial value <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_controlsGroup, _setting, _source, _currentValue, _defaultValue] call TN_settings_fnc_gui_settingDefault
 */

#define DEFAULT_INDEX 0
#define SERVER_TEMP \
    (uiNamespace getVariable QGVAR(serverTemp))

params [
    "_controlsGroup", "_setting", "_source",
    "_currentValue", "_defaultValue"
];

private _ctrlDefault = _controlsGroup controlsGroupCtrl 5020;

_ctrlDefault setVariable [
    "cba_settings_params", [_setting, _source]
];

_ctrlDefault ctrlAddEventHandler [
    "ButtonClick", {
        params ["_ctrlDefault"];
        (_ctrlDefault getVariable "cba_settings_params") params ["_setting", "_source"];

        private _defaultValue = (GVAR(default) getVariable _setting) select DEFAULT_INDEX;
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

        private _controlsGroup = ctrlParentControlsGroup _ctrlDefault;
        [_controlsGroup, _defaultValue] call (_controlsGroup getVariable "cba_settings_fnc_updateUI");

        private _ctrlSettingName = _controlsGroup controlsGroupCtrl 5010;
        _ctrlSettingName ctrlSetTextColor [
            0.95, 0.95, 0.1, 1
        ];
    }
];

if (_currentValue isEqualTo _defaultValue) then {
    _ctrlDefault ctrlEnable false;
};

nil
