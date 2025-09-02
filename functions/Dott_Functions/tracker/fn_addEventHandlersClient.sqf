params ["_entity"];
//need to use firedPlayer instead of firedMan for ace advanced thrown grenades to count
["ace_firedPlayer", 
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	private _vehicle = objNull;
	private _realWeapon = call DOTT_tracker_fnc_getWeapon;	
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];	

	_projectile addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
		_submunitionProjectile addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];						
	}];					
}] call CBA_fnc_addEventHandler;

["ace_firedPlayerVehicle", 
{
	params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	private _unit = player;
	private _realWeapon = call DOTT_tracker_fnc_getWeapon;
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitExplosion", { call DOTT_tracker_fnc_hitExplosion }];	

	_projectile addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
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
	_explosive addEventHandler ["HitExplosion", { _this call DOTT_tracker_fnc_hitExplosion }];	
	//bouncing mines
	_explosive addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
		_submunitionProjectile addEventHandler ["HitExplosion", { _this call DOTT_tracker_fnc_hitExplosion }];						
	}];		
}] call CBA_fnc_addEventHandler;