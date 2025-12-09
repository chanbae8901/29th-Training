params ["_display"];
uiNamespace setVariable ["DOTT_settings_display", _display];
call DOTT_settings_fnc_initClient;

private _ctrlAddonsGroup = _display displayCtrl 4301;

with uiNamespace do {
    DOTT_settings_serverTemp  = _display ctrlCreate ["RscText", -1];
};

private _ctrlAddonList = _display ctrlCreate ["cba_settings_AddonsList", -1, _ctrlAddonsGroup];

_ctrlAddonList ctrlAddEventHandler ["LBSelChanged", {_this call DOTT_settings_fnc_gui_addonChanged}];

_display setVariable ["cba_settings_lists",[]];


private _categories = [];
{
    (DOTT_settings_default getVariable _x) params ["", "", "", "", "_category"];
    private _categoryLower = toLower _category;

    if !(_categoryLower in _categories) then {
        private _categoryLocalized = _category;
        if (isLocalized _category) then {
            _categoryLocalized = localize _category;
        };

        private _index = _ctrlAddonList lbAdd _categoryLocalized;
        _ctrlAddonList lbSetData [_index, str _index];
        _display setVariable [str _index, _categoryLower];

        _categories pushBack _categoryLower;
    };
} forEach DOTT_settings_allSettings;

lbSort _ctrlAddonList;
_ctrlAddonList lbSetCurSel (uiNamespace getVariable ["cba_settings_addonIndex", 0]);

_ctrlAddonsGroup call DOTT_settings_fnc_gui_sourceChanged;

private _ctrlScriptedOK = _display displayCtrl 999;
_ctrlScriptedOK ctrlEnable false;
_ctrlScriptedOK ctrlShow false;

private _ctrlConfirm = _display ctrlCreate ["RscButtonMenuOK", 2];
_ctrlConfirm ctrlSetPosition ctrlPosition _ctrlScriptedOK;
_ctrlConfirm ctrlCommit 0;
_ctrlConfirm ctrlAddEventHandler ["ButtonClick", {call DOTT_settings_fnc_gui_saveTempData}];
