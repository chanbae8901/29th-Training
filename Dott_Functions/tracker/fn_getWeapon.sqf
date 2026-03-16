/**
 * Function: TN_tracker_fnc_getWeapon
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Returns a string best describing the weapon used for infantry.
 *
 * Parameters:
 * [_weapon, _muzzle, _magazine, _ammo, _vehicle] reference
 *     FiredMan event.
 * NOTE: For optimization, these are assumed to be assigned by
 * the caller (assumed FiredMan event).
 *
 * Returns:
 * String
 */

private _weaponCfg =
    configFile >> "CfgWeapons" >> _weapon;
_weaponCfg = [_weaponCfg, _weaponCfg >> _muzzle]
    select (_weapon != _muzzle);
private _weaponName =
    getText (_weaponCfg >> "displayName");

if (isNull _vehicle) then
{
    // Hand grenade case.
    if (_weapon == "Throw") exitWith
    {
        // Sometimes short is longer than non-short.
        private _fullName = getText (
            configFile >> "CfgMagazines"
                >> _magazine >> "displayName"
        );
        private _shortName = getText (
            configFile >> "CfgMagazines"
                >> _magazine >> "displayNameShort"
        );

        if (_shortName isEqualTo "") exitWith
        {
            _fullName;
        };
        [_fullName, _shortName]
            select (count _shortName < count _fullName);
    };

    // RHS disposable launcher case.
    if (getNumber (_weaponCfg >> "rhs_disposable") == 1)
        exitWith { _weaponName };

    // Strip unneeded/misleading text if infantry weapon.
    if (_weapon == _muzzle) then
    {
        private _pos = _weaponName find " (";
        if (_pos != -1) then
        {
            _weaponName = _weaponName select [0, _pos];
        };
        _pos = _weaponName find " GL";
        if (_pos != -1) then
        {
            _weaponName = _weaponName select [0, _pos];
        };
    };
    private _strs = [_weaponName];

    if (getNumber (
        configFile >> "CfgAmmo"
            >> _ammo >> "explosive"
    ) > 0) then
    {
        private _shortName = getText (
            configFile >> "CfgMagazines"
                >> _magazine >> "displayNameShort"
        );
        private _longName = getText (
            configFile >> "CfgMagazines"
                >> _magazine >> "displayName"
        );
        private _ammoName = [_shortName, _longName]
            select (_shortName == "");
        _strs pushBack _ammoName;
    };

    _strs joinString " - ";
}
else
{
    private _strs = [];

    if !(_vehicle isKindOf "StaticWeapon") then
    {
        private _vehicleName = getText (
            configFile >> "CfgVehicles"
                >> typeOf _vehicle >> "displayName"
        );
        private _pos = _vehicleName find " (";
        if (_pos != -1) then
        {
            _vehicleName = _vehicleName select [0, _pos];
        };
        _strs pushBack _vehicleName;
    };

    _strs pushBack _weaponName;

    if (
        //getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive") > 0 ||
        getText (
            configFile >> "CfgAmmo"
                >> _ammo >> "simulation"
        ) != "shotBullet"
        //getText (configFile >> "CfgAmmo" >> _ammo >> "weaponType") == "cannon"
        || count getArray (
            _weaponCfg >> "magazineWell"
        ) > 0
    ) then
    {
        private _shortName = getText (
            configFile >> "CfgMagazines"
                >> _magazine >> "displayNameShort"
        );
        private _longName = getText (
            configFile >> "CfgMagazines"
                >> _magazine >> "displayName"
        );
        private _ammoName = [_shortName, _longName]
            select (_shortName == "");
        _strs pushBack _ammoName;
    };

    _strs joinString " - ";
};
