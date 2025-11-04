[
    "DOTT_costInfantry", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    ["Infantry Weight", "Capture Weight of Infantry"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "29th - Sector Settings", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0, 10, 1, 2], // data for this setting: [min, max, default, number of shown trailing decimals]
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costWheeled", 
    "SLIDER", 
    ["Wheeled Weight", "Capture Weight of Wheeled Vehicles"], 
    "29th - Sector Settings",
    [0, 10, 1, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costTracked", 
    "SLIDER", 
    ["Tracked Weight", "Capture Weight of Tracked Vehicles"],
    "29th - Sector Settings",
    [0, 10, 2, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costStatic", 
    "SLIDER", 
    ["Static Weight", "Capture Weight of Static Weapons"], 
    "29th - Sector Settings",
    [0, 10, 1, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costWater", 
    "SLIDER", 
    ["Water Weight", "Capture Weight of Naval Vehicles"], 
    "29th - Sector Settings",
    [0, 10, 1, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costAir", 
    "SLIDER", 
    ["Air Weight", "Capture Weight of Air Vehicles"], 
    "29th - Sector Settings",
    [0, 10, 0, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_captureCoef", 
    "SLIDER", 
    "Capture Speed", 
    "29th - Sector Settings",
    [0, 1, 0.05, 3],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_checkCrew", 
    "LIST", 
    ["Count Vehicle Crew Weight", "Units inside vehicle types contribute weight towards capture"], 
    "29th - Sector Settings",
    [[[false,false],[true, false], [true, true]],["No", "Land/Naval Only", "Yes"], 0],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_useThreat", 
    "CHECKBOX", 
    ["Use Vehicle Threat Value", "Vehicle capture weight is further modified by config threat values."], 
    "29th - Sector Settings",
    false,
	1
] call CBA_fnc_addSetting;