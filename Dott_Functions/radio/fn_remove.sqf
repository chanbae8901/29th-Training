/*
 * Name:	DOTT_radio_fnc_remove
 * Date:	03/06/2026
 * Version: 2.0
 * Author: Rellikplug	AKA: Hill [29th ID]
 *
 * Description:
 * Deletes SR radio in linked slot along with LR backpack, if either exist on unit.
 *
 * Parameter(s): unit: Object - local unit to delete radios from
 *
 * Returns:
 * Array in format [removed SR, removed LR]
 *
 * Example:
 * [player] call DOTT_radio_fnc_remove;
 * 
 */

if !(isClass (configfile >> "CfgPatches" >> "task_force_radio_items")) exitWith {};

params ["_unit"];

private _sw = false;
private _lr = false;

private _swRadios = [_unit] call TFAR_fnc_getRadioItems;

if (count _swRadios > 0) then 
{
  _unit unlinkItem (_swRadios select 0); //assume the player only has 1 sw radio 
  _sw = true;
};
if ((backpack _unit) call TFAR_fnc_isLRRadio) then 
{
  removeBackpack _unit;
  _lr = true;
};

[_sw,_lr]