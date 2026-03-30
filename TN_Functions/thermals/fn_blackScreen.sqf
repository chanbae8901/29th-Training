#include "script_component.hpp"
/*
 * Author: Hill [29th ID]
 * Blacks out the screen with a warning message whenever the player
 * activates thermal vision (infantry or vehicle optics) while
 * thermals are disabled. Holds the black screen until the player
 * switches back to a non-thermal vision mode.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * False if no interface, true otherwise <BOOL>
 *
 * Example:
 * call TN_thermals_fnc_blackScreen
 */

#define MESSAGE "FLIR Mode is disallowed. Please Turn off Thermals."
// Non-zero avoids engine default fade-in, which is slower.
#define FADE_IN_TIME 0.001
#define VISIONMODE_THERMAL 2
#define BLOCK_LAYER "Hill_blockThermals"

if (!hasInterface) exitWith { false };

if (currentVisionMode player isEqualTo VISIONMODE_THERMAL && GVARMAIN(disableTI)) then {
    BLOCK_LAYER cutText [MESSAGE, "BLACK", FADE_IN_TIME];
    playSound "FD_CP_Not_Clear_F";
    [{currentVisionMode player isNotEqualTo VISIONMODE_THERMAL}, {
        BLOCK_LAYER cutText ["", "PLAIN"];
    }] call CBA_fnc_waitUntilAndExecute;
};

true
