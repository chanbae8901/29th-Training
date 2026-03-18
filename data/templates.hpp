// Define ONLY ONE of the variations below
#define TN_TRAINING
//#define TN_EVENT

/*
Order of modules doesn't matter EXCEPT FOR:

Round should be first, a lot of other modules assume its initialized
loadout should be after radio, otherwise radio saving won't work properly
base should be after event to properly initialize arsenal radius
*/

#ifdef TN_TRAINING
#define TN_MODULES ["round", "training",          "parade", "tracker", "settings", "curator", "ticket", "thermals", "radio", "loadout", "spectator", "vehicle", "base", "ocap", "commands"]
#endif

#ifdef TN_EVENT
#define TN_MODULES ["round",             "event",                                  "curator", "ticket", "thermals", "radio", "loadout", "spectator", "vehicle", "base", "ocap"]
#endif
