params ["_controlsGroup", "_setting", "_source", "_currentValue", "_settingData"];

private _ctrlCheckbox = _controlsGroup controlsGroupCtrl 5100;
_ctrlCheckbox cbSetChecked _currentValue;

_ctrlCheckbox setVariable ["cba_settings_params", [_setting, _source]];
_ctrlCheckbox ctrlAddEventHandler ["CheckedChanged", {
    params ["_ctrlCheckbox", "_state"];
    (_ctrlCheckbox getVariable "cba_settings_params") params ["_setting", "_source"];

    private _value = _state == 1;
     uiNamespace getVariable "DOTT_settings_serverTemp" setVariable [_setting, [_value, (uiNamespace getVariable "DOTT_settings_serverTemp" getVariable [_setting, [nil, nil]] select 1)]];


    private _controlsGroup = ctrlParentControlsGroup _ctrlCheckbox;
    private _ctrlDefault = _controlsGroup controlsGroupCtrl 5020;
    private _defaultValue = [_setting, "default"] call cba_settings_fnc_get;
    _ctrlDefault ctrlEnable (_value isNotEqualTo _defaultValue);
}];


_controlsGroup setVariable ["cba_settings_fnc_updateUI", {
    params ["_controlsGroup", "_value"];

    private _ctrlCheckbox = _controlsGroup controlsGroupCtrl 5100;
    _ctrlCheckbox cbSetChecked _value;


    private _ctrlDefault = _controlsGroup controlsGroupCtrl 5020;
    private _defaultValue = [_setting, "default"] call cba_settings_fnc_get;
    _ctrlDefault ctrlEnable (_value isNotEqualTo _defaultValue);
}];
