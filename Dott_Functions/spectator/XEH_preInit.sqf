#include "..\..\data\settingCategories.hpp"

// --- Auto-spectate on respawn ---
[
    "TN_autoSpectate",
    "CHECKBOX",
    "Automatic Spectate on Respawn",
    [GENERAL_SETTINGS_CATEGORY, SPECTATOR_SUBCATEGORY],
    false,
    1
] call CBA_fnc_addSetting;

// --- Spectator feature restrictions ---
[
    "TN_limitSpectator",
    "LIST",
    "Limit Spectator Features",
    [GENERAL_SETTINGS_CATEGORY, SPECTATOR_SUBCATEGORY],
    [
        [0, 1, 2],
        ["None", "1PP Team Only", "Spectator Disabled"],
        0
    ],
    1,
    {
        if (!hasInterface) exitWith {};

        if (isNil {
            missionNamespace getVariable
                "BIS_EGSpectator_initialized"
        }) exitWith {};

        // Kick player out of spectator to apply new limits.
        systemChat
            "Spectator settings changed."
            + " Kicking out player to apply changes.";
        call TN_spectator_fnc_exit;
    }
] call CBA_fnc_addSetting;
