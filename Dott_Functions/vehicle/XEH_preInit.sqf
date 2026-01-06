#define GENERAL_SETTINGS_CATEGORY "29th - General Settings"

#define VEHICLE_SUBCATEGORY "Vehicle"

[
    "TN_removeDefaultVehicleInventories", 
    "CHECKBOX", 
    "Remove default inventories from vehicles",
    [GENERAL_SETTINGS_CATEGORY, VEHICLE_SUBCATEGORY],
    true,
	1
] call CBA_fnc_addSetting;

[
    "TN_disableRHSEngineWarmup", 
    "CHECKBOX", 
    ["Disable RHS engine warmup", "Disable RHS startup delay on some vehicles. Useful for preventing teleport bug."],
    [GENERAL_SETTINGS_CATEGORY, VEHICLE_SUBCATEGORY],
    true,
	1,
    {
        RHS_ENGINE_STARTUP_OFF = switch (_this) do
        {
            case true: { true };
            case false: { nil };
        };
    }
] call CBA_fnc_addSetting;

[
    "TN_autoAddFRIES", 
    "CHECKBOX", 
    ["Auto add FRIES", "Automatically equip FRIES to helicopters when they are created."],
    [GENERAL_SETTINGS_CATEGORY, VEHICLE_SUBCATEGORY],
    true,
	1
] call CBA_fnc_addSetting;

#define RESTRICTIONS_SUBCATEGORY "Restrictions"
[
    "TN_artilleryComputer", 
    "CHECKBOX", 
    "Enable Artillery Computer",
    [GENERAL_SETTINGS_CATEGORY, RESTRICTIONS_SUBCATEGORY],
    false,
	1,
    {
        if (isServer) then 
        {
            ["ace_artillerytables_disableArtilleryComputer", !(_this), nil, "server", false] call cba_settings_fnc_set;
            ["ace_mk6mortar_allowComputerRangefinder", _this, nil, "server", false] call cba_settings_fnc_set;            
        };  

        if (hasInterface) then
        {
            enableEngineArtillery _this;
        };   
    }
] call CBA_fnc_addSetting;