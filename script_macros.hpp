#define PREFIX TN
#include "\x\cba\addons\main\script_macros_mission.hpp"
#include "data\templates.hpp"
#define USING_MODULE(module) (QUOTE(module) in TN_MODULES)
#define SERVER_LOG(_x) _x remoteExecCall [QEFUNC(common,diag_log), 2]
