/*
 * Name:	fnc_removeRadio
 * Date:	9/10/2018
 * Version: 1.0
 * Author: Rellikplug	AKA: Hill [29th ID]
 *
 * Description:
 * Deletes SR radio in linked slot along with LR backpack, if either exist on unit.
 *
 * Parameter(s): unit: Object - unit to delete radios from
 *
 * Returns:
 * Array in format [removed SR, removed LR]
 *
 * Example:
 * [player] call Hill_fnc_removeRadio;
 * 
 */

if !(hasInterface) exitWith {};
if !(isClass (configfile >> "CfgPatches" >> "task_force_radio_items")) exitWith {};

params ["_unit"];

private _sw = false;
private _lr = false;

if (call TFAR_fnc_haveSWRadio) then 
{
  private _active_sr_radio = call TFAR_fnc_activeSwRadio; //_SwRadio = ((getUnitLoadout _unit select 9) select 2);
  _unit unlinkItem _active_sr_radio;
  _sw = true;
};
if (call TFAR_fnc_haveLRRadio) then 
{
  removeBackpack _unit;
  _lr = true;
};

[_sw,_lr]