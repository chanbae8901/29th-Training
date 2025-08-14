/*
Executed only on server when mission is started.
*/
diag_log text format ["|=============================   %1: initServer.sqf Running   =============================|", missionName];

INDEPENDENT setFriend [WEST, 0];
/*
if (count (entities "HeadlessClient_F") > 0) then {
	systemChat "Headless Client is online. Spawned units will be transferred to the HC.";
	hc_online = true;
	publicVariable "hc_online";
	execVM "scripts\init_hc.sqf";
} else {
	systemChat "Headless Client is offline. Spawned units will be transferred to the server.";
	hc_online = false;
	publicVariable "hc_online";
};
*/

//set-up Parade Inventories
[WEST, "29TH_PARADE_WEST"] call BIS_fnc_addRespawnInventory;
[EAST, "29TH_PARADE_EAST"] call BIS_fnc_addRespawnInventory;
[INDEPENDENT, "29TH_PARADE_INDEPENDENT"] call BIS_fnc_addRespawnInventory;

_autoSpectate = "autoSpectate" call BIS_fnc_getParamValue;
if (_autoSpectate == 1) then {
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

//set-up default date and weather
private _forcedDate     = [2018, 3, 30, 12, 0]; 
private _forcedOvercast = 0.1;
private _forcedFog      = [0.1, 0.01, 0];
[_forcedDate, _forcedOvercast, _forcedFog] execVM "scripts\dateAndWeather.sqf";

//removeRadiosFromDead = "removeRadiosFromDead" call BIS_fnc_getParamValue;
//publicVariable "removeRadiosFromDead";

execVM "scripts\excludeObjFromZeus.sqf";
call DOTT_round_fnc_init;