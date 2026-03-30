#include "script_component.hpp"
/*
 * Author: Rellikplug AKA Hill [29th ID]
 * Deletes the SR radio in the linked slot and the LR backpack
 * radio, if either exist on the given unit.
 *
 * Arguments:
 * 0: Local unit to strip radios from <OBJECT>
 *
 * Return Value:
 * [removedSR, removedLR] <ARRAY>
 *
 * Example:
 * [player] call TN_radio_fnc_remove;
 */

if !(isClass (configFile >> "CfgPatches" >> "task_force_radio_items")) exitWith {};

params ["_unit"];

private _sw = false;
private _lr = false;

// Remove the first SW radio found in the linked slot.
private _swRadios = [_unit] call TFAR_fnc_getRadioItems;

if (_swRadios isNotEqualTo []) then {
    _unit unlinkItem (_swRadios select 0);
    _sw = true;
};

// Remove LR backpack radio if present.
if ((backpack _unit) call TFAR_fnc_isLRRadio) then {
    removeBackpack _unit;
    _lr = true;
};

[_sw, _lr]
