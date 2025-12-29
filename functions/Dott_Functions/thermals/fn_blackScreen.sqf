/*
 * Name:	DOTT_thermals_fnc_blackScreen
 * Date:	12/11/2025
 * Version: 1.2
 * Author: Rellikplug AKA: Hill [29th ID]
 *
 * Description:
 * Blacks out screen with a warning message when thermals are used in any infantry
 * or vehicle weapon until they are disabled.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * false if !hasInterface, true otherwise
 *
 * Example:
 * [] spawn DOTT_thermals_fnc_blackScreen
 */

#define MESSAGE "FLIR Mode is disallowed. Please Turn off Thermals."
//not zero as that causes default fade in time, which is slower
#define FADE_IN_TIME 0.001 

if (!hasInterface) exitWith {false};
private _layer = "Hill_blockThermals"; 

if (currentVisionMode player == 2 && TN_disableTI) then 
{
  _layer	cutText [MESSAGE, "BLACK", FADE_IN_TIME];
  playSound "FD_CP_Not_Clear_F";
  waituntil {sleep 0.1; (currentVisionMode player == 2 && TN_disableTI)};
  _layer cutText ["", "PLAIN"];
};

true