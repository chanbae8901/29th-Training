#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Server-side function that stores hit attribution data on
 * each targeted unit. Maintains both a per-instigator hit map
 * and a "last hit" pointer so kill/unconscious events can
 * determine who was responsible.
 *
 * Arguments:
 * 0: Objects to set hit info on <ARRAY>
 * 1: Instigator info [name, side, pos, weapon, time] <ARRAY>
 *
 * Return Value:
 * Nothing
 */

params ["_units", "_instigatorInfo"];

// name, side
private _key = [
    _instigatorInfo select 0,
    _instigatorInfo select 1
];
// firing pos, weapon, time
private _value = [
    _instigatorInfo select 2,
    _instigatorInfo select 3,
    _instigatorInfo select 4
];

{
    private _hitMap =
        _x getVariable QGVAR(hitMap);
    if (isNil "_hitMap") then {
        _hitMap = createHashMap;
    };
    _hitMap set [_key, _value];
    _x setVariable [QGVAR(lastHit), _key];
    _x setVariable [QGVAR(hitMap), _hitMap];
}
forEach _units;

nil
