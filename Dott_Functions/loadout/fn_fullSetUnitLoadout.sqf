/**
 * Function: TN_loadout_fnc_fullSetUnitLoadout
 * Author:   Bae [29th ID]
 *
 * Purpose: Wrapper around CBA_fnc_setLoadout that also resets weapon
 *          state (silent weapon bug fix) and reapplies insignia once
 *          the reset finishes. Prefer spawning this over calling
 *          setUnitLoadout directly.
 *
 * Params:
 *   _unit          - Object, must be local and alive
 *   _loadout       - Array, CBA extended loadout
 *   _fullMagazines - Bool, true to use full magazines
 *
 * Returns: false if _unit is not local or alive, true otherwise
 *
 * Reference:
 *   https://cbateam.github.io/CBA_A3/docs/files/loadout/fnc_setLoadout-sqf.html
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
