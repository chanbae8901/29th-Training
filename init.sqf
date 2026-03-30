#include "script_macros.hpp"

diag_log text format [
    "|=============================   %1: init.sqf Running   =============================|",
    missionName
];

#include "data\templates.hpp"

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

[QGVARMAIN(initFinished), {}] call CBA_fnc_localEvent;

// Clean up all TN_initFinished handlers — one-shot event, never fires again.
private _eventHash = CBA_events_eventHashes getVariable QGVARMAIN(initFinished);
if (!isNil "_eventHash") then {
    private _lastId = [_eventHash, "#lastId"] call CBA_fnc_hashGet;
    for "_i" from _lastId to 0 step -1 do {
        [QGVARMAIN(initFinished), _i] call CBA_fnc_removeEventHandler;
    };
};

diag_log text format [
    "|=============================   %1: init.sqf Finished   =============================|",
    missionName
];
