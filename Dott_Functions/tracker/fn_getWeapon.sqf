/*
 * File: fn_getWeapon.sqf
 * Function: DOTT_tracker_fnc_getWeapon
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Returns the best human-readable weapon name for a FiredMan
 * event. Handles infantry weapons, grenades, disposable
 * launchers, vehicle weapons, and explosive ammo types.
 *
 * Parameters:
 * [_weapon, _muzzle, _magazine, _ammo, _vehicle]
 * -- from FiredMan event (assigned by caller, accessed via
 *    implicit scope for optimization).
 *
 * Returns:
 * String -- formatted weapon name.
 */

private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
_weaponCfg = [_weaponCfg, _weaponCfg >> _muzzle]
    select (_weapon != _muzzle);
private _weaponName =
    getText (_weaponCfg >> "displayName");

if (isNull _vehicle) then
{
    // -- Hand grenade --
    if (_weapon == "Throw") exitWith
    {
        // Sometimes the "short" name is actually longer
        // than the full name; pick whichever is shorter.
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
            _fullName
        };
        [_fullName, _shortName]
            select (count _shortName < count _fullName)
    };

    // -- RHS disposable launcher --
    if (getNumber (_weaponCfg >> "rhs_disposable") == 1)
        exitWith { _weaponName };

    // Strip parenthetical suffixes and GL labels that add
    // clutter without useful info for infantry weapons.
    if (_weapon == _muzzle) then
    {
        private _pos = _weaponName find " (";
        if (_pos != -1) then
        {
            _weaponName =
                _weaponName select [0, _pos];
        };
        _pos = _weaponName find " GL";
        if (_pos != -1) then
        {
            _weaponName =
                _weaponName select [0, _pos];
        };
    };
    private _strs = [_weaponName];

    // Append ammo name for explosive rounds (e.g. UGL).
    if (getNumber (
        configFile >> "CfgAmmo"
        >> _ammo >> "explosive") > 0) then
    {
        private _shortName = getText (
            configFile >> "CfgMagazines"
            >> _magazine >> "displayNameShort"
        );
        private _longName = getText (
            configFile >> "CfgMagazines"
            >> _magazine >> "displayName"
        );
        private _ammoName =
            [_shortName, _longName]
                select (_shortName == "");
        _strs pushBack _ammoName;
    };

    _strs joinString " - "
}
else
{
    private _strs = [];

    // Include vehicle name unless it's a static weapon
    // (where the weapon name alone is sufficient).
    if !(_vehicle isKindOf "StaticWeapon") then
    {
        private _vehicleName = getText (
            configFile >> "CfgVehicles"
            >> typeOf _vehicle >> "displayName"
        );
        private _pos = _vehicleName find " (";
        if (_pos != -1) then
        {
            _vehicleName =
                _vehicleName select [0, _pos];
        };
        _strs pushBack _vehicleName;
    };

    _strs pushBack _weaponName;

    // Append ammo name for non-bullet rounds or weapons
    // with magazine wells (cannons, missiles, etc.).
    if (getText (
            configFile >> "CfgAmmo"
            >> _ammo >> "simulation")
        != "shotBullet"
        || count getArray (
            _weaponCfg >> "magazineWell") > 0) then
    {
        private _shortName = getText (
            configFile >> "CfgMagazines"
            >> _magazine >> "displayNameShort"
        );
        private _longName = getText (
            configFile >> "CfgMagazines"
            >> _magazine >> "displayName"
        );
        private _ammoName =
            [_shortName, _longName]
                select (_shortName == "");
        _strs pushBack _ammoName;
    };

    _strs joinString " - "
};
