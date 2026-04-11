#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Handles player respawn during a live round with limited lives.
 * Decrements local lives counter and, when exhausted, transitions
 * the player into spectator mode.
 *
 * Called via CBA BIS "Killed" player event handler.
 *
 * Arguments:
 * 0: New unit <OBJECT>
 * 1: Old unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [] call TN_event_fnc_killed;
 */

if (!hasInterface) exitWith {};
if (GVAR(numberOfLives) isEqualTo 0) exitWith {};
if (!GVAR(trackingLives)) exitWith {};

GVAR(livesLeft) = GVAR(livesLeft) - 1;

if (GVAR(livesLeft) > 0) exitWith {};

// --- Out of lives ---
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
