#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Handles the ace_explosives_place event for projectile
 * tracking. Attaches instigator/weapon info to the explosive
 * and propagates it through submunitions.
 *
 * Arguments:
 * ace_explosives_place EH params
 *
 * Return Value:
 * Nothing
 */

params ["_explosive", "", "", "_unit"];
// Global EH -- only run on the client who placed.
if (!local _unit) exitWith {};
private _explosiveName = getText (
    configFile >> "CfgMagazines"
        >> getText (
            configFile >> "CfgAmmo"
                >> typeOf _explosive
                >> "defaultMagazine"
        ) >> "displayName"
);
if (_explosiveName isEqualTo "") then {
    _explosiveName = "Placed Explosive";
};
private _data = [
    name _unit, side (group _unit),
    getPosASL _unit, _explosiveName
];
_explosive setVariable [QGVAR(instigatorInfo), _data];
_explosive addEventHandler ["HitPart", FUNC(onHit)];
_explosive addEventHandler ["HitExplosion", FUNC(onHit)];

_explosive addEventHandler ["SubmunitionCreated", {
    params ["_projectile", "_submunitionProjectile"];
    _submunitionProjectile setVariable [
        QGVAR(instigatorInfo),
        _projectile getVariable QGVAR(instigatorInfo)
    ];
    _submunitionProjectile addEventHandler ["HitPart", FUNC(onHit)];
    _submunitionProjectile addEventHandler ["HitExplosion", FUNC(onHit)];
}];

nil
