#include "script_component.hpp"

#define ENV_ON 1 fadeEnvironment 1
#define ENV_OFF 1 fadeEnvironment 0

/*
 * Author: Bae [29th ID]
 * Initializes the training variation of the mission template.
 * Sets up curator whitelisting, arsenal zone centers, base
 * map markers, default loadouts, and weather. Should be
 * called after round initialization.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_training_fnc_init;
 */

/*
 * Editor-placed objects referenced in this module:
 *     base_res_red
 *     base_res_blu
 *     base_res_grn
 *     base_action_arsenal_red
 *     base_action_arsenal_blu
 *     base_action_arsenal_grn
 */

//for curator module, make sure training init is put before curator
//all lower case
if (USING_MODULE(curator)) then {
    EGVAR(curator,units) =
    [
        "#adminlogged",
        "blu_reg_o_1", "blu_reg_o_2",
        "blu_reg_snco_1", "blu_reg_snco_2",
        "blu_chq_co", "blu_chq_xo", "blu_chq_cs", "blu_chq_snco",
        "blu_plt1_pl", "blu_plt1_ps1", "blu_plt1_ps2",
        "blu_plt2_pl", "blu_plt2_ps1", "blu_plt2_ps2",
        "red_plt", "red_plt_1", "red_plt_2",
        "grn_plt", "grn_plt_1", "grn_plt_2"
    ];
};

/* Center Arsenal zone in middle of base instead of at arsenal box for base module */
if (USING_MODULE(base)) then {
    private _findCenterObjs =
    [
        [base_res_red, base_action_arsenal_red],
        [base_res_blu, base_action_arsenal_blu],
        [base_res_grn, base_action_arsenal_grn]
    ];
    EGVAR(base,arsenalCenters) = [];

    {
        private _respawnPos = getPosASL (_x select 0);
        private _arsenalPos = getPosASL (_x select 1);

        private _centerPos =
        [
            (_respawnPos#0 + _arsenalPos#0) / 2,
            (_respawnPos#1 + _arsenalPos#1) / 2,
            (_respawnPos#2 + _arsenalPos#2) / 2
        ];
        EGVAR(base,arsenalCenters) pushBack _centerPos;
    } forEach _findCenterObjs;
};

if (hasInterface) then {
    //------- Disable Environment Noises when in arsenal zone unless in spectator or Zeus -------//
    if (USING_MODULE(base)) then {
        GVAR(keepEnvironmentSounds) = false;

        [
            QGVARMAIN(enteredZeus), {
                GVAR(keepEnvironmentSounds) = true;
                ENV_ON;
            }
        ] call CBA_fnc_addEventHandler;

        [
            QGVARMAIN(exitedZeus), {
                GVAR(keepEnvironmentSounds) = false;
                if (EGVAR(base,inArsenalZone)) then { ENV_OFF };
            }
        ] call CBA_fnc_addEventHandler;

        [
            QEGVAR(spectator,entered), {
                GVAR(keepEnvironmentSounds) = true;
                ENV_ON;
            }
        ] call CBA_fnc_addEventHandler;

        [
            QEGVAR(spectator,exited), {
                GVAR(keepEnvironmentSounds) = false;
                if (EGVAR(base,inArsenalZone)) then { ENV_OFF };
            }
        ] call CBA_fnc_addEventHandler;

        [
            QEGVAR(base,enteredArsenalZone), {
                if !(GVAR(keepEnvironmentSounds)) then {
                    ENV_OFF;
                };
            }
        ] call CBA_fnc_addEventHandler;

        [
            QEGVAR(base,exitedArsenalZone), {
                ENV_ON;
            }
        ] call CBA_fnc_addEventHandler;

        /* Draw base locations on map for curator */
        GVAR(curatorBaseLogic) = objNull;

        [QGVARMAIN(enteredZeus), {
            //check if curator module changes (admin swap), if so we need to do this to new module
            if (GVAR(curatorBaseLogic) isEqualTo getAssignedCuratorLogic player) exitWith {};

            GVAR(curatorBaseLogic) = getAssignedCuratorLogic player;

            private _locationColors =
            [
                [1, 0, 0, 0.5],
                [0.5, 0.7, 1.0, 0.5],
                [0, 1, 0, 0.5]
            ];

            {
                [
                    GVAR(curatorBaseLogic),
                    [
                        "\A3\ui_f\data\map\markers\nato\b_unknown.paa",
                        _locationColors select _forEachIndex,
                        ASLtoAGL _x,
                        1,
                        1,
                        0,
                        "",
                        2,
                        0.05
                    ],
                    true,
                    true
                ] call bis_fnc_addcuratoricon;
            } forEach EGVAR(base,arsenalCenters);
        }
        ] call CBA_fnc_addEventHandler;
        /* ---------------------------------- */
    };

    call FUNC(initDefaultLoadouts);

    [{PRELOAD_FINISHED}, {
        player removeDiarySubject "Statistics";
    }] call CBA_fnc_waitUntilAndExecute;
};

if (isServer) then {
    if (USING_MODULE(base)) then {
        call FUNC(initNotifyAdminAllDead);
    };

    INDEPENDENT setFriend [WEST, 0];

    private _forcedDate = [2018, 3, 30, 12, 0];
    private _forcedOvercast = 0.1;
    private _forcedFog = [0.1, 0.01, 0];
    [_forcedDate, _forcedOvercast, _forcedFog] call FUNC(initDateAndWeather);

    if (USING_MODULE(commands)) then {
        [
            QEGVAR(common,adminStateChanged), {
                params ["_unit", "_loggedIn"];
                if !(_loggedIn && !isNull _unit) exitWith {};
                remoteExecCall [QFUNC(initCommandsDiary), _unit];
            }
        ] call CBA_fnc_addEventHandler;
    };
};

nil
