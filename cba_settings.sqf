#include "data\defines.hpp";

force OCAP_settings_autoStart = false;
force OCAP_settings_minPlayerCount = 2;
force OCAP_settings_trackTickets = false;
force OCAP_settings_saveMissionEnded = true;
force OCAP_settings_minMissionTime = 1; //minutes

#ifdef DOTT_TRAINING
force OCAP_settings_saveTag = "Training";
#endif

#ifdef DOTT_EVENT
force OCAP_settings_saveTag = "Event";
#endif