#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Initializes the client part of lives tracking system of event template.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_initTrackLivesClient;
 */

GVAR(livesLeft) = GVAR(numberOfLives); //default to prevent nil

[QGVAR(killed), "Killed", FUNC(decrementLives)]
    call CBA_fnc_addBISPlayerEventHandler;

[QGVAR(adjustLivesClient), 
    FUNC(onAdjustLivesClient)
] call CBA_fnc_addEventHandler;

if (didJIP) then {
    [{!isNull player}, {
        [QGVAR(checkLivesJIP), [player]]
            call CBA_fnc_serverEvent;
    }] call CBA_fnc_waitUntilAndExecute;
};

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

nil
