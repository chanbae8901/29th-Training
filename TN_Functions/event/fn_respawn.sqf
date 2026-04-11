#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Handles player respawn during a live round with limited lives.
 * Decrements local lives counter and, when exhausted, transitions
 * the player into spectator mode.
 *
 * Called via CBA BIS "Respawn" player event handler.
 *
 * Arguments:
 * 0: New unit <OBJECT>
 * 1: Old unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [] call TN_event_fnc_respawn;
 */

if (!hasInterface) exitWith {};
if (GVAR(numberOfLives) isEqualTo 0) exitWith {};
if (!GVAR(trackingLives)) exitWith {};

GVAR(livesLeft) = GVAR(livesLeft) - 1;

if (GVAR(livesLeft) > 0) exitWith {};

// --- Out of lives ---
player allowDamage false;

titleText [
    "<t color='#ffffff' size='4'>Out of Lives!</t>",
    "BLACK OUT", 0.5, true, true
];

[{
    player setPos [0,0,0];
    [player] call EFUNC(spectator,enter);

    titleText [
        "<t color='#ffffff' size='4'>Out of Lives!</t>",
        "BLACK IN", 0.5, true, true
    ];
}, [], 0.5] call CBA_fnc_waitAndExecute;

nil
