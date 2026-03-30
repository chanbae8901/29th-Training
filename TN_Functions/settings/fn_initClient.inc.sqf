{
    private _scriptName = format ["TN_settings_fnc_%1", _x];

    if (isNil {uiNamespace getVariable _scriptName}) then {
        private _filePath = format ["TN_Functions\settings\gui\fn_%1.sqf", _x];
        uiNamespace setVariable [_scriptName, compile preprocessFile _filePath];
    };
}
forEach [
    "gui_settingCheckbox",
    "gui_settingSlider",
    "gui_settingList",
    "gui_settingTime"
];

{
    private _scriptName = format ["TN_settings_fnc_%1", _x];

    if (isNil {missionNamespace getVariable _scriptName}) then {
        private _filePath = format ["TN_Functions\settings\gui\fn_%1.sqf", _x];
        missionNamespace setVariable [_scriptName, compile preprocessFile _filePath];
    };
}
forEach [
    "gui_settingDefault",
    "gui_sourceChanged",
    "gui_addonChanged",
    "gui_saveTempData"
];
