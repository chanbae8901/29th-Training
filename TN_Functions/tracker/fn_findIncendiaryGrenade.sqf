#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Searches for a nearby ACE or RHS incendiary grenade and
 * returns the instigator and weapon name if found.
 *
 * Arguments:
 * 0: Position to search around <ARRAY>
 * 1: Search radius <NUMBER>
 *
 * Return Value:
 * [instigator, weaponName] if found, [] otherwise <ARRAY>
 */

params ["_position", "_radius"];

private _result = [];
{
    if ((typeOf _x) isEqualTo "ACE_G_M14") exitWith {
        _result = [(getShotParents _x) select 0, "ACE AN-M14"];
    };
    if ((typeOf _x) isEqualTo "rhs_ammo_an_m14_th3") exitWith {
        _result = [(getShotParents _x) select 0, "RHS AN-M14"];
    };
}
forEach (_position nearObjects ["GrenadeHand", _radius]);

_result
