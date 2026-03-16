/**
 * Function: TN_tracker_fnc_sendHit
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Server-side function that stores hit attribution data on
 * each targeted unit. Maintains both a per-instigator hit map
 * and a "last hit" pointer so kill/unconscious events can
 * determine who was responsible.
 *
 * Parameters:
 * _units (Array): Objects to set hit info on.
 * _instigatorInfo (Array): [name, side, pos, weapon, time].
 *
 * Returns:
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
        _x getVariable "TN_hitMap";
    if (isNil "_hitMap") then
    {
        _hitMap = createHashMap;
    };
    _hitMap set [_key, _value];
    _x setVariable ["TN_lastHit", _key];
    _x setVariable ["TN_hitMap", _hitMap];
}
forEach _units;
