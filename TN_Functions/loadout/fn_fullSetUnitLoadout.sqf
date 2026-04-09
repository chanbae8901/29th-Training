#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Wrapper around CBA_fnc_setLoadout that attempts to reset weapon
 * state (silent weapon bug fix) and reapplies insignia once
 * the reset finishes. Prefer calling this over calling
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
 * [_unit, _loadout, true] call TN_loadout_fnc_fullSetUnitLoadout;
 */

params ["_unit"];

if (!local _unit) exitWith {
    ["Unit %1 must be local.", _unit] call BIS_fnc_error;
    false;
};

if (!alive _unit) exitWith { false };

GVAR(settingLoadout) = true;

_this spawn 
{
    params ["_unit", "_loadout", "_fullMagazines"];

    removeAllWeapons _unit;
    removeAllItems _unit;
    removeBackpack _unit;
    removeVest _unit;
    removeUniform _unit;
    removeHeadgear _unit;
    removeGoggles _unit;

    sleep 2;
    waitUntil {!isSwitchingWeapon _unit};

    [_unit, _loadout, _fullMagazines] call CBA_fnc_setLoadout;

    // Don't pull out weapon if no primary.
    if (primaryWeapon _unit isEqualTo "") then {
        _unit action ["SwitchWeapon", _unit, _unit, -1];
    };

    sleep 1;
    
    GVAR(settingLoadout) = nil;
    [QGVAR(afterSetLoadout), _unit] call CBA_fnc_localEvent;
};

true
