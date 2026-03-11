// Define ONLY ONE of the variations below
#define DOTT_TRAINING
//#define DOTT_EVENT

/*
Order of modules doesn't matter EXCEPT FOR:

Round should be first, a lot of other modules assume its initialized
loadout should be after radio, otherwise radio saving won't work properly
base should be after event to properly initialize arsenal radius
*/

#ifdef DOTT_TRAINING
#define DOTT_MODULES ["round", "training",          "parade", "tracker", "settings", "curator", "ticket", "thermals", "radio", "loadout", "spectator", "vehicle", "base", "ocap", "commands"]
#endif

#ifdef DOTT_EVENT
#define DOTT_MODULES ["round",             "event",                                  "curator", "ticket", "thermals", "radio", "loadout", "spectator", "vehicle", "base", "ocap"]
#endif
