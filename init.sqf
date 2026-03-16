diag_log text format [
    "|=============================   %1: init.sqf Running   =============================|",
    missionName
];

#include "data\defines.hpp"

{
    private _moduleInitName = format ["TN_%1_fnc_init", _x];
    private _function =
        missionNamespace getVariable [_moduleInitName, {}];

    private _elapsed = 0;
    isNil { //run unscheduled to get more accurate run time
        private _startTime = diag_tickTime;
        call _function;
        _elapsed = diag_tickTime - _startTime;
    };
    
    diag_log text format ["(%1/%2) %3: init complete (%4ms)", _forEachIndex + 1, count TN_MODULES, _moduleInitName, _elapsed * 1000];
} forEach TN_MODULES;

diag_log text format [
    "|=============================   %1: init.sqf Finished   =============================|",
    missionName
];
