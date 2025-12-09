params ["_control"];

private _display = ctrlParent _control;

private _selectedSource = "server";

uiNamespace setVariable ["cba_settings_source", _selectedSource];

private _selectedAddon = uiNamespace getVariable "cba_settings_addon";


{
    (_x splitString "$") params ["", "_addon", "_source"];

    private _ctrlOptionsGroup = _display getVariable _x;
    private _isSelected = _source == _selectedSource && {_addon == _selectedAddon};

    _ctrlOptionsGroup ctrlEnable _isSelected;
    _ctrlOptionsGroup ctrlShow _isSelected;
} forEach (_display getVariable "cba_settings_lists");
