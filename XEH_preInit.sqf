#include "data\templates.hpp"

{
    private _preInitModuleFile =
        format ["TN_Functions\%1\XEH_preInit.sqf", _x];

    if !(fileExists _preInitModuleFile) then { continue };

    call compile preprocessFileLineNumbers _preInitModuleFile;
} forEach TN_MODULES;
