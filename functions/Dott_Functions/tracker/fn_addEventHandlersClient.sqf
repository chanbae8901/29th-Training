/*
 * Name:	DOTT_tracker_fnc_addEventHandlersClient
 * Date:	9/2/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Adds event handlers client side for tracker system.
 * Some of the HitPart and SubmunitionCreated EH may not be necessary.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_tracker_fnc_addEventHandlersClient;
 * 
 */

player addEventHandler ["FiredMan", 
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
	private _realWeapon = "";
	if (isNull _vehicle) then { _realWeapon = call DOTT_tracker_fnc_getWeapon }
	else { _realWeapon = call DOTT_tracker_fnc_getWeaponVehicle };
	
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];	
	_projectile addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];	

	//shotguns
	_projectile addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];	
		_submunitionProjectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];
		_submunitionProjectile addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];						
	}];					
}];

["ace_advanced_throwing_throwFiredXEH", 
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	if (!local _unit) exitWith {}; //this EH is global so only execute on client who placed
	private _vehicle = objNull;
	private _realWeapon = call DOTT_tracker_fnc_getWeapon;
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];	
	_projectile addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];	

	_projectile addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];	
		_submunitionProjectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];
		_submunitionProjectile addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];						
	}];					
}] call CBA_fnc_addEventHandler;

["ace_explosives_place", 
{
	params ["_explosive", "_dir", "_pitch", "_unit"];
	if (!local _unit) exitWith {}; //this EH is global so only execute on client who placed
	private _explosiveName = getText (configFile >> "CfgMagazines" >> getText (configFile >> "CfgAmmo" >> typeOf _explosive >> "defaultMagazine") >> "displayName");
	if (_explosiveName == "") then {_explosiveName = "Placed Explosive"};
	private _data = [name _unit, side (group _unit), getPosATL _unit, _explosiveName];
	_explosive setVariable ["DOTT_instigatorInfo", _data];
	_explosive addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];	
	_explosive addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];	

	//bouncing mines
	_explosive addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];	
		_submunitionProjectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];
		_submunitionProjectile addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];						
	}];		
}] call CBA_fnc_addEventHandler;

true