/*
 * Author: Hill [29th ID]
 * Blacks out the screen with a warning message whenever the player
 * activates thermal vision (infantry or vehicle optics) while
 * thermals are disabled. Holds the black screen until the player
 * switches back to a non-thermal vision mode.
 *
 * Must be spawned, not called, because of the waitUntil loop.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * False if no interface, true otherwise <BOOL>
 *
 * Example:
 * [] spawn TN_thermals_fnc_blackScreen
 */

#define MESSAGE "FLIR Mode is disallowed. Please Turn off Thermals."
// Non-zero avoids engine default fade-in, which is slower.
#define FADE_IN_TIME 0.001
#define VISIONMODE_THERMAL 2

if (!hasInterface) exitWith { false };

private _layer = "Hill_blockThermals";

if (currentVisionMode player == VISIONMODE_THERMAL && TN_disableTI) then
{
    _layer cutText [MESSAGE, "BLACK", FADE_IN_TIME];
    playSound "FD_CP_Not_Clear_F";
    waitUntil { sleep 0.1; currentVisionMode player != VISIONMODE_THERMAL };
    _layer cutText ["", "PLAIN"];
};

true
