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
    TN_tracker_weaponNameCache getOrDefaultCall [
        [_weapon, _muzzle, _magazine, _ammo, _vehicle],
        { call TN_tracker_fnc_getWeapon },
        true
    ];

private _data = [
    name _unit, side (group _unit),
    getPosASL _unit, _realWeapon
];
_projectile setVariable ["TN_instigatorInfo", _data];
_projectile addEventHandler ["HitPart", { call TN_tracker_fnc_handleHit }];
_projectile addEventHandler ["HitExplosion", { call TN_tracker_fnc_handleHit }];

_projectile addEventHandler ["SubmunitionCreated",
{
    params ["_projectile", "_submunitionProjectile"];
    _submunitionProjectile setVariable [
        "TN_instigatorInfo",
        _projectile getVariable "TN_instigatorInfo"
    ];
    _submunitionProjectile addEventHandler ["HitPart", { call TN_tracker_fnc_handleHit }];
    _submunitionProjectile addEventHandler ["HitExplosion", { call TN_tracker_fnc_handleHit }];
}];

nil
