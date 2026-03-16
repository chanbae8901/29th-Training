/**
 * Function: TN_radio_fnc_remove
 * Author:   Rellikplug AKA Hill [29th ID]
 *
 * Description:
 *   Deletes the SR radio in the linked slot and the LR backpack
 *   radio, if either exist on the given unit.
 *
 * Parameters:
 *   _unit (Object) - Local unit to strip radios from
 *
 * Returns:
 *   Array - [removedSR <Bool>, removedLR <Bool>]
 */

if !(isClass (configFile >> "CfgPatches" >> "task_force_radio_items")) exitWith {};

params ["_unit"];

private _sw = false;
private _lr = false;

// Remove the first SW radio found in the linked slot.
private _swRadios = [_unit] call TFAR_fnc_getRadioItems;

if (count _swRadios > 0) then
{
    _unit unlinkItem (_swRadios select 0);
    _sw = true;
};

// Remove LR backpack radio if present.
if ((backpack _unit) call TFAR_fnc_isLRRadio) then
{
    removeBackpack _unit;
    _lr = true;
};

[_sw, _lr]
