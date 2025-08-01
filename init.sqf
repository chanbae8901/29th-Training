diag_log text format ["|=============================   %1: init.sqf Running   =============================|", missionName];

//Run Curator (Zeus) Setup
execVM "scripts\init_curators.sqf";

//Init chat command system
[] execVM "module_chatIntercept\init.sqf";

//Prevent tickets/countdown from ending mission
BIS_fnc_endMission = compileFinal "";

//Ensure JIP client is aware of the status of the ticket system
if (isNil "DOTT_ticketEnabled") then { DOTT_ticketEnabled = false; };
if (isNil "DOTT_ticketWEST") then { DOTT_ticketWEST = 0; };
if (isNil "DOTT_ticketEAST") then { DOTT_ticketEAST = 0; };
if (isNil "DOTT_ticketGUER") then { DOTT_ticketGUER = 0; };