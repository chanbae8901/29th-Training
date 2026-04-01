#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Shows/hides the options-group controls so only the
 * panel matching the currently selected addon + source
 * is visible.  Called when the source tab changes.
 *
 * Arguments:
 * 0: The source-tab control that fired <CONTROL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control] call TN_settings_fnc_gui_sourceChanged
 */

params ["_control"];

private _display = ctrlParent _control;
private _selectedSource = "server";

uiNamespace setVariable [
    "cba_settings_source", _selectedSource
];

private _selectedAddon = uiNamespace getVariable QGVAR(addon);

{
    (_x splitString "$") params [
        "", "_addon", "_source"
    ];

    private _ctrlOptionsGroup = _display getVariable _x;
    private _isSelected = _source == _selectedSource && {_addon == _selectedAddon};

    _ctrlOptionsGroup ctrlEnable _isSelected;
    _ctrlOptionsGroup ctrlShow _isSelected;
} forEach (
    _display getVariable "cba_settings_lists"
);

nil
