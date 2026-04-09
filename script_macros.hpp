#define PREFIX TN
#include "\x\cba\addons\main\script_macros_mission.hpp"
#include "data\templates.hpp"
#include "data\roundState.hpp"
#define USING_MODULE(module) (QUOTE(module) in TN_MODULES)
#define SERVER_LOG(_x) _x remoteExecCall [QEFUNC(common,diag_log), 2]
#define PRELOAD_FINISHED (!isNil "bis_fnc_preload_init")
#define FORCE_UNSCHEDULED(func) \
    if (canSuspend) exitWith { \
        diag_log text format ["WARNING: %1 called in scheduled environment, re-routing", QFUNC(func)]; \
        [FUNC(func), _this] call CBA_fnc_directCall; \
    }
