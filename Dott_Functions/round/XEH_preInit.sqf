#include "..\..\data\settingCategories.hpp"

[
    "TN_disableScoreboard",
    "CHECKBOX",
    [
        "Disable Scoreboard",
        "Disable the scoreboard during the round, except while in Zeus or non-limited spectator."
    ],
    [GENERAL_SETTINGS_CATEGORY, ROUND_SUBCATEGORY],
    true,
    1,
    {
        if (hasInterface) then
        {
            if (!_this) exitWith
            {
                removeMissionEventHandler [
                    "Draw2D",
                    disableRespawnScoreboard
                ];
                showScoretable -1;
            };

            if !(call DOTT_round_fnc_isRoundActive) exitWith {};

            if !(isNull (
                uiNamespace getVariable [
                    "RscDisplayCurator",
                    displayNull
                ]
            )) exitWith {};

            if (
                !isNil {
                    missionNamespace getVariable
                        "BIS_EGSpectator_initialized"
                }
                && TN_limitSpectator == 0
            ) exitWith {};

            showScoretable 0;

            if (alive player) exitWith {};

            disableRespawnScoreboard = addMissionEventHandler [
                "Draw2D",
                {
                    if (
                        visibleScoretable
                        && call DOTT_round_fnc_isRoundActive
                        && TN_disableScoreboard
                    ) then
                    {
                        showScoretable 0;
                    };
                }
            ];
        };
    }
] call CBA_fnc_addSetting;

[
    "TN_safeStartTime",
    "TIME",
    "Safe Start Time",
    [GENERAL_SETTINGS_CATEGORY, ROUND_SUBCATEGORY],
    [0, 3600, 10],
    1
] call CBA_fnc_addSetting;

[
    "TN_notifyFinalCheck",
    "CHECKBOX",
    [
        "Final Check Notification",
        "DEBUG: Notify players if final checks detected any issues before starting the round."
    ],
    [GENERAL_SETTINGS_CATEGORY, ROUND_SUBCATEGORY],
    true,
    1
] call CBA_fnc_addSetting;
