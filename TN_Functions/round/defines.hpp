#include "script_component.hpp"

#define DEFAULT_TIMER 20 * 60
#define SCORE_REDUCE_VALUE 9999

#define UNREADY_ALL_SIDES \
    GVAR(sideReady) = [false, false, false]; \
    publicVariable QGVAR(sideReady);

#define RESET_SAFESTART_VARS \
    GVAR(state) = 0; \
    publicVariable QGVAR(state); \
    GVAR(ignoreReadiness) = false; \
    publicVariable QGVAR(ignoreReadiness); \
    GVAR(forcedTimeRemaining) = nil; \
    GVAR(shortenedAt) = nil;
