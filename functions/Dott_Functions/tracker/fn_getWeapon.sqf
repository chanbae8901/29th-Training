/*
 * Name:	DOTT_tracker_fnc_getWeapon
 * Date:	9/2/2025
 * Version: 1.1
 * Author:  Bae [29th ID]
 *
 * Description:
 * Returns string best describing the weapon used for infantry.
 *
 * Parameter(s): 
 * [_weapon, _muzzle, _magazine, _ammo, _vehicle] reference FiredMan event.
 * NOTE: For optimization, these are assumed to be assigned by the caller (assumed FiredMan event).
 *
 * Returns:
 * String
 *
 * Example:
 * call DOTT_tracker_fnc_getWeapon;
 * 
 */

//Hand grenade case
if (_weapon == "Throw") exitWith 
{
	//sometimes short is longer than non-short
	private _fullName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayName");
	private _shortName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayNameShort");

	if (_shortName isEqualTo "") exitWith { _fullName };
	[_fullName, _shortName] select (count _shortName < count _fullName);
};

private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;

_weaponCfg = [_weaponCfg, _weaponCfg >> _muzzle] select (_weapon != _muzzle);
private _weaponName = getText(_weaponCfg >> "displayName");

//RHS disposable launcher case
if (getNumber(_weaponCfg >> "rhs_disposable") == 1) exitWith { _weaponName };

//strip unneeded/misleading text if infantry weapon
if (_weapon == _muzzle) then 
{
	private _pos = _weaponName find " (";
	if (_pos != -1) then { _weaponName = _weaponName select [0, _pos] };
	_pos = _weaponName find " GL";
	if (_pos != -1) then { _weaponName = _weaponName select [0, _pos] };
};
private _strs = [_weaponName];

if (getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive") > 0) then 
{
	private _shortName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayNameShort");
	private _longName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayName");
	private _ammoName = [_shortName, _longName] select (_shortName == "");	
	_strs pushBack _ammoName; 
};

_strs joinString " - ";

