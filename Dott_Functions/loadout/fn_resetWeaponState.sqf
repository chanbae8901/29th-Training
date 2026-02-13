/*
 * Name:	DOTT_loadout_fnc_resetWeaponState
 * Date:	02/04/2026
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Attempt reset of weapon state for a unit to prevent silent weapon bug.
 * If no primary weapon, will naturally not do anything.
 *
 * Parameter(s): 
 * _unit: local unit that needs to reset weapon state
 * 
 * Returns:
 * true
 *
 * Example:
 * [_unit] spawn DOTT_loadout_fnc_resetWeaponState;
 * 
 */

params["_unit"];

private _primary = primaryWeapon _unit;
private _primaryItems = primaryWeaponItems _unit;
private _primaryMags = primaryWeaponMagazine _unit;

//also remove handgun so we don't auto-swap to it when removing primary
private _handgun = handgunWeapon _unit;
private _handgunItems = handgunItems _unit;
private _handgunMags = handgunMagazine _unit;

//need to remove other loadout items because addWeapon will automatically find and insert magazine from them
private _uniformItems = uniformItems _unit;
private _vestItems = vestItems _unit;
private _backpackItems = backpackItems _unit;

_unit removeWeapon _primary;
_unit removeWeapon _handgun;

{
	_unit removeItemFromUniform _x;
}
forEach _uniformItems;

{
	_unit removeItemFromVest _x;
}
forEach _vestItems;

{
	_unit removeItemFromBackpack _x;
}
forEach _backpackItems;

waitUntil { sleep 1; !isSwitchingWeapon _unit }; //wait until unit is not switching weapon

_unit addWeapon _primary;

{
	_unit addPrimaryWeaponItem _x;
} forEach _primaryItems;

//here instead of below since it makes reload sound after delay
{
	_unit addMagazine _x;
} forEach _handgunMags;

_unit addWeapon _handgun;

{
	_unit addHandgunItem _x;
} forEach _handgunItems;

sleep 1;

{
	_unit addPrimaryWeaponItem _x;
} forEach _primaryMags;

{
	_unit addItemToUniform _x;
} forEach _uniformItems;

{
	_unit addItemToVest _x;
} forEach _vestItems;

{
	_unit addItemToBackpack _x;
} forEach _backpackItems;