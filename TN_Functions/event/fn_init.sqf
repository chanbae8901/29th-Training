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

/******** CONFIG ********/
call compile preprocessFileLineNumbers "eventSettings.sqf";
call FUNC(validateSettings);

/******* CBA Settings Overrides ********/
[QEGVAR(main,addRadio), 0,
    nil, "server", false] call cba_settings_fnc_set;

/******* Admin Event Menu ********/
if (isServer) then {
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
};

/******* Timer ********/
if (GVAR(hasTimer)) then {
    if (isServer) then {
        [QEGVAR(main,safeStartTime), GVAR(readySafeStart),
            nil, "server", false] call cba_settings_fnc_set;
        [QEGVAR(main,notifyFinalCheck), false,
            nil, "server", false] call cba_settings_fnc_set;
        [GVAR(timerLength)] call EFUNC(round,setTimer);
    };
    if (hasInterface) then {
        [{!isNull player}, {
            call FUNC(flagActions);
        }] call CBA_fnc_waitUntilAndExecute;
    };
};

/******* Win Conditions ********/
if (GVAR(checkWinConditions) && isServer) then {
    if (GVAR(hasTimer)) then {
        [
            QEGVAR(round,started), {
                call FUNC(checkWinCondition);
            }
        ] call CBA_fnc_addEventHandler;
    } else {
        call FUNC(checkWinCondition);
    };
};

/******* AliveCheck ********/
if (GVAR(hasAliveCheck)) then {
    if (isServer) then {
        [
            QEGVAR(round,started), {
                call FUNC(aliveCheck);
            }
        ] call CBA_fnc_addEventHandler;
    };
};

if (GVAR(numberOfLives) > 0) then {
    if (hasInterface) then {
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
};

/******* Time Acceleration ********/
if (isServer) then {
    [
        QEGVAR(round,started), {
            setTimeMultiplier GVAR(timeAcc);
        }
    ] call CBA_fnc_addEventHandler;
};

/******* Auto Mark Editor Objects ********/
if (hasInterface) then {
    if (GVAR(autoMarkObjects)) then {
        call FUNC(markEditorPlacedObjects);
    };
};

/******* Everything else ********/
if (hasInterface) then {
    //Prevent error due to no saved respawn inventory
    [{!isNull player}, {
        [player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
        [player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;
    }] call CBA_fnc_waitUntilAndExecute;

    //Hide map markers belonging to opposing sides
    private _sideStrings = [east, west, civilian, independent]
        apply { toLowerANSI str _x };
    private _playerSideStr = toLowerANSI str playerSide;
    {
        _x setMarkerAlphaLocal 0;
    } count (allMapMarkers select {
        private _marker = _x;
        _sideStrings findIf { _x in _marker } > -1
        && {
            !(_playerSideStr in _x)
        }
    });

    if (GVAR(disableStatistics)) then {
        [{PRELOAD_FINISHED}, {
            player removeDiarySubject "Statistics";
        }] call CBA_fnc_waitUntilAndExecute;
    };
};

nil
