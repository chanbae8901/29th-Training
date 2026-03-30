#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes vehicle settings.
 * - Applies ACE unconscious seat-lock fix (if ACE loaded).
 * - Auto-equips FRIES on helicopters (if ACE loaded).
 * - Strips default vehicle inventories from all current and
 *   future vehicles when the CBA setting is enabled.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_vehicle_fnc_init;
 */

if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {
    call FUNC(lockFixInit);
};

if (!isServer) exitWith {};

if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {
    //Note that we do not retroactively apply to editor placed helicopters.
    ["Helicopter", "Init", {
        if (!GVARMAIN(autoAddFRIES)) exitWith {};
        params ["_objectCreated"];
        if !(isNumber ((configOf _objectCreated) >> "ace_fastroping_enabled")) exitWith {};
        [_objectCreated] call ace_fastroping_fnc_equipFRIES;
    }] call CBA_fnc_addClassEventHandler;
};

["AllVehicles", "Init", {
    if !(GVARMAIN(removeDefaultVehicleInventories)) exitWith {};
    params ["_objectCreated"];
    clearWeaponCargoGlobal _objectCreated;
    clearMagazineCargoGlobal _objectCreated;
    clearItemCargoGlobal _objectCreated;
    clearBackpackCargoGlobal _objectCreated;
}, true, ["Man"], true] call CBA_fnc_addClassEventHandler;

nil
