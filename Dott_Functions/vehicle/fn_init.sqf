/**
 * Function: TN_vehicle_fnc_init
 * Author:   Bae [29th ID]
 *
 * Initializes vehicle settings on the server.
 * - Auto-equips FRIES on helicopters (if ACE loaded).
 * - Strips default vehicle inventories from all current and
 *   future vehicles when the CBA setting is enabled.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     call TN_vehicle_fnc_init;
 */

if (!isServer) exitWith {};

if (isClass (configFile >> "CfgPatches" >> "ace_main")) then
{
    addMissionEventHandler ["EntityCreated",
    {
        if (!TN_autoAddFRIES) exitWith {};

        private _objectCreated = _this;

        if !(isNumber (
            (configOf _objectCreated) >> "ace_fastroping_enabled"
        )) exitWith {};

        if (_objectCreated isKindOf "Helicopter") then
        {
            [_objectCreated] call ace_fastroping_fnc_equipFRIES;
        };
    }];
};

addMissionEventHandler ["EntityCreated",
{
    if !(TN_removeDefaultVehicleInventories) exitWith {};

    private _objectCreated = _this;

    if (_objectCreated isKindOf "AllVehicles"
        && {!(_objectCreated isKindOf "Man")}) then
    {
        clearWeaponCargoGlobal _objectCreated;
        clearMagazineCargoGlobal _objectCreated;
        clearItemCargoGlobal _objectCreated;
        clearBackpackCargoGlobal _objectCreated;
    };
}];

if !(TN_removeDefaultVehicleInventories) exitWith {};

{
    if (_x isKindOf "Man") then { continue };

    clearWeaponCargoGlobal _x;
    clearMagazineCargoGlobal _x;
    clearItemCargoGlobal _x;
    clearBackpackCargoGlobal _x;
} forEach allMissionObjects "AllVehicles";
