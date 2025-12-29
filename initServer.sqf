#include "data\defines.hpp"
/*
Executed only on server when mission is started.
*/
diag_log text format ["|=============================   %1: initServer.sqf Running   =============================|", missionName];

#ifdef DOTT_TRAINING

INDEPENDENT setFriend [WEST, 0];

//set-up default date and weather
private _forcedDate     = [2018, 3, 30, 12, 0]; 
private _forcedOvercast = 0.1;
private _forcedFog      = [0.1, 0.01, 0];
[_forcedDate, _forcedOvercast, _forcedFog] execVM "scripts\dateAndWeather.sqf";

call DOTT_settings_fnc_initServer;

#endif

execVM "scripts\init_vehicle_settings.sqf";

