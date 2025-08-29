/*
 * Name:	fnc_getWeapon
 * Date:	8/26/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Attempts to find the weapon/vehicle that was used by the instigator.
 * Requires ACE 3.
 *
 * Parameter(s): 
 * [_unit, _projectile, _instigator] reference HandleDamage event.
 *
 * Returns:
 * (String) Best guess of the weapon/vehicle that was used by the instigator. 
 *
 * Example:
 * [_unit, _projectile, _instigator] call DOTT_tracker_fnc_getWeapon;
 * 
 */

params["_unit", "_projectile", "_instigator"];
if (_projectile == "") exitWith { _unit getVariable "DOTT_tracker_lastInstigatorWeapon" };
//not in vehicle
if (!isNull _instigator && !((vehicle _instigator) isEqualTo _instigator)) exitWith
{
	private _vicText = getText(configFile >> "CfgVehicles" >> typeOf (vehicle _instigator) >> "displayName");
	if (_vicText == "") then {_vicText = typeOf (vehicle _instigator)};
	_vicText
};

//Check if damage was done by handheld frag grenade
private _cfg = configFile >> "CfgAmmo" >> _projectile; 
private _damageType = getText(_cfg >> "ACE_damageType"); 
private _weaponText = "";
switch (_damageType) do 
{
	case "grenade":
	{
		//ace fragmentation can come from many sources, so default to last known weapon
		if ((_projectile find "ace_frag") == 0) exitWith { _weaponText = _unit getVariable "DOTT_tracker_lastInstigatorWeapon" };

		if (count (getArray (_cfg >> "ace_grenades_pullPinSound")) > 0) then { _weaponText = "Grenade" }
		else 
		{ 
			_weaponText = getText (configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName");
			{
				if (_weaponText find _x != -1) exitWith {_weaponText = _x};
			}
			forEach DOTT_tracker_attachedGLs;

			if (_weaponText find "GL" == -1) then {_weaponText = _weaponText + " GL"};
		}
	};
	case "explosive":
	{
		isChildOf = { 
			params ["_class", "_base"]; 
		
			private _cfg = configFile >> "CfgAmmo" >> _class; 
			if (!isClass _cfg) exitWith {false}; 
		
			while {true} do { 
				private _parent = inheritsFrom _cfg; 
				if (isNull _parent) exitWith {false};              
				private _pName = configName _parent; 
				if (_pName == _base) exitWith {true};               
				_cfg = _parent;                                    
			}; 
		};

		switch (true) do {
			case (count (getArray (_cfg >> "ace_grenades_pullPinSound")) > 0):
			{
				_weaponText = "Thrown Explosive";

				switch (_projectile) do 
				{
					case "ACE_DemoCharge_Remote_Ammo_Thrown": { _weaponText = "Thrown Demo" };
					case "ACE_SatchelCharge_Remote_Ammo_Thrown": { _weaponText = "Thrown Satchel" };
				};
			};
			case ([_projectile, "TimeBombCore"] call isChildOf):
			{
				_weaponText = "Placed Explosive";
				switch (_projectile) do 
				{
					case "DemoCharge_Remote_Ammo": { _weaponText = "Placed Demo" };
					case "SatchelCharge_Remote_Ammo": { _weaponText = "Placed Satchel" };
				};				
			};
			case ([_projectile, "RocketBase"] call isChildOf):
			{
				_weaponText = "Rocket Launcher";
				private _launcher = secondaryWeapon _instigator;

				if (_launcher != "") then {
					_weaponText = getText (configFile >> "CfgWeapons" >> _launcher >> "displayName");
				};						
			};	
			case ([_projectile, "MissileBase"] call isChildOf):
			{
				_weaponText = "Missile Launcher";
				private _launcher = secondaryWeapon _instigator;

				if (_launcher != "") then {
					_weaponText = getText (configFile >> "CfgWeapons" >> _launcher >> "displayName");
				};						
			};						
			default
			{
				if (isNull _instigator) exitWith { _weaponText = _unit getVariable "DOTT_tracker_lastInstigatorWeapon" };
				//return weapon in hand (best guess)
				//shorten weapon name by removing eveything in parenthesis
				_weaponText = getText (configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName");
				private _pos = _weaponText find " (";
				if (_pos != -1) then { _weaponText = _weaponText select [0, _pos] };
				_pos = _weaponText find " GL";
				if (_pos != -1) then { _weaponText = _weaponText select [0, _pos] };				
			};				
		}
	};		
	default
	{
		if (isNull _instigator) exitWith { _weaponText = _unit getVariable "DOTT_tracker_lastInstigatorWeapon" };		
		//return weapon in hand (best guess)
		//shorten weapon name by removing eveything in parenthesis
		_weaponText = getText (configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName");
		private _pos = _weaponText find " (";
		if (_pos != -1) then { _weaponText = _weaponText select [0, _pos] };
		_pos = _weaponText find " GL";
		if (_pos != -1) then { _weaponText = _weaponText select [0, _pos] };		
	};
};

_weaponText
