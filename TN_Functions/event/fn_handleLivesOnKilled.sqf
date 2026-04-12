#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Handles player killed event during a live round with limited lives.
 * Decrements local lives counter and, when exhausted, transitions
 * the player into spectator mode.
 *
 * Called via CBA BIS "Killed" player event handler.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [] call TN_event_fnc_handleLivesOnKilled;
 */

if (!hasInterface) exitWith {};
if (GVAR(numberOfLives) isEqualTo 0) exitWith {};
if (!GVAR(trackingLives)) exitWith {};

GVAR(livesLeft) = GVAR(livesLeft) - 1;

if (GVAR(livesLeft) > 0) exitWith {};

// --- Out of lives ---
//Make sure player doesn't respawn before we are ready
setPlayerRespawnTime 9999;
//Don't show the respawn menu when we transition to spectator
player setVariable ["BIS_fnc_showRespawnMenu_disable", true];
//disable Respawn in Pause Menu if player is in it when dying for some reason
((findDisplay 49) displayCtrl 1010) ctrlEnable false; 

[ 
    { 
        titleText [
            "<t color='#ffffff' size='4'>Out of Lives!</t>",
            "BLACK OUT", 0.5, true, true
        ];
    },
    {},
    1 //wait so transition is less jarring for the player
] call CBA_fnc_waitAndExecute;

[ 
    { 
        titleText [
            "<t color='#ffffff' size='4'>Out of Lives!</t>",
            "BLACK IN", 0.5, true, true
        ];
    },
    {},
    4 //At least delayed enough to hide respawn screen before getting into spectator
] call CBA_fnc_waitAndExecute;

[
    {
        setPlayerRespawnTime 0;
        [
            {alive player},
            {
                [player, true] call EFUNC(spectator,enter);
                //reenable respawn menu just in case
                player setVariable ["BIS_fnc_showRespawnMenu_disable", false];
                // Delay setPos to let spectator camera initialize
                [{
                    (_this select 0) setPos [0,0,0];
                    (_this select 0) enableSimulation false;
                }, [player], 0.5] call CBA_fnc_waitAndExecute;
            }
        ] call CBA_fnc_waitUntilAndExecute;
    },
    {},
    4
] call CBA_fnc_waitAndExecute;

nil
