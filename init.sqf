#include "data\defines.hpp"
diag_log text format ["|=============================   %1: init.sqf Running   =============================|", missionName];

call DOTT_round_fnc_init;

#ifdef DOTT_TRAINING
if (("enableRoundEventLog" call BIS_fnc_getParamValue) == 1) then {call DOTT_tracker_fnc_init};
#endif

#ifdef DOTT_EVENT

call DOTT_event_fnc_init;

#endif

call DOTT_radio_fnc_initTransferSettings;

//Run Curator (Zeus) Setup
call DOTT_curator_fnc_init;

call DOTT_ticket_fnc_init;