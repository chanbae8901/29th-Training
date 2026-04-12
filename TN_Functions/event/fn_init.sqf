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
    publicVariable QGVAR(gameCalled);

    /******* CBA Settings Overrides ********/
    [QGVARMAIN(addRadio), 0,
        nil, "server", false] call cba_settings_fnc_set;

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

    // Lives Tracking
    if (GVAR(numberOfLives) > 0) then {
        GVAR(trackingLives) = false;
        publicVariable QGVAR(trackingLives);
        GVAR(livesByUID) = createHashMap;

        ["CAManBase", "Killed", {
            params ["_unit"];
            if (!GVAR(trackingLives)) exitWith {};
            if (!isPlayer _unit) exitWith {};

            private _uid = getPlayerUID _unit;
            if (_uid isEqualTo "") exitWith {};

            private _lives = GVAR(livesByUID) getOrDefault [
                _uid, GVAR(numberOfLives)
            ];
            private _newLives = _lives - 1;
            GVAR(livesByUID) set [_uid, _newLives];
            if (_newLives isEqualTo 0) then {
                [QGVAR(outOfLives), [_unit]] call CBA_fnc_localEvent;
            };
        }] call CBA_fnc_addClassEventHandler;

        [QGVAR(checkJIPLives), {
            params ["_player"];
            private _uid = getPlayerUID _player;
            private _lives = GVAR(livesByUID) getOrDefault [
                _uid, GVAR(numberOfLives)
            ];
            if (GVAR(useRoundSystem) && {GVAR(penalizeJIPLives)} && {GVAR(trackingLives)}) then {
                _lives = _lives - 1;
                GVAR(livesByUID) set [_uid, _lives];
            };
            [QGVAR(jipLivesResolved), [_player, _lives]]
                call CBA_fnc_localEvent;
            [QGVAR(jipLivesResult), [_lives], _player]
                call CBA_fnc_targetEvent;
        }] call CBA_fnc_addEventHandler;

        if (GVAR(useRoundSystem)) then {
            [QEGVAR(round,started), {
                GVAR(livesByUID) = createHashMap;
                GVAR(trackingLives) = true;
                publicVariable QGVAR(trackingLives);
            }] call CBA_fnc_addEventHandler;
        };
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
    // Player init (respawn inventory + flag actions)
    [{!isNull player}, {
        [player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
        [player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

        if (GVAR(useRoundSystem)) then {
            call FUNC(flagActions);
        };
    }] call CBA_fnc_waitUntilAndExecute;

    // Enable lives tracking system
    if (GVAR(numberOfLives) > 0) then {
        GVAR(livesLeft) = GVAR(numberOfLives); //default to prevent nil

        [QGVAR(killed), "Killed", FUNC(handleLivesOnKilled)]
            call CBA_fnc_addBISPlayerEventHandler;

        [QGVAR(jipLivesResult), {
            params ["_livesLeft"];
            GVAR(livesLeft) = _livesLeft;
            if (_livesLeft isEqualTo 0) then {
                [player, true] call EFUNC(spectator,enter);
            };
        }] call CBA_fnc_addEventHandler;

        [{!isNull player}, {
            [QGVAR(checkJIPLives), [player]]
                call CBA_fnc_serverEvent;
        }] call CBA_fnc_waitUntilAndExecute;

        //disable Respawn button in Pause menu if out of lives
        [   
            QGVARMAIN(enteredPauseMenu),
            { 
                if (GVAR(livesLeft) <= 0) then {
                    [{!isNull ((findDisplay 49) displayCtrl 1010)}, 
                    {((findDisplay 49) displayCtrl 1010) ctrlEnable false}
                    ] call CBA_fnc_waitUntilAndExecute;
                };
            }
        ] call CBA_fnc_addEventHandler;    
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
