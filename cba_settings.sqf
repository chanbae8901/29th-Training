#include "data\templates.hpp"

#ifdef TN_TRAINING
    #define OCAP_SAVETAG "Training"
#endif

#ifdef TN_EVENT
    #define OCAP_SAVETAG "Event"
#endif

force OCAP_settings_autoStart = false;
force OCAP_settings_minPlayerCount = 2;
force OCAP_settings_trackTickets = false;
force OCAP_settings_saveMissionEnded = true;
force OCAP_settings_minMissionTime = 1; //minutes
force OCAP_settings_saveTag = OCAP_SAVETAG;
