#include "..\..\data\settingCategories.hpp"

[
    "TN_costInfantry", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    ["Infantry Weight", "Capture Weight of Infantry"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    SECTOR_SETTINGS_CATEGORY, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0, 10, 1, 2], // data for this setting: [min, max, default, number of shown trailing decimals]
    1
] call CBA_fnc_addSetting;

[
    "TN_costWheeled",
    "SLIDER",
    ["Wheeled Weight", "Capture Weight of Wheeled Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
    1
] call CBA_fnc_addSetting;

[
    "TN_costTracked",
    "SLIDER",
    ["Tracked Weight", "Capture Weight of Tracked Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 2, 2],
    1
] call CBA_fnc_addSetting;

[
    "TN_costStatic",
    "SLIDER",
    ["Static Weight", "Capture Weight of Static Weapons"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
    1
] call CBA_fnc_addSetting;

[
    "TN_costWater",
    "SLIDER",
    ["Water Weight", "Capture Weight of Naval Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
    1
] call CBA_fnc_addSetting;

[
    "TN_costAir",
    "SLIDER",
    ["Air Weight", "Capture Weight of Air Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 0, 2],
    1
] call CBA_fnc_addSetting;

[
    "TN_captureCoef",
    "SLIDER",
    "Capture Speed",
    SECTOR_SETTINGS_CATEGORY,
    [0, 1, 0.05, 3],
    1
] call CBA_fnc_addSetting;

[
    "TN_checkCrew",
    "LIST",
    ["Count Vehicle Crew Weight",
        "Units inside vehicle types contribute weight towards capture"],
    SECTOR_SETTINGS_CATEGORY,
    [
        [[false, false], [true, false], [true, true]],
        ["No", "Land/Naval Only", "Yes"],
        0
    ],
    1
] call CBA_fnc_addSetting;

[
    "TN_useThreat",
    "CHECKBOX",
    ["Use Vehicle Threat Value",
        "Vehicle capture weight is further modified by config threat values."],
    SECTOR_SETTINGS_CATEGORY,
    false,
    1
] call CBA_fnc_addSetting;
