params ["_projectile", "_hitEntity"];

if !(alive _hitEntity) exitWith {};
private _instigatorInfo = _projectile getVariable "DOTT_instigatorInfo";

if (_hitEntity isKindOf "Man") exitWith { _hitEntity setVariable ["DOTT_lastHit", _instigatorInfo] };

//if vehicle is already going to blow up don't record any more damage so the kill is hopefully credited properly
private _hitHull = _hitEntity getHitPointDamage "hitHull";
if ((_hitEntity isKindOf "Car") && _hitHull >= 1) exitWith {};
if (_hitHull >= .889) exitWith {};

{ if (alive _x) then { _x setVariable ["DOTT_lastHit", _instigatorInfo] } }
forEach (crew _hitEntity);

_hitEntity setVariable ["DOTT_lastHit", _instigatorInfo];
