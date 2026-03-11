/**
 * File: fn_hit.sqf
 * Function: DOTT_tracker_fnc_hit
 * Author: Bae [29th ID]
 *
 * Purpose:
 * HitExplosion/HitPart projectile event handler for the tracker.
 * Transfers weapon/killer info from the projectile to the hit
 * entity so the server can attribute kills correctly.
 * Runs client-side only.
 *
 * DESIGN RISK: There is no guarantee that the hit info sent here
 * via remoteExecCall arrives on the server before the kill/uncon
 * event is processed. The system relies on the assumption that
 * network delivery is fast enough (backed by the 0.5-0.75s delay
 * in fn_init.sqf). In practice this works, but under extreme
 * network conditions it could theoretically fail.
 *
 * Parameters:
 * _projectile (Object): The projectile that hit.
 * _hitEntity (Object): The entity that was hit.
 *
 * Returns:
 * true
 */

params ["_projectile", "_hitEntity"];

// Things like buildings are considered alive.
// If they go through server will get spammed with errors.
if !(alive _hitEntity
    && _hitEntity isKindOf "AllVehicles") exitWith {};

private _instigatorInfo =
    _projectile getVariable "DOTT_instigatorInfo";

// If projectile hits multiple things it can have time of
// hit already.
if (count _instigatorInfo > 4) then
{
    _instigatorInfo deleteAt 4;
};
_instigatorInfo pushBack
    round(serverTime - DOTT_tracker_startTime);

if (_hitEntity isKindOf "Man") exitWith
{
    [[_hitEntity], _instigatorInfo] remoteExecCall
        ["DOTT_tracker_fnc_sendHit", 2];
};

// If vehicle is already going to blow up don't record any
// more damage so the kill is hopefully credited properly.
private _hitHull =
    _hitEntity getHitPointDamage "hitHull";
if (_hitHull >= 1) exitWith {};

private _targets =
    (crew _hitEntity) select { alive _x };
_targets pushBack _hitEntity;
[_targets, _instigatorInfo] remoteExecCall
    ["DOTT_tracker_fnc_sendHit", 2];

true
