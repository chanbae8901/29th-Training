/*
 * Name:	fnc_getWeapon
 * Date:	8/26/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Returns string best describing the weapon used.
 *
 * Parameter(s): 
 * [_weapon, _muzzle, _magazine, _ammo, _vehicle] reference FiredMan event.
 *
 * Returns:
 * String
 *
 * Example:
 * [_weapon, _muzzle, _magazine, _ammo, _vehicle] call DOTT_tracker_fnc_getWeapon;
 * 
 */

params["_weapon", "_muzzle", "_magazine", "_ammo", "_vehicle"];

private _weaponName = "";

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
_weaponName = getText(_weaponCfg >> "displayName");

//RHS disposable launcher case
if (getNumber(_weaponCfg >> "rhs_disposable") == 1) exitWith
{
	_weaponName
};


//strip unneeded/misleading text if infantry weapon
if (isNull _vehicle && _weapon == _muzzle) then 
{
	private _pos = _weaponName find " (";
	if (_pos != -1) then { _weaponName = _weaponName select [0, _pos] };
	_pos = _weaponName find " GL";
	if (_pos != -1) then { _weaponName = _weaponName select [0, _pos] };
};

//if infantry used explosive ammo also add that (ex. GL, AT)
//or if vehicle weapon has multiple ammo choices
if ((isNull _vehicle && getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive") > 0) ||
	count getArray(_weaponCfg >> "magazineWell") > 1) then 
{
	private _shortName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayNameShort");
	private _longName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayName");
	private _ammoName = [_shortName, _longName] select (_shortName == "");	
	_weaponName = _weaponName + " - " + _ammoName; 
};

if (!isNull _vehicle) then {
	private _vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");
	private _pos = _vehicleName find " (";
	if (_pos != -1) then { _vehicleName = _vehicleName select [0, _pos] };	
	_weaponName = _vehicleName + " - " + _weaponName;
};

_weaponName

