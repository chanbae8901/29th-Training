params ["_projectile", "_hitEntity"];

if !(alive _hitEntity && _hitEntity isKindOf "AllVehicles") exitWith {};
private _instigatorInfo = _projectile getVariable "DOTT_instigatorInfo";
if (isNil {_instigatorInfo}) exitWith {};

//if vehicle is already going to blow up don't record any more damage so the kill is hopefully credited properly
if (!(_hitEntity isKindOf "Man") && (_hitEntity getHitPointDamage "hitHull") >= .889) exitWith {};
_hitEntity setVariable ["DOTT_lastHit", _instigatorInfo];
