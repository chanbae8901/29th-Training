#define DEFAULT_TIMER 20 * 60
#define DEFAULT_OVERTIME 5 * 60
#define SCORE_REDUCE_VALUE 9999

#define UNREADY_ALL_SIDES \
    DOTT_round_sideReady = [false, false, false]; \
    publicVariable "DOTT_round_sideReady";

#define RESET_SAFESTART_VARS \
    DOTT_round_safeStartActive = nil; \
    publicVariable "DOTT_round_safeStartActive"; \
    DOTT_round_ignoreReadiness = false; \
    publicVariable "DOTT_round_ignoreReadiness";
