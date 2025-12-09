params ["_controlsGroup", "_setting", "_source", "_currentValue", "_defaultValue"];

private _ctrlDefault = _controlsGroup controlsGroupCtrl 5020;

_ctrlDefault setVariable ["cba_settings_params", [_setting, _source]];
_ctrlDefault ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrlDefault"];
    (_ctrlDefault getVariable "cba_settings_params") params ["_setting", "_source"];

    private _defaultValue = [_setting, "default"] call cba_settings_fnc_get;
    (uiNamespace getVariable "DOTT_settings_serverTemp") setVariable [_setting, [_defaultValue, ((uiNamespace getVariable "DOTT_settings_serverTemp") getVariable [_setting, [nil, nil]] select 1)]];

    _ctrlDefault ctrlEnable false;
    ctrlSetFocus (ctrlParent _ctrlDefault displayCtrl 999);

    private _controlsGroup = ctrlParentControlsGroup _ctrlDefault;
    [_controlsGroup, _defaultValue] call (_controlsGroup getVariable "cba_settings_fnc_updateUI");

    //[_controlsGroup] call (_controlsGroup getVariable "cba_settings_fnc_updateUI_locked");

    private _ctrlSettingName = _controlsGroup controlsGroupCtrl 5010;
    _ctrlSettingName ctrlSetTextColor [0.95, 0.95, 0.1, 1];
}];

if (_currentValue isEqualTo _defaultValue) then {
    _ctrlDefault ctrlEnable false;
};