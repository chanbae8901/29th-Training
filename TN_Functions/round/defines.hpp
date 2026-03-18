#include "..\..\data\roundState.hpp"

#define DEFAULT_TIMER 20 * 60
#define DEFAULT_OVERTIME 5 * 60
#define SCORE_REDUCE_VALUE 9999

#define UNREADY_ALL_SIDES \
    TN_round_sideReady = [false, false, false]; \
    publicVariable "TN_round_sideReady";

#define RESET_SAFESTART_VARS \
    TN_round_state = 0; \
    publicVariable "TN_round_state"; \
    TN_round_ignoreReadiness = false; \
    publicVariable "TN_round_ignoreReadiness"; \
    TN_round_forcedTimeRemaining = nil; \
    TN_round_shortenedAt = nil;
