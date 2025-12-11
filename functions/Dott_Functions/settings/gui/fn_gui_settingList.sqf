#define SERVER_TEMP (uiNamespace getVariable "DOTT_settings_serverTemp")

params ["_controlsGroup", "_setting", "_source", "_currentValue", "_settingData"];
_settingData params ["_values", "_labels", "_tooltips"];

private _ctrlList = _controlsGroup controlsGroupCtrl 5110;

private _lbData = [];

{
    private _label = _labels select _forEachIndex;
    private _tooltip = _tooltips select _forEachIndex;

    if (isLocalized _label) then {
        _label = localize _label;
    };

    if (isLocalized _tooltip) then {
        _tooltip = localize _tooltip;
    };

    if (_tooltip isEqualTo "") then {
        _tooltip = str _x;
    } else {
        _tooltip = _tooltip + endl + str _x;
    };

    private _index = _ctrlList lbAdd _label;
    _ctrlList lbSetTooltip [_index, _tooltip];
    _lbData set [_index, _x];
} forEach _values;

_ctrlList ctrlSetTooltip "";

_ctrlList lbSetCurSel (_values find _currentValue);

_ctrlList setVariable ["cba_settings_params", [_setting, _source, _lbData]];
_ctrlList ctrlAddEventHandler ["LBSelChanged", {
    if (!isNil "cba_settings_lock") exitWith {};
    params ["_ctrlList", "_index"];
    (_ctrlList getVariable "cba_settings_params") params ["_setting", "_source", "_lbData"];

    private _value = _lbData select _index;
    SERVER_TEMP setVariable [_setting, [_value, (SERVER_TEMP getVariable [_setting, [nil, nil]] select 1)]];


    private _controlsGroup = ctrlParentControlsGroup _ctrlList;
    private _ctrlDefault = _controlsGroup controlsGroupCtrl 5020;
    private _defaultValue = (DOTT_settings_default getVariable _setting) select 0;
    _ctrlDefault ctrlEnable (_value isNotEqualTo _defaultValue);

    private _ctrlSettingName = _controlsGroup controlsGroupCtrl 5010;
    _ctrlSettingName ctrlSetTextColor [0.95, 0.95, 0.1, 1];
}];


_controlsGroup setVariable ["cba_settings_fnc_updateUI", {
    params ["_controlsGroup", "_value"];
    (_controlsGroup getVariable "cba_settings_params") params ["_values", "_labels"];

    private _ctrlList = _controlsGroup controlsGroupCtrl 5110;
    cba_settings_lock = true;
    _ctrlList lbSetCurSel (_values find _value);
    cba_settings_lock = nil;


    private _ctrlDefault = _controlsGroup controlsGroupCtrl 5020;
    private _defaultValue = (DOTT_settings_default getVariable _setting) select 0;
    _ctrlDefault ctrlEnable (_value isNotEqualTo _defaultValue);
}];