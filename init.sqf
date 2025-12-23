#include "data\defines.hpp"
diag_log text format ["|=============================   %1: init.sqf Running   =============================|", missionName];

//Ensure JIP client is aware of the status of the ticket system
if (isNil "DOTT_ticketEnabled") then { DOTT_ticketEnabled = false; };
if (isNil "DOTT_ticketWEST") then { DOTT_ticketWEST = 0; };
if (isNil "DOTT_ticketEAST") then { DOTT_ticketEAST = 0; };
if (isNil "DOTT_ticketGUER") then { DOTT_ticketGUER = 0; };

call DOTT_round_fnc_init;

#ifdef DOTT_TRAINING
if (("enableRoundEventLog" call BIS_fnc_getParamValue) == 1) then {call DOTT_tracker_fnc_init};
#endif

#ifdef DOTT_EVENT

call DOTT_event_fnc_init;

//Add actions to spectator terminals, garbage cans, and ammo boxes - Moved here from initPlayerLocal due to variable from event init needed
if (hasInterface) then {execVM "scripts\baseObjectsInitEvent.sqf"};

#endif

call DOTT_fnc_initTransferRadioSettings;