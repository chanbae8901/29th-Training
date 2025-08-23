diag_log text format ["|=============================   %1: init.sqf Running   =============================|", missionName];

//Prevent tickets/countdown from ending mission
BIS_fnc_endMission = compileFinal "";

//Ensure JIP client is aware of the status of the ticket system
if (isNil "DOTT_ticketEnabled") then { DOTT_ticketEnabled = false; };
if (isNil "DOTT_ticketWEST") then { DOTT_ticketWEST = 0; };
if (isNil "DOTT_ticketEAST") then { DOTT_ticketEAST = 0; };
if (isNil "DOTT_ticketGUER") then { DOTT_ticketGUER = 0; };

call DOTT_round_fnc_init;

if (("enableRoundEventLog" call BIS_fnc_getParamValue) == 1) then {call DOTT_tracker_fnc_init};