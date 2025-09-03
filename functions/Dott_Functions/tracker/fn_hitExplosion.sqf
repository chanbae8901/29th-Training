/*
 * Name:	DOTT_tracker_fnc_hitExplosion
 * Date:	9/2/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Function to be used in "HitExplosion" projectile event for tracker system.
 * Transfers weapon/killer info from the projectile to the unit hit if conditions are met.
 * Should only be run client side.
 *
 * NOTE: There is no check to ensure that the information is transferred to server fast enough before kill/uncon 
 * events are processed there, it is assumed it will be (which may be wrong).
 *
 * Parameter(s): 
 * [_projectile, _hitEntity] reference "HitExplosion" projectile event.
 *
 * Returns:
 * true
 *
 * Example:
 * player call DOTT_tracker_fnc_hitExplosion;
 * 
 */

params ["_projectile", "_hitEntity"];
//things like buildings are considered alive
//if they go through server will get spammed with errors 
if !(alive _hitEntity && _hitEntity isKindOf "AllVehicles") exitWith {}; 
private _instigatorInfo = _projectile getVariable "DOTT_instigatorInfo";
if (_hitEntity isKindOf "Man") exitWith { _hitEntity setVariable ["DOTT_lastHit", _instigatorInfo, 2] };
//if vehicle is already going to blow up don't record any more damage so the kill is hopefully credited properly
private _hitHull = _hitEntity getHitPointDamage "hitHull";
if ((_hitEntity isKindOf "Car") && _hitHull >= 1) exitWith {};
if (_hitHull >= .889) exitWith {};

{ if (alive _x) then { _x setVariable ["DOTT_lastHit", _instigatorInfo, 2] } }
forEach (crew _hitEntity);

_hitEntity setVariable ["DOTT_lastHit", _instigatorInfo, 2];

true