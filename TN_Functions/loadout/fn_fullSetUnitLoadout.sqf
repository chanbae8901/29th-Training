/*
 * Author: Bae [29th ID]
 * Wrapper around CBA_fnc_setLoadout that also resets weapon
 * state (silent weapon bug fix) and reapplies insignia once
 * the reset finishes. Prefer spawning this over calling
 * setUnitLoadout directly.
 *
 * Arguments:
 * 0: Unit, must be local and alive <OBJECT>
 * 1: CBA extended loadout <ARRAY>
 * 2: True to use full magazines <BOOL>
 *
 * Return Value:
 * False if unit is not local or alive, true otherwise <BOOL>
 *
 * Example:
 * [player, _loadout, true] spawn TN_loadout_fnc_fullSetUnitLoadout;
 */

params ["_unit", "_loadout", "_fullMagazines"];

if (!local _unit) exitWith
{
    ["Unit %1 must be local.", _unit] call BIS_fnc_error;
    false;
};

if (!alive _unit) exitWith { false };

// Run in unscheduled environment.
isNil
{
    [_unit, _loadout, _fullMagazines]
        call CBA_fnc_setLoadout;
};

// Don't pull out weapon if no primary.
if (primaryWeapon _unit == "") then
{
    _unit action ["SwitchWeapon", _unit, _unit, -1];
};

private _scriptHandle =
    [_unit] spawn TN_loadout_fnc_resetWeaponState;

// Wait so that setInsignia does not correctly assume
// non-combat loadout.
[_unit, _scriptHandle] spawn
{
    params ["_unit", "_scriptHandle"];
    waitUntil { scriptDone _scriptHandle };
    _unit spawn TN_loadout_fnc_setInsignia;
};

true
