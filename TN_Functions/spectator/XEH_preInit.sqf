#include "script_component.hpp"
#include "..\..\data\settingCategories.hpp"

GVAR(active) = false;

// --- Auto-spectate on respawn ---
[
    QGVARMAIN(autoSpectate),
    "CHECKBOX",
    "Automatic Spectate on Respawn",
    [GENERAL_SETTINGS_CATEGORY, SPECTATOR_SUBCATEGORY],
    false,
    1
] call CBA_fnc_addSetting;

// --- Spectator feature restrictions ---
[
    QGVARMAIN(limitSpectator),
    "LIST",
    "Limit Spectator Features",
    [GENERAL_SETTINGS_CATEGORY, SPECTATOR_SUBCATEGORY],
    [
        [0, 1, 2],
        ["None", "1PP Team Only", "Spectator Disabled"],
        0
    ],
    1, {
        if (!hasInterface) exitWith {};

        if (!isNil "ace_spectator_fnc_updateSides") then {
            if (GVARMAIN(limitSpectator) isEqualTo 1) then {
                [[side player], [west, east, independent, civilian] - [side player]]
                    call ace_spectator_fnc_updateSides;
                [[1], [0, 2]] call ace_spectator_fnc_updateCameraModes;
            } else {
                [[west, east, independent, civilian], []]
                    call ace_spectator_fnc_updateSides;
                [[0, 1, 2], []] call ace_spectator_fnc_updateCameraModes;
            };
        };

        if !(GVAR(active)) exitWith {};

        systemChat
            "Spectator settings changed."
            + " Kicking out player to apply changes.";
        call FUNC(exit);
    }
] call CBA_fnc_addSetting;
