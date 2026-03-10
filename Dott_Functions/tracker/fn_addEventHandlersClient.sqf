/*
 * File: fn_addEventHandlersClient.sqf
 * Function: DOTT_tracker_fnc_addEventHandlersClient
 * Author: Bae [29th ID]
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

// Shared helper: propagate instigator info through submunitions
// (shotgun pellets, bouncing mines, etc.) and attach hit EHs.
private _fn_addSubmunitionEH =
{
    params ["_projectile"];
    _projectile addEventHandler ["SubmunitionCreated",
    {
        params ["_projectile", "_submunitionProjectile"];
        _submunitionProjectile setVariable
            ["DOTT_instigatorInfo",
             _projectile getVariable
                "DOTT_instigatorInfo"];
        _submunitionProjectile addEventHandler
            ["HitPart", { call DOTT_tracker_fnc_hit }];
        _submunitionProjectile addEventHandler
            ["HitExplosion",
             { call DOTT_tracker_fnc_hit }];
    }];
};

// ---------------------------------------------------------------
// Player fired weapon
// ---------------------------------------------------------------
player addEventHandler ["FiredMan",
{
    params [
        "_unit", "_weapon", "_muzzle", "_mode",
        "_ammo", "_magazine", "_projectile", "_vehicle"
    ];
    private _realWeapon =
        DOTT_weaponNameCache getOrDefaultCall [
            [_weapon, _muzzle, _magazine,
             _ammo, _vehicle],
            {call DOTT_tracker_fnc_getWeapon}, true
        ];

    private _data = [
        name _unit, side (group _unit),
        getPosASL _unit, _realWeapon
    ];
    _projectile setVariable
        ["DOTT_instigatorInfo", _data];
    _projectile addEventHandler
        ["HitPart", { call DOTT_tracker_fnc_hit }];
    _projectile addEventHandler
        ["HitExplosion", { call DOTT_tracker_fnc_hit }];

    _projectile call _fn_addSubmunitionEH;
}];

// ---------------------------------------------------------------
// ACE advanced throwing
// ---------------------------------------------------------------
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
        DOTT_weaponNameCache getOrDefaultCall [
            [_weapon, _muzzle, _magazine,
             _ammo, _vehicle],
            {call DOTT_tracker_fnc_getWeapon}, true
        ];
    private _data = [
        name _unit, side (group _unit),
        getPosASL _unit, _realWeapon
    ];
    _projectile setVariable
        ["DOTT_instigatorInfo", _data];
    _projectile addEventHandler
        ["HitPart", { call DOTT_tracker_fnc_hit }];
    _projectile addEventHandler
        ["HitExplosion", { call DOTT_tracker_fnc_hit }];

    _projectile call _fn_addSubmunitionEH;
}] call CBA_fnc_addEventHandler;

// ---------------------------------------------------------------
// ACE placed explosives
// ---------------------------------------------------------------
["ace_explosives_place",
{
    params ["_explosive", "_dir", "_pitch", "_unit"];
    // Global EH -- only run on the client who placed.
    if (!local _unit) exitWith {};

    private _explosiveName = getText (
        configFile >> "CfgMagazines"
        >> getText (configFile >> "CfgAmmo"
            >> typeOf _explosive >> "defaultMagazine")
        >> "displayName"
    );
    if (_explosiveName == "") then
    {
        _explosiveName = "Placed Explosive";
    };

    private _data = [
        name _unit, side (group _unit),
        getPosASL _unit, _explosiveName
    ];
    _explosive setVariable
        ["DOTT_instigatorInfo", _data];
    _explosive addEventHandler
        ["HitPart", { call DOTT_tracker_fnc_hit }];
    _explosive addEventHandler
        ["HitExplosion", { call DOTT_tracker_fnc_hit }];

    _explosive call _fn_addSubmunitionEH;
}] call CBA_fnc_addEventHandler;

// ---------------------------------------------------------------
// Non-projectile damage: roadkill, fire, fuel explosions
// ---------------------------------------------------------------
DOTT_lastFireCheck = 0;

// Shared side-lookup that handles dead instigators whose group
// side has already flipped to civilian.
private _fn_findSide =
{
    params ["_instigator"];
    private _side = side (group _instigator);
    if (_side == sideUnknown || _side == civilian) then
    {
        // Fallback to config side when group side is
        // unreliable (e.g. dead unit).
        _side = getNumber (
            configFile >> "CfgVehicles"
            >> typeOf _instigator >> "side"
        ) call BIS_fnc_sideType;
    };
    _side
};

["ace_medical_woundReceived",
{
    params ["_unit", "", "_instigator", "_ammo"];

    // Fast exit: most wounds are bullets/frags which are
    // handled by the projectile hit path instead.
    if !(_ammo in [
        "collision", "burn", "fire",
        "FuelExplosion", "FuelExplosionBig"
    ]) exitWith {};

    // -- Roadkill --
    if (_ammo == "collision") then
    {
        private _driver = driver _instigator;
        private _sideInstigator =
            _driver call _fn_findSide;
        if (isNull _driver
            || {_driver isEqualTo _instigator}
            || {_driver distance _unit > 5})
            exitWith {};

        private _weapon =
            ([_instigator] call
                DOTT_tracker_fnc_getName)
            + " - Roadkill";
        private _instigatorInfo = [
            _driver call DOTT_tracker_fnc_getName,
            _sideInstigator,
            getPosASL _driver,
            _weapon,
            round(serverTime - DOTT_tracker_startTime)
        ];

        [[_unit], _instigatorInfo] remoteExecCall
            ["DOTT_tracker_fnc_sendHit", 2];
    };

    // -- Burn damage --
    if (_ammo == "burn") then
    {
        if (!alive _unit) exitWith {};

        private _weapon = "?";

        // Null instigator usually means damage from fire
        // already burning on the person.
        if (isNull _instigator) then
        {
            _instigator = _unit getVariable
                ["DOTT_burnInstigator", objNull];
            _weapon = _unit getVariable
                ["DOTT_burnWeapon", "Fire"];
        }
        else
        {
            // Check for nearby ACE/RHS incendiary grenade.
            private _grenades = (position _unit)
                nearObjects
                    ["GrenadeHand",
                     INFANTRY_GRENADE_DISTANCE];
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
                        == "rhs_ammo_an_m14_th3")
                        exitWith
                    {
                        _weapon = "RHS AN-M14";
                        _instigator =
                            (getShotParents _x) select 0;
                    };
                }
                forEach _grenades;
            };

            if (_weapon != "?") exitWith {};

            // Check vehicle cookoff fires.
            {
                if ((_x select 0) distance
                    (getPosASL _unit)
                    < COOKOFF_DISTANCE) exitWith
                {
                    _instigator = _x select 1;
                    _weapon = "Cookoff Fire";
                };
            }
            forEach DOTT_tracker_cookOffs;
        };

        private _sideInstigator =
            _instigator call _fn_findSide;
        private _instigatorInfo = [
            _instigator call DOTT_tracker_fnc_getName,
            _sideInstigator,
            getPosASL _instigator,
            _weapon,
            round(serverTime - DOTT_tracker_startTime)
        ];

        [[_unit], _instigatorInfo] remoteExecCall
            ["DOTT_tracker_fnc_sendHit", 2];
    };

    // -- Direct fire damage --
    // Burn has ~1s delay so close-range RHS incendiary may
    // kill before burn registers. Fire events are a backup
    // for that case. Throttled to avoid spam.
    if (_ammo == "fire") then
    {
        if (!alive _unit) exitWith {};
        if (time - DOTT_lastFireCheck < 2) exitWith {};

        private _weapon = "?";

        private _grenades = (position _unit)
            nearObjects
                ["GrenadeHand",
                 INFANTRY_GRENADE_DISTANCE];
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
                    == "rhs_ammo_an_m14_th3")
                    exitWith
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
            {
                if ((_x select 0) distance
                    (getPosASL _unit)
                    < COOKOFF_DISTANCE) exitWith
                {
                    _instigator = _x select 1;
                    _weapon = "Cookoff Fire";
                };
            }
            forEach DOTT_tracker_cookOffs;
        };

        DOTT_lastFireCheck = time;

        if (_weapon == "?") exitWith {};

        private _sideInstigator =
            _instigator call _fn_findSide;
        private _instigatorInfo = [
            _instigator call DOTT_tracker_fnc_getName,
            _sideInstigator,
            getPosASL _instigator,
            _weapon,
            round(serverTime - DOTT_tracker_startTime)
        ];

        [[_unit], _instigatorInfo] remoteExecCall
            ["DOTT_tracker_fnc_sendHit", 2];
    };

    // -- Vehicle fuel explosion --
    if (_ammo == "FuelExplosion"
        || _ammo == "FuelExplosionBig") then
    {
        if (isNull _instigator) then
        {
            {
                if ((_x select 0) distance
                    (getPosASL _unit)
                    < EXPLOSION_DISTANCE) exitWith
                {
                    _instigator = _x select 1;
                };
            }
            forEach DOTT_tracker_cookOffs;
        };
        if (isNull _instigator) exitWith {};

        private _weapon = "Vehicle Explosion";
        private _sideInstigator =
            _instigator call _fn_findSide;
        private _instigatorInfo = [
            _instigator call DOTT_tracker_fnc_getName,
            _sideInstigator,
            getPosASL _instigator,
            _weapon,
            round(serverTime - DOTT_tracker_startTime)
        ];

        [[_unit], _instigatorInfo] remoteExecCall
            ["DOTT_tracker_fnc_sendHit", 2];
    };
}] call CBA_fnc_addEventHandler;

// ---------------------------------------------------------------
// Burn simulation tracking
// ---------------------------------------------------------------
// Broadcast burn source variables so fire spreading between
// bodies can still be attributed to the original instigator.
["ace_fire_burnSimulation",
{
    params ["_unit", "_instigator"];
    if (!alive _unit) exitWith {};

    if (!isNull _instigator) then
    {
        _unit setVariable
            ["DOTT_burnInstigator", _instigator, true];
        _unit setVariable
            ["DOTT_burnInstigatorTime", time];
        _unit setVariable
            ["DOTT_burnWeapon", "Fire", true];
    }
    else
    {
        // Skip spatial searches if we recently cached who
        // set this unit on fire.
        if (!isNull (_unit getVariable
                ["DOTT_burnInstigator", objNull])
            && {time - (_unit getVariable
                ["DOTT_burnInstigatorTime", -999])
                < 5}) exitWith {};

        // Check for nearby ACE incendiary grenade
        // (RHS variant doesn't set people on fire).
        private _grenades = (position _unit)
            nearObjects
                ["ACE_G_M14", INFANTRY_GRENADE_DISTANCE];
        if (count _grenades > 0) then
        {
            private _grenade = _grenades select 0;
            _unit setVariable [
                "DOTT_burnInstigator",
                (getShotParents _grenade) select 0,
                true
            ];
            _unit setVariable
                ["DOTT_burnInstigatorTime", time];
            _unit setVariable
                ["DOTT_burnWeapon", "ACE AN-M14", true];
        }
        else
        {
            // Check cookoff fires.
            {
                if ((_x select 0) distance
                    (getPosASL _unit)
                    < COOKOFF_DISTANCE) exitWith
                {
                    _unit setVariable [
                        "DOTT_burnInstigator",
                        _x select 1, true
                    ];
                    _unit setVariable
                        ["DOTT_burnInstigatorTime", time];
                    _unit setVariable [
                        "DOTT_burnWeapon",
                        "Cookoff Fire", true
                    ];
                };
            }
            forEach DOTT_tracker_cookOffs;

            // Check for nearby burning people spreading
            // fire to this unit.
            if (isNull _instigator) then
            {
                private _men = (position _unit)
                    nearObjects ["Man", 5];
                {
                    private _burnInstigator =
                        _x getVariable
                            ["DOTT_burnInstigator",
                             objNull];
                    if (!isNull _burnInstigator)
                        exitWith
                    {
                        private _burnWeapon =
                            _x getVariable
                                ["DOTT_burnWeapon",
                                 "Fire"];
                        _unit setVariable [
                            "DOTT_burnInstigator",
                            _burnInstigator, true
                        ];
                        _unit setVariable [
                            "DOTT_burnInstigatorTime",
                            time
                        ];
                        _unit setVariable [
                            "DOTT_burnWeapon",
                            _burnWeapon, true
                        ];
                    };
                }
                forEach _men;
            };
        };
    };
}] call CBA_fnc_addEventHandler;

// ---------------------------------------------------------------
// Vehicle kill -> cookoff tracking
// ---------------------------------------------------------------
addMissionEventHandler ["EntityKilled",
{
    params ["_unit", "_killer", "_instigator"];
    if !(_unit isKindOf "AllVehicles") exitWith {};
    if (_unit isKindOf "Man") exitWith {};

    // Delayed vehicle explosions often lack an instigator.
    if (isNull _instigator) then
    {
        _instigator = effectiveCommander _killer;
    };
    if (isNull _instigator) then
    {
        private _grenades = (position _unit)
            nearObjects
                ["GrenadeHand",
                 VEHICLE_GRENADE_DISTANCE];
        {
            if ((typeOf _x) == "ACE_G_M14"
                || (typeOf _x)
                    == "rhs_ammo_an_m14_th3")
                exitWith
            {
                _instigator =
                    (getShotParents _x) select 0;
            };
        }
        forEach _grenades;
    };
    if (isNull _instigator) exitWith {};

    DOTT_tracker_cookOffs pushBack
        [getPosASL _unit, _instigator];
}];

// ---------------------------------------------------------------
// Player respawn: clear burn tracking state
// ---------------------------------------------------------------
player addEventHandler ["Respawn",
{
    params ["_unit"];
    _unit setVariable ["DOTT_burnInstigator", nil];
    _unit setVariable ["DOTT_burnInstigatorTime", nil];
    _unit setVariable ["DOTT_burnWeapon", nil];
}];

true
