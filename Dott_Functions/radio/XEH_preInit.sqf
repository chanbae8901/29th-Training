#include "..\..\data\settingCategories.hpp"

[
    "TN_addRadio", 
    "LIST", 
    ["Add SR Radio", "Add Side Correct SR Radio to loadout when leaving arsenal"], 
    [GENERAL_SETTINGS_CATEGORY, RADIO_SUBCATEGORY],
    [[0, 1, 2],["No", "Only When No SR Radio Equipped", "Force Side Radio"], 2],
	1
] call CBA_fnc_addSetting;

[
    "TN_removeRadiosOnDeath", 
    "CHECKBOX", 
    "Remove radios on death",
    [GENERAL_SETTINGS_CATEGORY, RADIO_SUBCATEGORY],
    true,
	1
] call CBA_fnc_addSetting;

[
    "TN_forceSideLRVic", 
    "CHECKBOX", 
    ["Force Side LR Vehicle", "Force LR radio in vehicle to be the same side as the player."],
    [GENERAL_SETTINGS_CATEGORY, RADIO_SUBCATEGORY],
    true,
	1,
    {
        if (hasInterface) then 
        {
            if (!alive player || isNull (objectParent player)) exitWith {};
            #include "..\radio\fn_fixVehicleRadio.inc.sqf"
        };
    }
] call CBA_fnc_addSetting;