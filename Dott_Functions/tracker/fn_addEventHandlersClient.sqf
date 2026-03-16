/**
 * Function: TN_tracker_fnc_addEventHandlersClient
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Adds client-side event handlers for the tracker system.
 * Attaches instigator/weapon info to projectiles on fire,
 * propagates that info through submunitions, and handles
 * non-projectile damage sources (roadkill, fire, explosions).
 *
 * Parameters:
 * None
 *
 * Returns:
 * true
 */

#define EXPLOSION_DISTANCE 20
#define COOKOFF_DISTANCE 10
#define VEHICLE_GRENADE_DISTANCE 10
#define INFANTRY_GRENADE_DISTANCE 5

player addEventHandler ["FiredMan",
{
    params [
        "_unit", "_weapon", "_muzzle", "_mode",
        "_ammo", "_magazine", "_projectile", "_vehicle"
    ];
    private _realWeapon =
        TN_weaponNameCache getOrDefaultCall [
            [_weapon, _muzzle, _magazine, _ammo, _vehicle],
            { call TN_tracker_fnc_getWeapon },
            true
        ];

    private _data = [
        name _unit, side (group _unit),
        getPosASL _unit, _realWeapon
    ];
    _projectile setVariable ["TN_instigatorInfo", _data];
    _projectile addEventHandler ["HitPart", { call TN_tracker_fnc_hit }];
    _projectile addEventHandler ["HitExplosion", { call TN_tracker_fnc_hit }];

    _projectile addEventHandler ["SubmunitionCreated",
    {
        params ["_projectile", "_submunitionProjectile"];
        _submunitionProjectile setVariable [
            "TN_instigatorInfo",
            _projectile getVariable "TN_instigatorInfo"
        ];
        _submunitionProjectile addEventHandler ["HitPart", { call TN_tracker_fnc_hit }];
        _submunitionProjectile addEventHandler ["HitExplosion", { call TN_tracker_fnc_hit }];
    }];
}];

["ace_advanced_throwing_throwFiredXEH",
{
    params [
        "_unit", "_weapon", "_muzzle", "_mode",
        "_ammo", "_magazine", "_projectile"
    ];
    // Global EH -- only run on the client who threw.
    if (!local _unit) exitWith {};
    private _vehicle = objNull;
    private _realWeapon =
        TN_weaponNameCache getOrDefaultCall [
            [_weapon, _muzzle, _magazine, _ammo, _vehicle],
            { call TN_tracker_fnc_getWeapon },
            true
        ];
    private _data = [
        name _unit, side (group _unit),
        getPosASL _unit, _realWeapon
    ];
    _projectile setVariable ["TN_instigatorInfo", _data];
    _projectile addEventHandler ["HitPart", { call TN_tracker_fnc_hit }];
    _projectile addEventHandler ["HitExplosion", { call TN_tracker_fnc_hit }];

    _projectile addEventHandler ["SubmunitionCreated",
    {
        params ["_projectile", "_submunitionProjectile"];
        _submunitionProjectile setVariable [
            "TN_instigatorInfo",
            _projectile getVariable "TN_instigatorInfo"
        ];
        _submunitionProjectile addEventHandler ["HitPart", { call TN_tracker_fnc_hit }];
        _submunitionProjectile addEventHandler ["HitExplosion", { call TN_tracker_fnc_hit }];
    }];
}] call CBA_fnc_addEventHandler;

["ace_explosives_place",
{
    params ["_explosive", "_dir", "_pitch", "_unit"];
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
    if (_explosiveName == "") then
    {
        _explosiveName = "Placed Explosive";
    };
    private _data = [
        name _unit, side (group _unit),
        getPosASL _unit, _explosiveName
    ];
    _explosive setVariable ["TN_instigatorInfo", _data];
    _explosive addEventHandler ["HitPart", { call TN_tracker_fnc_hit }];
    _explosive addEventHandler ["HitExplosion", { call TN_tracker_fnc_hit }];

    _explosive addEventHandler ["SubmunitionCreated",
    {
        params ["_projectile", "_submunitionProjectile"];
        _submunitionProjectile setVariable [
            "TN_instigatorInfo",
            _projectile getVariable "TN_instigatorInfo"
        ];
        _submunitionProjectile addEventHandler ["HitPart", { call TN_tracker_fnc_hit }];
        _submunitionProjectile addEventHandler ["HitExplosion", { call TN_tracker_fnc_hit }];
    }];
}] call CBA_fnc_addEventHandler;

TN_lastFireCheck = 0;

// Side-lookup that handles dead instigators whose group side
// has already flipped to civilian. Stored as a global so CBA
// event handler scopes can reach it.
TN_tracker_fnc_findSide =
{
    params ["_instigator"];
    private _side = side (group _instigator);
    if (_side == sideUnknown
        || _side == civilian) then // Dead man.
    {
        // Might work improperly if zeus changed
        // player side.
        _side = getNumber (
            configFile >> "CfgVehicles"
                >> typeOf _instigator >> "side"
        ) call BIS_fnc_sideType;
    };
    _side
};

// Easiest way to detect roadkill event.
// Will arrive on server later than projectile hit events
// however.
["ace_medical_woundReceived",
{
    params ["_unit", "", "_instigator", "_ammo"];

    if (_ammo == "collision") then
    {
        private _driver = driver _instigator;
        private _sideInstigator =
            _driver call TN_tracker_fnc_findSide;
        if (
            isNull _driver
            || { _driver isEqualTo _instigator }
            || { _driver distance _unit > 5 }
        ) exitWith {};
        // Seems no need to use vehicle/objectParent.
        private _weapon =
            ([_instigator]
                call TN_tracker_fnc_getName)
            + " - Roadkill";
        private _instigatorInfo = [
            _driver call TN_tracker_fnc_getName,
            _sideInstigator,
            getPosASL _driver,
            _weapon,
            round (serverTime - TN_tracker_startTime)
        ];

        [[_unit], _instigatorInfo] remoteExecCall ["TN_tracker_fnc_sendHit", 2];
    };

    if (_ammo == "burn") then
    {
        // NOTE: Instigator in this case if null means
        // the damage came from fire on person. Otherwise
        // the instigator is the unit itself, which means
        // that it came from a burning damage source
        // directly.

        // Only care here because in FuelExplosion the
        // woundReceived might happen after death
        // (overkill damage override maybe) + lots of
        // events for burn on dead body.
        if (!alive _unit) exitWith {};

        private _weapon = "?";
        // Usually means damage from fire on person.
        if (isNull _instigator) then
        {
            _instigator = _unit getVariable
                ["TN_burnInstigator", objNull];
            _weapon = _unit getVariable
                ["TN_burnWeapon", "Fire"];
        }
        else
        {
            // Look for ACE/RHS incendiary grenade.
            private _grenades = (position _unit)
                nearObjects [
                    "GrenadeHand",
                    INFANTRY_GRENADE_DISTANCE
                ];
            if (count _grenades != 0) then
            {
                {
                    if ((typeOf _x) == "ACE_G_M14")
                        exitWith
                    {
                        _weapon = "ACE AN-M14";
                        _instigator =
                            (getShotParents _x) select 0;
                    };
                    if ((typeOf _x)
                        == "rhs_ammo_an_m14_th3") exitWith
                    {
                        _weapon = "RHS AN-M14";
                        _instigator =
                            (getShotParents _x) select 0;
                    };
                }
                forEach _grenades;
            };

            if (_weapon != "?") exitWith {};

            // Look through cookoffs.
            {
                if (
                    (_x select 0)
                        distance (getPosASL _unit)
                    < COOKOFF_DISTANCE
                ) exitWith
                {
                    _instigator = _x select 1;
                    _weapon = "Cookoff Fire";
                };
            }
            forEach TN_tracker_cookOffs;

            /*
            if (_unit != _instigator) exitWith {};
            //Case where walked away from incendiary grenade/cookoff fire but still on fire?
            if (_weapon == "?") then
            {
                private _burnInstigator = _unit getVariable ["TN_burnInstigator", objNull];
                if (_burnInstigator == _instigator) then
                {
                    _weapon = _unit getVariable ["TN_burnWeapon", "Fire"];
                };
            };
            */
        };
        private _sideInstigator =
            _instigator call TN_tracker_fnc_findSide;
        private _instigatorInfo = [
            _instigator call TN_tracker_fnc_getName,
            _sideInstigator,
            getPosASL _instigator,
            _weapon,
            round (serverTime - TN_tracker_startTime)
        ];

        [[_unit], _instigatorInfo] remoteExecCall ["TN_tracker_fnc_sendHit", 2];
    };

    // Burn has a delay of 1 second so if someone dies
    // before that it won't register (mostly from close
    // RHS Incendiary).
    // Fire triggers very frequently and is harder to work
    // with so we just want as a minimum backup for the
    // above case.
    // Instigator is always null.
    if (_ammo == "fire") then
    {
        if (!alive _unit) exitWith {};
        // Throttle to avoid spam.
        if (time - TN_lastFireCheck < 2) exitWith {};

        private _weapon = "?";
        // Look for ACE/RHS incendiary grenade.
        private _grenades = (position _unit)
            nearObjects [
                "GrenadeHand",
                INFANTRY_GRENADE_DISTANCE
            ];
        if (count _grenades != 0) then
        {
            {
                if ((typeOf _x) == "ACE_G_M14") exitWith
                {
                    _weapon = "ACE AN-M14";
                    _instigator =
                        (getShotParents _x) select 0;
                };
                if ((typeOf _x)
                    == "rhs_ammo_an_m14_th3") exitWith
                {
                    _weapon = "RHS AN-M14";
                    _instigator =
                        (getShotParents _x) select 0;
                };
            }
            forEach _grenades;
        };

        if (_weapon == "?") then
        {
            // Look through cookoffs.
            {
                if (
                    (_x select 0)
                        distance (getPosASL _unit)
                    < COOKOFF_DISTANCE
                ) exitWith
                {
                    _instigator = _x select 1;
                    _weapon = "Cookoff Fire";
                };
            }
            forEach TN_tracker_cookOffs;
        };

        TN_lastFireCheck = time;

        if (_weapon == "?") exitWith {};

        private _sideInstigator =
            _instigator call TN_tracker_fnc_findSide;
        private _instigatorInfo = [
            _instigator call TN_tracker_fnc_getName,
            _sideInstigator,
            getPosASL _instigator,
            _weapon,
            round (serverTime - TN_tracker_startTime)
        ];

        [[_unit], _instigatorInfo] remoteExecCall ["TN_tracker_fnc_sendHit", 2];
    };

    // Vehicle explosion.
    if (_ammo == "FuelExplosion"
        || _ammo == "FuelExplosionBig") then
    {
        if (isNull _instigator) then
        {
            {
                if (
                    (_x select 0)
                        distance (getPosASL _unit)
                    < EXPLOSION_DISTANCE
                ) exitWith
                {
                    _instigator = _x select 1;
                };
            }
            forEach TN_tracker_cookOffs;
        };
        if (isNull _instigator) exitWith {};
        private _weapon = "Vehicle Explosion";
        private _sideInstigator =
            _instigator call TN_tracker_fnc_findSide;
        private _instigatorInfo = [
            _instigator call TN_tracker_fnc_getName,
            _sideInstigator,
            getPosASL _instigator,
            _weapon,
            round (serverTime - TN_tracker_startTime)
        ];

        [[_unit], _instigatorInfo] remoteExecCall ["TN_tracker_fnc_sendHit", 2];
    };
}] call CBA_fnc_addEventHandler;

["ace_fire_burnSimulation",
// We broadcast these variables since burning bodies can
// set people on fire and we need to track that too.
{
    params ["_unit", "_instigator"];
    if (!alive _unit) exitWith {};

    if (!isNull _instigator) then
    {
        _unit setVariable ["TN_burnInstigator", _instigator, true];
        _unit setVariable ["TN_burnInstigatorTime", time];
        _unit setVariable ["TN_burnWeapon", "Fire", true];
    }
    else
    {
        // Skip expensive spatial searches if we recently
        // cached who set this unit on fire.
        if (
            !isNull (_unit getVariable
                ["TN_burnInstigator", objNull])
            && {
                time - (_unit getVariable
                    ["TN_burnInstigatorTime", -999])
                < 5
            }
        ) exitWith {};
        // Look for nearby ACE incendiary grenade (RHS one
        // doesn't set people on fire).
        private _grenades = (position _unit)
            nearObjects [
                "ACE_G_M14", INFANTRY_GRENADE_DISTANCE
            ];
        if (count _grenades > 0) then
        {
            private _grenade = _grenades select 0;
            _unit setVariable [
                "TN_burnInstigator",
                (getShotParents _grenade) select 0,
                true
            ];
            _unit setVariable ["TN_burnInstigatorTime", time];
            _unit setVariable ["TN_burnWeapon", "ACE AN-M14", true];
        }
        else
        {
            // Look through cookoffs.
            {
                if (
                    (_x select 0)
                        distance (getPosASL _unit)
                    < COOKOFF_DISTANCE
                ) exitWith
                {
                    _unit setVariable [
                        "TN_burnInstigator",
                        _x select 1, true
                    ];
                    _unit setVariable [
                        "TN_burnInstigatorTime", time
                    ];
                    _unit setVariable [
                        "TN_burnWeapon",
                        "Cookoff Fire", true
                    ];
                };
            }
            forEach TN_tracker_cookOffs;

            // Look for nearby burning people.
            if (isNull _instigator) then
            {
                private _men = (position _unit) nearObjects ["Man", 5];
                {
                    private _burnInstigator = _x getVariable ["TN_burnInstigator", objNull];
                    if (!isNull _burnInstigator) exitWith
                    {
                        private _burnWeapon = _x getVariable ["TN_burnWeapon", "Fire"];
                        _unit setVariable ["TN_burnInstigator", _burnInstigator, true];
                        _unit setVariable ["TN_burnInstigatorTime", time];
                        _unit setVariable ["TN_burnWeapon", _burnWeapon, true];
                    };
                }
                forEach _men;
            };
        };
    };
}] call CBA_fnc_addEventHandler;

addMissionEventHandler ["EntityKilled",
{
    params ["_unit", "_killer", "_instigator"];
    if !(_unit isKindOf "AllVehicles") exitWith {};
    if (_unit isKindOf "Man") exitWith {};
    // Delayed vehicle explosions seem to not have
    // instigator.
    if (isNull _instigator) then
    {
        _instigator = effectiveCommander _killer;
    };
    if (isNull _instigator) then
    {
        // Look for ACE/RHS incendiary grenade.
        private _grenades = (position _unit) nearObjects ["GrenadeHand", VEHICLE_GRENADE_DISTANCE];
        {
            if (
                (typeOf _x) == "ACE_G_M14"
                || (typeOf _x) == "rhs_ammo_an_m14_th3"
            ) exitWith
            {
                _instigator = (getShotParents _x) select 0;
            };
        }
        forEach _grenades;
    };
    if (isNull _instigator) exitWith {};

    TN_tracker_cookOffs pushBack [getPosASL _unit, _instigator];
}];

player addEventHandler ["Respawn",
{
    params ["_unit"];
    _unit setVariable ["TN_burnInstigator", nil];
    _unit setVariable ["TN_burnInstigatorTime", nil];
    _unit setVariable ["TN_burnWeapon", nil];
}];

true
