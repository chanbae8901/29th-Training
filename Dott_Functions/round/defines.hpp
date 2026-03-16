#define DEFAULT_TIMER 20 * 60
#define DEFAULT_OVERTIME 5 * 60
#define SCORE_REDUCE_VALUE 9999

#define UNREADY_ALL_SIDES \
    TN_round_sideReady = [false, false, false]; \
    publicVariable "TN_round_sideReady";

#define RESET_SAFESTART_VARS \
    TN_round_safeStartActive = false; \
    publicVariable "TN_round_safeStartActive"; \
    TN_round_ignoreReadiness = false; \
    publicVariable "TN_round_ignoreReadiness"; \
    TN_round_forcedTimeRemaining = nil; \
    TN_round_shortenedAt = nil;
