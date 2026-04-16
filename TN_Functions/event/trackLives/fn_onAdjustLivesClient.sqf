#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Handles custom adjustLivesClient event during a live round with limited lives.
 * Manages moving player into/out of spectator properly.
 *
 * Arguments:
 * 0: New number of lives <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [2] call TN_event_fnc_onAdjustLivesClient;
 */

params ["_livesLeft"];

private _oldLivesLeft = GVAR(livesLeft);
if (_oldLivesLeft isEqualTo _livesLeft) exitWith {};
GVAR(livesLeft) = _livesLeft;

if (_oldLivesLeft isEqualTo 0) then {
    [{alive player},
    {
        call EFUNC(spectator,exit);
        player enableSimulation true;                
        player setDamage 1;
    }] call CBA_fnc_waitUntilAndExecute;
};

systemChat format ["You now have %1 lives left.", _livesLeft];

// --- Out of lives ---
if (_livesLeft isEqualTo 0) then {
    if (!alive player) then {
        //Make sure player doesn't respawn before we are ready
        setPlayerRespawnTime 9999;
        //Don't show the respawn menu when we transition to spectator
        player setVariable ["BIS_fnc_showRespawnMenu_disable", true];
    };
    //disable Respawn in Pause Menu if player is in it
    ((findDisplay 49) displayCtrl 1010) ctrlEnable false;

    private _extraDelay = [2, 0] select (alive player);
// ----- Show Notification -----
    [ 
        { 
            titleText [
                "<t color='#ffffff' size='4'>Out of Lives!</t>",
                "BLACK OUT", 0.5, true, true
            ];
        },
        {},
        0 + _extraDelay //wait so transition is less jarring for the player
    ] call CBA_fnc_waitAndExecute;

    [ 
        { 
            titleText [
                "<t color='#ffffff' size='4'>Out of Lives!</t>",
                "BLACK IN", 0.5, true, true
            ];
        },
        {},
        3 + _extraDelay
    ] call CBA_fnc_waitAndExecute;
// ----------------------------

    [
        {
            if (!alive player) then {setPlayerRespawnTime 0};
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
        3 + _extraDelay
    ] call CBA_fnc_waitAndExecute;
};

nil
