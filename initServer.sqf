/*
Executed only on server when mission is started.
*/
diag_log text format ["|=============================   %1: initServer.sqf Running   =============================|", missionName];

INDEPENDENT setFriend [WEST, 0];

//set-up Parade Inventories
[WEST, "29TH_PARADE_WEST"] call BIS_fnc_addRespawnInventory;
[EAST, "29TH_PARADE_EAST"] call BIS_fnc_addRespawnInventory;
[INDEPENDENT, "29TH_PARADE_INDEPENDENT"] call BIS_fnc_addRespawnInventory;

_autoSpectate = "autoSpectate" call BIS_fnc_getParamValue;
if (_autoSpectate == 1) then 
{
	autoSpectate = true;
	publicVariable "autoSpectate";
} else {
	autoSpectate = false;
	publicVariable "autoSpectate";
};

disabledTI = "disabledTI" call BIS_fnc_getParamValue;
publicVariable "disabledTI";

artilleryComputer = "artilleryComputer" call BIS_fnc_getParamValue;
publicVariable "artilleryComputer";

removeDefaultVehicleInventories = "removeDefaultVehicleInventories" call BIS_fnc_getParamValue;

//set-up default date and weather
private _forcedDate     = [2018, 3, 30, 12, 0]; 
private _forcedOvercast = 0.1;
private _forcedFog      = [0.1, 0.01, 0];
[_forcedDate, _forcedOvercast, _forcedFog] execVM "scripts\dateAndWeather.sqf";

//removeRadiosFromDead = "removeRadiosFromDead" call BIS_fnc_getParamValue;
//publicVariable "removeRadiosFromDead";

execVM "scripts\excludeObjFromZeus.sqf";
execVM "scripts\init_vehicle_settings.sqf";

addMissionEventHandler ["OnUserAdminStateChanged", {
	params ["_networkId", "_loggedIn"];
	private _unit = (getUserInfo _networkId) select 10;	
	if (isNil "_unit") exitWith {};
	if (_loggedIn) exitWith 
	{
		if (isNull getAssignedCuratorLogic _unit) then 
		{ 
			_unit assignCurator zeus_admin; 
		};
	};
	[_unit] spawn {
		params ["_unit"];
		if (getAssignedCuratorLogic _unit == zeus_admin) then
		{
			waitUntil { isNull (getAssignedCuratorLogic _unit) };
		};  
		[_unit] spawn Hill_fnc_checkCuratorAssignment;
	}
}];

call DOTT_settings_fnc_initServer;