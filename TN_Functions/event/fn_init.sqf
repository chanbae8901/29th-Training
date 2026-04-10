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

/******* CBA Settings Overrides ********/
[QGVARMAIN(addRadio), 0,
    nil, "server", false] call cba_settings_fnc_set;

if (isServer) then {
    // Admin Event Menu
    [
        QEGVAR(common,adminStateChanged), {
            params ["_unit", "_loggedIn"];
            if (isNull _unit) exitWith {};
            [_loggedIn] remoteExecCall [
                QFUNC(handleAdminEventMenu),
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
        [GVAR(timerLength)] call EFUNC(round,setTimer);
    };

    // Win Conditions
    if (GVAR(checkWinConditions)) then {
        if (GVAR(useRoundSystem)) then {
            [
                QEGVAR(round,started), {
                    call FUNC(checkWinCondition);
                }
            ] call CBA_fnc_addEventHandler;
        } else {
            call FUNC(checkWinCondition);
        };
    };

    // Alive Check
    if (GVAR(useRoundSystem) && {GVAR(hasAliveCheck)}) then {
        [
            QEGVAR(round,started), {
                call FUNC(aliveCheck);
            }
        ] call CBA_fnc_addEventHandler;
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
};

if (hasInterface) then {
    // Player init (respawn inventory + flag actions)
    [{!isNull player}, {
        [player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
        [player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

        if (GVAR(useRoundSystem)) then {
            call FUNC(flagActions);
        };
    }] call CBA_fnc_waitUntilAndExecute;

    // Respawn
    if (GVAR(useRoundSystem) && {GVAR(numberOfLives) > 0}) then {
        [
            QEGVAR(round,started),
            { [true] call FUNC(respawn) }
        ] call CBA_fnc_addEventHandler;

        [
            QGVAR(respawn),
            "Respawn",
            FUNC(respawn)
        ] call CBA_fnc_addBISPlayerEventHandler;
    };

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

nil
