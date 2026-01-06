#define RADIO_SETTINGS_CATEGORY "29th - Radio Settings"

[
    "TN_addRadio", 
    "LIST", 
    ["Add SR Radio", "Add Side Correct SR Radio to loadout when leaving arsenal"], 
    RADIO_SETTINGS_CATEGORY,
    [[0, 1, 2],["No", "Only When No SR Radio Equipped", "Force Side Radio"], 2],
	1
] call CBA_fnc_addSetting;

[
    "TN_removeRadiosOnDeath", 
    "CHECKBOX", 
    "Remove radios on death",
    RADIO_SETTINGS_CATEGORY,
    true,
	1
] call CBA_fnc_addSetting;

[
    "TN_forceSideLRVic", 
    "CHECKBOX", 
    ["Force Side LR Vehicle", "Force LR radio in vehicle to be the same side as the player."],
    RADIO_SETTINGS_CATEGORY,
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