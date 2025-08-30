params["_unit"];
private _name = "";
if (isNull _unit) exitWith { _name };
//if unit is not man then name does not work properly
if (_unit isKindOf "Man") then 
{
	_name = name _unit;
} else 
{
	_name = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
	if (_name == "") then {_name = "Vehicle"}; 
};

_name