private _unit = _this select 0;
private _source = _this select 3;
private _projectile = _this select 4;
private _instigator = _this select 6;

if (player != _unit) exitWith 
{
	_unit removeEventHandler ["HandleDamage", _thisEventHandler];
	nil
}; 
_instigator = [_unit, _source, _instigator] call DOTT_tracker_fnc_findInstigator;
if (!isNull _instigator) then 
{
	private _instigatorName = [_instigator] call DOTT_tracker_fnc_getInstigatorName;
	_unit setVariable ["DOTT_tracker_backupInstigatorName", _instigatorName];					 
	_unit setVariable ["DOTT_tracker_lastNonNullInstigator", _instigator];
	_unit setVariable ["DOTT_tracker_lastDistance", round (_unit distance _instigator)];
};	
_unit setVariable ["DOTT_tracker_lastInstigatorWeapon", [_unit, _projectile, _instigator] call DOTT_tracker_fnc_getWeapon];

nil