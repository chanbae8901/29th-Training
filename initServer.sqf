#include "data\defines.hpp"
/*
Executed only on server when mission is started.
*/
diag_log text format ["|=============================   %1: initServer.sqf Running   =============================|", missionName];

execVM "scripts\init_vehicle_settings.sqf";

