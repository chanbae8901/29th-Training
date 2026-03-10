diag_log text format [
    "|=============================   %1: init.sqf Running   =============================|",
    missionName
];

#include "data\defines.hpp"

{
    private _moduleInitName = format ["DOTT_%1_fnc_init", _x];
    private _function =
        missionNamespace getVariable [_moduleInitName, {}];
    call _function;
} forEach DOTT_MODULES;
