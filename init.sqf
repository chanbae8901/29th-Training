#include "data\defines.hpp"
diag_log text format ["|=============================   %1: init.sqf Running   =============================|", missionName];
/*
Order of init calls doesn't matter EXCEPT FOR:

event requires round to be initialized first
loadout should be after radio, otherwise radio saving won't work properly

*/

call DOTT_round_fnc_init;

#ifdef DOTT_TRAINING

call DOTT_training_fnc_init;

#endif

#ifdef DOTT_EVENT

call DOTT_event_fnc_init;

#endif

//Run Curator (Zeus) Setup
call DOTT_curator_fnc_init;

call DOTT_ticket_fnc_init;

call DOTT_thermals_fnc_init;

call DOTT_radio_fnc_init;

call DOTT_loadout_fnc_init;

call DOTT_spectator_fnc_init;

call DOTT_vehicle_fnc_init;

call DOTT_ocap_fnc_init;