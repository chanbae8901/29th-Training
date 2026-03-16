/**
 * Function: TN_loadout_fnc_resetWeaponState
 * Author:   Bae [29th ID]
 *
 * Purpose: Fully removes and re-adds the primary and handgun weapons
 *          to reset internal weapon state, in an attempt to prevent the silent weapon
 *          bug. Also strips and restores all container items so that
 *          addWeapon cannot auto-insert stray magazines.
 *          Does nothing if the unit has no primary weapon.
 *          Must be spawned (uses sleep/waitUntil).
 *
 * Params:  _unit - Object, local unit whose weapons need resetting
 * Returns: Nothing
 *
 * Example: [_unit] spawn TN_loadout_fnc_resetWeaponState;
 */

params ["_unit"];

private _primary = primaryWeapon _unit;
private _primaryItems = primaryWeaponItems _unit;
private _primaryMags = primaryWeaponMagazine _unit;

// Also remove handgun so we don't auto-swap to it when
// removing primary.
private _handgun = handgunWeapon _unit;
private _handgunItems = handgunItems _unit;
private _handgunMags = handgunMagazine _unit;

// Need to remove other loadout items because addWeapon will
// automatically find and insert magazine from them.
private _uniformItems = uniformItems _unit;
private _vestItems = vestItems _unit;
private _backpackItems = backpackItems _unit;

_unit removeWeapon _primary;
_unit removeWeapon _handgun;

{
    _unit removeItemFromUniform _x;
} forEach _uniformItems;

{
    _unit removeItemFromVest _x;
} forEach _vestItems;

{
    _unit removeItemFromBackpack _x;
} forEach _backpackItems;

// Wait until unit is not switching weapon.
waitUntil { sleep 1; !isSwitchingWeapon _unit };

_unit addWeapon _primary;

{
    _unit addPrimaryWeaponItem _x;
} forEach _primaryItems;

// Here instead of below since it makes reload sound after delay.
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
    [_unit, _x, "uniform"] call ace_common_fnc_addToInventory;
} forEach _uniformItems;

{
    [_unit, _x, "vest"] call ace_common_fnc_addToInventory;
} forEach _vestItems;

{
    [_unit, _x, "backpack"] call ace_common_fnc_addToInventory;
} forEach _backpackItems;
