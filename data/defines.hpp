#define DOTT_TRAINING
//#define DOTT_EVENT

/*
Order of doesn't matter EXCEPT FOR:

event requires round to be initialized first
loadout should be after radio, otherwise radio saving won't work properly

*/

#ifdef DOTT_TRAINING
#define DOTT_MODULES ["round", "training", "commands", "parade", "curator", "ticket", "thermals", "radio", "loadout", "spectator", "vehicle", "ocap"]
#endif

#ifdef DOTT_EVENT
#define DOTT_MODULES ["round", "event", "curator", "ticket", "thermals", "radio", "loadout", "spectator", "vehicle", "ocap"]
#endif