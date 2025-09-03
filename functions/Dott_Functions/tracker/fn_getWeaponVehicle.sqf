/*
 * Name:	DOTT_tracker_fnc_getWeaponVehicle
 * Date:	9/2/2025
 * Version: 1.1
 * Author:  Bae [29th ID]
 *
 * Description:
 * Returns string best describing the weapon used for vehicles
 *
 * Parameter(s): 
 * [_weapon, _muzzle, _magazine, _ammo, _vehicle] reference FiredMan event.
 * NOTE: For optimization, these are assumed to be assigned by the caller (assumed FiredMan event).
 *
 * Returns:
 * String
 *
 * Example:
 * call DOTT_tracker_fnc_getWeaponVehicle;
 * 
 */

private _strs = [];
private _weaponName = "";

private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;

_weaponCfg = [_weaponCfg, _weaponCfg >> _muzzle] select (_weapon != _muzzle);
_weaponName = getText(_weaponCfg >> "displayName");

if !(_vehicle isKindOf "StaticWeapon") then 
{
	private _vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");
	private _pos = _vehicleName find " (";
	if (_pos != -1) then { _vehicleName = _vehicleName select [0, _pos] };	
	_strs pushBack _vehicleName;
};

_strs pushBack _weaponName;

if (//getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive") > 0 || 
	getText (configFile >> "CfgAmmo" >> _ammo >> "simulation") != "shotBullet" ||
	//getText (configFile >> "CfgAmmo" >> _ammo >> "weaponType") == "cannon" ||
	count getArray(_weaponCfg >> "magazineWell") > 0) then 
{
	private _shortName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayNameShort");
	private _longName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayName");
	private _ammoName = [_shortName, _longName] select (_shortName == "");	
	_strs pushBack _ammoName; 
};

_strs joinString " - ";