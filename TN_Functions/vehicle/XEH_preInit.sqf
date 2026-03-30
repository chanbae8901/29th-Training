#include "script_component.hpp"
#include "..\..\data\settingCategories.hpp"

// --- Remove default vehicle inventories ---
[
    QGVARMAIN(removeDefaultVehicleInventories),
    "CHECKBOX",
    "Remove default inventories from vehicles",
    [GENERAL_SETTINGS_CATEGORY, VEHICLE_SUBCATEGORY],
    true,
    1
] call CBA_fnc_addSetting;

// --- RHS engine warmup bypass ---
[
    QGVARMAIN(disableRHSEngineWarmup),
    "CHECKBOX",
    [
        "Disable RHS engine warmup",
        "Disable RHS startup delay on some vehicles. Useful for preventing teleport bug."
    ],
    [GENERAL_SETTINGS_CATEGORY, VEHICLE_SUBCATEGORY],
    true,
    1, {
        RHS_ENGINE_STARTUP_OFF = [nil, true] select _this;
    }
] call CBA_fnc_addSetting;

// --- Auto-equip FRIES on helicopters ---
[
    QGVARMAIN(autoAddFRIES),
    "CHECKBOX",
    [
        "Auto add FRIES",
        "Automatically equip FRIES to helicopters when they are created."
    ],
    [GENERAL_SETTINGS_CATEGORY, VEHICLE_SUBCATEGORY],
    true,
    1
] call CBA_fnc_addSetting;

// --- Artillery computer toggle ---
[
    QGVARMAIN(artilleryComputer),
    "CHECKBOX",
    "Enable Artillery Computer",
    [GENERAL_SETTINGS_CATEGORY, VEHICLE_SUBCATEGORY],
    false,
    1, {
        if (isServer) then {
            [
                "ace_artillerytables_disableArtilleryComputer",
                !(_this), nil, "server", false
            ] call cba_settings_fnc_set;

            [
                "ace_mk6mortar_allowComputerRangefinder",
                _this, nil, "server", false
            ] call cba_settings_fnc_set;
        };

        if (hasInterface) then {
            enableEngineArtillery _this;
        };
    }
] call CBA_fnc_addSetting;
