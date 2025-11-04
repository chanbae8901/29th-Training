/*
 * Name:	DOTT_tracker_fnc_getName
 * Date:	9/30/2025
 * Version: 1.1
 * Author:  Bae [29th ID]
 *
 * Description:
 * Returns name of infantry or of vehicle.
 *
 * Parameter(s): 
 * _unit (Object): Player/Vehicle to find name of
 *
 * Returns:
 * String
 *
 * Example:
 * player call DOTT_tracker_fnc_getName;
 * 
 */

params["_unit"];
private _name = "?"; //placeholder in case of null unit (ex. unit deleted but their placed mine still explodes)
if (isNull _unit) exitWith { _name };
if (_unit isKindOf "Man") then 
{
	if (alive _unit) then { _name = name _unit } 
	else { _name = _unit getVariable ["DOTT_name", "?"] };
} else 
{
	_name = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
	if (_name == "") then {_name = "Vehicle"}; 
};

_name