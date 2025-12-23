#include "data\defines.hpp"
/*
Executed only on server when mission is started.
*/
diag_log text format ["|=============================   %1: initServer.sqf Running   =============================|", missionName];

#ifdef DOTT_TRAINING

INDEPENDENT setFriend [WEST, 0];

//set-up Parade Inventories
[WEST, "29TH_PARADE_WEST"] call BIS_fnc_addRespawnInventory;
[EAST, "29TH_PARADE_EAST"] call BIS_fnc_addRespawnInventory;
[INDEPENDENT, "29TH_PARADE_INDEPENDENT"] call BIS_fnc_addRespawnInventory;

//set-up default date and weather
private _forcedDate     = [2018, 3, 30, 12, 0]; 
private _forcedOvercast = 0.1;
private _forcedFog      = [0.1, 0.01, 0];
[_forcedDate, _forcedOvercast, _forcedFog] execVM "scripts\dateAndWeather.sqf";

call DOTT_settings_fnc_initServer;

execVM "scripts\excludeObjFromZeus.sqf";

#endif

#ifdef DOTT_EVENT

execVM "scripts\excludeObjFromZeusEvent.sqf";

#endif


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

