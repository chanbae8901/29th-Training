#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Handles the FiredMan event for projectile tracking.
 * Attaches instigator/weapon info to the projectile and
 * propagates it through submunitions.
 *
 * Arguments:
 * FiredMan EH params
 *
 * Return Value:
 * Nothing
 */

params [
    "_unit", "_weapon", "_muzzle", "",
    "_ammo", "_magazine", "_projectile",
    ["_vehicle", objNull]
];
private _realWeapon =
    GVAR(weaponNameCache) getOrDefaultCall [
        [_weapon, _muzzle, _magazine, _ammo, _vehicle],
        FUNC(getWeapon),
        true
    ];

private _data = [
    name _unit, side (group _unit),
    getPosASL _unit, _realWeapon
];
_projectile setVariable [QGVAR(instigatorInfo), _data];
_projectile addEventHandler ["HitPart", FUNC(onHit)];
_projectile addEventHandler ["HitExplosion", FUNC(onHit)];

_projectile addEventHandler ["SubmunitionCreated", {
    params ["_projectile", "_submunitionProjectile"];
    _submunitionProjectile setVariable [
        QGVAR(instigatorInfo),
        _projectile getVariable QGVAR(instigatorInfo)
    ];
    _submunitionProjectile addEventHandler ["HitPart", FUNC(onHit)];
    _submunitionProjectile addEventHandler ["HitExplosion", FUNC(onHit)];
}];

nil
