#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Initializes the lives tracking system of event template.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_initTrackLives;
 */
if !(GVAR(useRoundSystem) && {GVAR(numberOfLives > 0)}) exitWith {};

if (isServer) then {
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

if (hasInterface) then {
    GVAR(livesLeft) = GVAR(numberOfLives); //default to prevent nil

    [QGVAR(killed), "Killed", FUNC(handleLivesOnKilled)]
        call CBA_fnc_addBISPlayerEventHandler;

    [QGVAR(jipLivesResult), {
        params ["_livesLeft"];
        GVAR(livesLeft) = _livesLeft;
        if (_livesLeft isEqualTo 0) then {
            [player] call ACE_medical_treatment_fnc_fullHealLocal;
            [player, true] call EFUNC(spectator,enter);
            // Delay setPos to let spectator camera initialize
            [{
                (_this select 0) setPos [0,0,0];
                (_this select 0) enableSimulation false;
            }, [player], 0.5] call CBA_fnc_waitAndExecute;
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(adjustLives), {
        params ["_livesLeft"];

        private _oldLivesLeft = GVAR(livesLeft);
        GVAR(livesLeft) = _livesLeft;
        if (_livesLeft isEqualTo 0) then {
            if (!alive player) then {setPlayerRespawnTime 0};
            [{alive player},
                {
                    [player] call ACE_medical_treatment_fnc_fullHealLocal;
                    [player, true] call EFUNC(spectator,enter);
                    // Delay setPos to let spectator camera initialize
                    [{
                        (_this select 0) setPos [0,0,0];
                        (_this select 0) enableSimulation false;
                    }, [player], 0.5] call CBA_fnc_waitAndExecute;
                }
            ] call CBA_fnc_waitUntilAndExecute;
        };
        if (_oldLivesLeft isEqualTo 0) then {
            [{alive player},
            {
                call EFUNC(spectator,exit);
                player enableSimulation true;                
                player setDamage 1;
            }] call CBA_fnc_waitUntilAndExecute;
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