#define GENERAL_SETTINGS_CATEGORY "29th - General Settings"

#define SPECTATOR_SUBCATEGORY "Spectator"

[
    "TN_autoSpectate", 
    "CHECKBOX", 
    "Automatic Spectate on Respawn",
    [GENERAL_SETTINGS_CATEGORY, SPECTATOR_SUBCATEGORY],
    false,
	1
] call CBA_fnc_addSetting;

[
    "TN_limitSpectator", 
    "LIST", 
    "Limit Spectator Features",
    [GENERAL_SETTINGS_CATEGORY, SPECTATOR_SUBCATEGORY],
    [[0,1,2],["None", "1PP Team Only", "Spectator Disabled"], 0],
	1,
    {
        if (hasInterface) then
        {
            if (isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}) exitWith {};
            systemChat "Spectator settings changed. Kicking out player to apply changes.";
            call DOTT_spectator_fnc_exit;
        };
    }
] call CBA_fnc_addSetting;