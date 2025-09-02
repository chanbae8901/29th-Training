//only relevant on client hosted
["ace_firedPlayer", 
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	private _vehicle = objNull;
	private _realWeapon = call DOTT_tracker_fnc_getWeapon;	
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];

	_projectile addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
		_submunitionProjectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];
	}];
}] call CBA_fnc_addEventHandler;

//only relevant on client hosted
["ace_firedPlayerVehicle", 
{
	params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	private _unit = (getShotParents _projectile) select 1;
	private _realWeapon = call DOTT_tracker_fnc_getWeapon;
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];

	_projectile addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
		_submunitionProjectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];						
	}];					
}] call CBA_fnc_addEventHandler;

["ace_firedPlayerNonLocal", 
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	private _vehicle = objNull;
	private _realWeapon = call DOTT_tracker_fnc_getWeapon;	
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];

	_projectile addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
		_submunitionProjectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];						
	}];			
}] call CBA_fnc_addEventHandler;

["ace_firedPlayerVehicleNonLocal", 
{
	params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	private _unit = (getShotParents _projectile) select 1;
	private _realWeapon = call DOTT_tracker_fnc_getWeapon;
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];	

	_projectile addEventHandler ["SubmunitionCreated", 
	{
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
		_submunitionProjectile addEventHandler ["HitPart", { call DOTT_tracker_fnc_hitPart }];						
	}];					
}] call CBA_fnc_addEventHandler;
