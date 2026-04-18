#include "defines.hpp"
#include "..\..\data\settingCategories.hpp"

[
    QGVARMAIN(disableScoreboard),
    "CHECKBOX",
    [
        "Disable Scoreboard",
        "Disable the scoreboard during the round, except while in Zeus or non-limited spectator."
    ],
    [GENERAL_SETTINGS_CATEGORY, ROUND_SUBCATEGORY],
    true,
    1, 
    {
        if (!PRELOAD_FINISHED) exitWith {};

        if (isServer && ROUND_LIVE) then
        {
            if (_this) then {
                {
                    _x addScoreSide -SCORE_REDUCE_VALUE;
                } forEach [west, east, independent];
            } else {
                {
                    _x addScoreSide SCORE_REDUCE_VALUE;
                } forEach [west, east, independent];
            };
        };

        if (hasInterface) then {
            if (!_this) exitWith {
                    if (!isNil QGVAR(disableRespawnScoreboard)) then {
                        removeMissionEventHandler [
                            "Draw2D",
                            GVAR(disableRespawnScoreboard)
                        ];
                        GVAR(disableRespawnScoreboard) = nil;
                    };
                showScoretable -1;
            };

            if (NOT_ROUND_LIVE) exitWith {};

            if !(isNull (
                uiNamespace getVariable [
                    "RscDisplayCurator",
                    displayNull
                ]
            )) exitWith {};

            if (
                EGVAR(spectator,active)
                && GVARMAIN(limitSpectator) isEqualTo 0
            ) exitWith {};

            showScoretable 0;

            if (alive player) exitWith {};

            GVAR(disableRespawnScoreboard) = addMissionEventHandler [
                "Draw2D", {
                    if (
                        visibleScoretable
                        && ROUND_LIVE
                        && GVARMAIN(disableScoreboard)
                    ) then {
                        showScoretable 0;
                    };
                }
            ];
        };
    }
] call CBA_fnc_addSetting;

[
    QGVARMAIN(safeStartTime),
    "TIME",
    "Safe Start Time",
    [GENERAL_SETTINGS_CATEGORY, ROUND_SUBCATEGORY],
    [0, 3600, 10],
    1
] call CBA_fnc_addSetting;

[
    QGVARMAIN(notifyFinalCheck),
    "CHECKBOX",
    [
        "Final Check Notification",
        "DEBUG: Notify players if final checks detected any issues before starting the round."
    ],
    [GENERAL_SETTINGS_CATEGORY, ROUND_SUBCATEGORY],
    true,
    1
] call CBA_fnc_addSetting;
