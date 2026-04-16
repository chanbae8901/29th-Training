#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Initializes the event variation of the mission template.
 * Loads event settings, wires up timer / alive-check /
 * respawn / time-acceleration handlers, marks editor-placed
 * objects, and prepares respawn inventory.
 *
 * Should be called after round initialization.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_init;
 */

/******* Config ********/
call compile preprocessFileLineNumbers "eventSettings.sqf";
call FUNC(validateSettings);

if (isServer) then {
    GVAR(missionEnded) = false;
    publicVariable QGVAR(missionEnded);

    /******* CBA Settings Overrides ********/
    [QGVARMAIN(addRadio), 0,
        nil, "server", false] call cba_settings_fnc_set;

    // Admin Event Menu
    [
        QEGVAR(common,adminStateChanged), {
            params ["_unit", "_loggedIn"];
            if (isNull _unit) exitWith {};
            [_loggedIn] remoteExecCall [
                QFUNC(updateAdminEventMenu),
                owner _unit
            ];
        }
    ] call CBA_fnc_addEventHandler;

    // Timer
    if (GVAR(useRoundSystem)) then {
        [QGVARMAIN(safeStartTime), GVAR(readySafeStart),
            nil, "server", false] call cba_settings_fnc_set;
        [QGVARMAIN(notifyFinalCheck), false,
            nil, "server", false] call cba_settings_fnc_set;
        [QGVARMAIN(disableScoreboard), GVAR(disableScoreboard),
            nil, "server", false] call cba_settings_fnc_set;         
        [GVAR(timerLength)] call EFUNC(round,setTimer);
    };

    // Win Conditions
    if (GVAR(checkWinConditions)) then {
        if (GVAR(useRoundSystem)) then {
            [
                QEGVAR(round,started), {
                    call FUNC(initWinConditions);
                }
            ] call CBA_fnc_addEventHandler;
        } else {
            call FUNC(initWinConditions);
        };
    };

    // Alive Check
    if (GVAR(useRoundSystem) && {GVAR(hasAliveCheck)} && {GVAR(numberOfLives) > 0}) then {
        call FUNC(initAliveCheck);
    };

    // Time Acceleration
    if (GVAR(useRoundSystem)) then {
        [
            QEGVAR(round,started), {
                setTimeMultiplier GVAR(timeAcc);
            }
        ] call CBA_fnc_addEventHandler;
    } else {
        setTimeMultiplier GVAR(timeAcc);
    };

    // Stop Time Until Live
    if (GVAR(stopTimeUntilLive) && GVAR(useRoundSystem)) then {
        setTimeMultiplier 0.1;
        GVAR(startDate) = date;
        [
            QEGVAR(round,started), {
                setDate GVAR(startDate);
            }
        ] call CBA_fnc_addEventHandler;
    };
};

if (hasInterface) then {
    // Admin Event Menu
    [QGVAR(eventMenuKilled), "Killed", 
        {
            [false] call FUNC(updateAdminEventMenu);
        }
    ] call CBA_fnc_addBISPlayerEventHandler;

    [QGVAR(eventMenuRespawn), "Respawn", 
        {
            if (IS_ADMIN) then {
                [true] call FUNC(updateAdminEventMenu);
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;

    // Player init (respawn inventory + flag actions)
    [{!isNull player}, {
        [player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
        [player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

        if (GVAR(useRoundSystem)) then {
            call FUNC(flagActions);
        };
    }] call CBA_fnc_waitUntilAndExecute;

    // Auto Mark Editor Objects
    if (GVAR(autoMarkObjects)) then {
        call FUNC(markEditorPlacedObjects);
    };

    // Hide map markers belonging to opposing sides
    private _sideStrings = [east, west, civilian, independent]
        apply { toLowerANSI str _x };
    private _playerSideStr = toLowerANSI str playerSide;
    {
        _x setMarkerAlphaLocal 0;
    } count (allMapMarkers select {
        private _marker = _x;
        _sideStrings findIf { _x in _marker } > -1
        && {
            !(_playerSideStr in _marker)
        }
    });

    // Disable Statistics
    if (GVAR(disableStatistics)) then {
        [{PRELOAD_FINISHED}, {
            player removeDiarySubject "Statistics";
        }] call CBA_fnc_waitUntilAndExecute;
    };
};

if (GVAR(useRoundSystem) && {GVAR(numberOfLives) > 0}) then {
    call FUNC(initTrackLives);
};

nil
