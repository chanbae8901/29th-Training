#include "data\defines.hpp"

{
    private _preInitModuleFile =
        format ["DOTT_Functions\%1\XEH_preInit.sqf", _x];

    if !(fileExists _preInitModuleFile) then { continue };

    call compile preprocessFileLineNumbers _preInitModuleFile;
} forEach DOTT_MODULES;
