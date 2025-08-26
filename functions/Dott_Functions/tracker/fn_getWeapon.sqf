/*
 * Name:	fnc_getWeapon
 * Date:	8/26/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Attempts to find the weapon/vehicle that was used by the instigator.
 *
 * Parameter(s): 
 * [_projectile, _instigator] reference HandleDamage event.
 *
 * Returns:
 * Best guess of the weapon/vehicle that was used by the instigator. 
 *
 * Example:
 * [_projectile, _instigator] call DOTT_tracker_fnc_getWeapon;
 * 
 */

params["_projectile", "_instigator"];
if (_projectile == "") exitWith { DOTT_tracker_lastInstigatorWeapon };
//not in vehicle
if (vehicle _instigator isEqualTo _instigator) then 
{
	//Check if damage was done by handheld frag grenade
	private _cfg = configFile >> "CfgAmmo" >> _projectile; 
	private _damageType = getText(_cfg >> "ACE_damageType");  
	if(_damageType == "grenade") then {
		//ace fragmentation can come from many sources, so default to last known weapon
		//if ((_projectile find "ace_frag") == 0) exitWith { DOTT_tracker_lastInstigatorWeapon };
		if (count (getArray (_cfg >> "ace_grenades_pullPinSound")) > 0) then { "Grenade" }
		else 
		{ 
			private _weaponText = getText (configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName");
			{
				if (_weaponText find _x != -1) exitWith {_weaponText = _x};
			}
			forEach DOTT_tracker_attachedGLs;

			_weaponText = _weaponText + " GL";
			_weaponText
		}
	} else 
	{
		//return weapon in hand (best guess)
		//shorten weapon name by removing eveything in parenthesis
		private _weaponText = getText (configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName");
		private _pos = _weaponText find " (";
		if (_pos != -1) then { _weaponText = _weaponText select [0, _pos] };
		_weaponText;
	};
} else
{
	getText(configFile >> "CfgVehicles" >> typeOf (vehicle _instigator) >> "displayName")
};