/**
 * Function: TN_settings_fnc_initDisplayMissionOptions
 * Author:   Bae [29th ID]
 *
 * Entry point for the DOTT mission-settings dialog.
 * Builds the addon/category sidebar, wires the OK button
 * to save temporary overrides, and lazy-compiles client
 * GUI helpers on first open.
 *
 * Stripped-down fork of CBA's settings addon, limited to
 * list / slider / time / checkbox types.  Last modified
 * Dec 2025.  Original license:
 * https://github.com/CBATeam/CBA_A3?tab=GPL-2.0-1-ov-file
 *
 * Params:
 *   _display - the RscDisplayMissionOptions display
 * Return: none
 */

/* The functions in the folder containing this file are
heavily stripped down versions from CBA's settings addon,
modified to let the user change certain global CBA settings
temporarily until the end of the mission. Last modified
Dec 2025. Original source license can be found here:
https://github.com/CBATeam/CBA_A3?tab=GPL-2.0-1-ov-file#readme
Right now only supports list, slider, time, and checkbox
settings. Unknown behavior if anything else is added to
the cba mission settings.
*/
params ["_display"];
uiNamespace setVariable [
    "TN_settings_display", _display
];
#include "fn_initClient.inc.sqf"

private _ctrlAddonsGroup =
    _display displayCtrl 4301;

with uiNamespace do
{
    TN_settings_serverTemp =
        _display ctrlCreate ["RscText", -1];
};

private _ctrlAddonList = _display ctrlCreate [
    "cba_settings_AddonsList", -1, _ctrlAddonsGroup
];

_ctrlAddonList ctrlAddEventHandler [
    "LBSelChanged",
    {_this call TN_settings_fnc_gui_addonChanged}
];

_display setVariable ["cba_settings_lists", []];

private _categories = [];
{
    (TN_settings_default getVariable _x) params [
        "", "", "", "", "_category"
    ];
    private _categoryLower = toLower _category;

    if !(_categoryLower in _categories) then
    {
        private _categoryLocalized = _category;
        if (isLocalized _category) then
        {
            _categoryLocalized = localize _category;
        };

        private _index =
            _ctrlAddonList lbAdd _categoryLocalized;
        _ctrlAddonList lbSetData [_index, str _index];
        _display setVariable [
            str _index, _categoryLower
        ];

        _categories pushBack _categoryLower;
    };
} forEach TN_settings_allSettings;

lbSort _ctrlAddonList;
_ctrlAddonList lbSetCurSel (
    uiNamespace getVariable [
        "TN_settings_addonIndex", 0
    ]
);

_ctrlAddonsGroup
    call TN_settings_fnc_gui_sourceChanged;

private _ctrlScriptedOK = _display displayCtrl 999;
_ctrlScriptedOK ctrlEnable false;
_ctrlScriptedOK ctrlShow false;

private _ctrlConfirm = _display ctrlCreate [
    "RscButtonMenuOK", 2
];
_ctrlConfirm ctrlSetPosition
    ctrlPosition _ctrlScriptedOK;
_ctrlConfirm ctrlCommit 0;
_ctrlConfirm ctrlAddEventHandler [
    "ButtonClick",
    {call TN_settings_fnc_gui_saveTempData}
];
