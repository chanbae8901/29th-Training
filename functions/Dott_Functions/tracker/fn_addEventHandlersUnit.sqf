params ["_entity"];
_entity addEventHandler ["FiredMan", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
	private _realWeapon = [_weapon, _muzzle, _magazine, _ammo, _vehicle] call DOTT_tracker_fnc_getWeapon;
	private _data = [name _unit, side (group _unit), getPosATL _unit, _realWeapon];
	_projectile setVariable ["DOTT_instigatorInfo", _data];
	_projectile addEventHandler ["HitPart", {
		_this call DOTT_tracker_fnc_projectileHit;
	}];
	_projectile addEventHandler ["HitExplosion", {
		_this call DOTT_tracker_fnc_projectileHit;
	}];	

	//notably for shotguns
	//recursion shouldn't be needed
	_projectile addEventHandler ["SubmunitionCreated", {
		params ["_projectile", "_submunitionProjectile"];
		_submunitionProjectile setVariable ["DOTT_instigatorInfo", _projectile getVariable "DOTT_instigatorInfo"];		
		_submunitionProjectile addEventHandler ["HitPart", {
			_this call DOTT_tracker_fnc_projectileHit;
		}];
		_submunitionProjectile addEventHandler ["HitExplosion", {
			_this call DOTT_tracker_fnc_projectileHit;
		}];						
	}];					
}];	