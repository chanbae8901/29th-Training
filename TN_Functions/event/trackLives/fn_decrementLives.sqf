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
 * [] call TN_event_fnc_decrementLives;
 */

if (!hasInterface) exitWith {};
if (GVAR(numberOfLives) isEqualTo 0) exitWith {};
if (!GVAR(trackingLives)) exitWith {};

private _newLives = GVAR(livesLeft) - 1;

[QGVAR(adjustLivesServer), [player, _newLives]] call CBA_fnc_serverEvent;

[QGVAR(adjustLivesClient), [_newLives]] call CBA_fnc_localEvent;

nil
