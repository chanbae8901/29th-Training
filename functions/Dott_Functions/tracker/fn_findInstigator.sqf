/*
 * Name:	fnc_findInstigator
 * Date:	8/26/2025
 * Version: 1.1
 * Author:  Bae [29th ID]
 *
 * Description:
 * Attempts to find the underlying "Man" that killed _unit. 
 * Referenced note under https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers#EntityKilled
 * and https://github.com/Zealot111/OCAP/blob/27c2dd43147ac51dcd41921cda400fae4f967eb7/addons/ocap/functions/fn_eh_killed.sqf#L11
 *
 * Parameter(s): 
 * [_unit, _killer, _instigator] reference Killed/EntityKilled events.
 *
 * Returns:
 * Best guess of the underlying "Man" that killed _unit. 
 *
 * Example:
 * [_unit, _killer, _instigator] call DOTT_tracker_fnc_findInstigator;
 * 
 */

params["_unit", "_killer", "_instigator"];
//find last damage source that isn't player if they manually respawned or bled out
if (_killer == _unit) then 
{
	_killer = _unit getVariable ["DOTT_tracker_lastNonNullInstigator", _killer]; //this needs to be local
};

//check if the instigator is a UAV
if (isNull _instigator) then 
{
	_instigator = UAVControl vehicle _killer select 0
};

//If we can't figure out, just default to _killer before vehicle check
if ((isNull _instigator) || (_instigator == _unit && !isNull _killer)) then 
{
	_instigator = _killer
};

//if instigator is a vehicle, find who operated it
if (_instigator isKindOf "AllVehicles") then 
{
	_instigator = [_instigator] call 
	{
		params["_instigator"];
		if(alive(gunner _instigator))exitWith{gunner _instigator};
		if(alive(commander _instigator))exitWith{commander _instigator};
		if(alive(driver _instigator))exitWith{driver _instigator};
		effectiveCommander _instigator //if not in vehicle returns player unit
	};
};

//give up, just assume _killer
if (isNull _instigator) then 
{
	_instigator = _killer
};

_instigator