params["_instigator"];
private _instigatorName ="";
//if unit is not man then name does not work properly
if (_instigator isKindOf "Man") then 
{
	_instigatorName = name _instigator;
} else 
{
	_instigatorName = getText (configFile >> "CfgVehicles" >> typeOf _instigator >> "displayName");
	if (_instigatorName == "") then {_instigatorName = "Vehicle"}; 
};

_instigatorName