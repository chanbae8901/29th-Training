/*
 * Name:	Hill_fnc_enter_spectator
 * Date:	9/30/2025
 * Version: 1.1
 * Author: Rellikplug AKA: Hill [29th ID] modified by Bae [29th ID]
 *
 * Description: Enters user into spectator mode. 
 * Lets the player leave by pressing reload by calling Hill_fnc_exit_spectator.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true if entered spectator mode, false otherwise
 *
 * Example:
 * [] spawn Hill_fnc_enter_spectator
 */

/* 
// ["Initialize", [player, [<side>,<side>], true, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;
// The custom array for Initialize function can contain:
_this select 0 : The target player object
_this select 1 : Whitelisted sides, empty means all
_this select 2 : Whether AI can be viewed by the spectator
_this select 3 : Whether Free camera mode is available
_this select 4 : Whether 3th Person Perspective camera mode is available
_this select 5 : Whether to show Focus Info stats widget
_this select 6 : Whether or not to show camera buttons widget
_this select 7 : Whether to show controls helper widget
_this select 8 : Whether to show header widget
_this select 9 : Whether to show entities / locations lists
*/

/*
For overriding the spectate button->?
Make something that triggers once (findDisplay 49) exists (the menu)
Then look up the IDC of the spectate button and add from there
- Hill
*/

if (isDedicated || !hasInterface) exitWith {["Player must be not be dedicated server or HC."] call BIS_fnc_error; false};

hintSilent "SPECTATOR\n----------\nPress RELOAD to exit";  // Tell player they are spectating

[] spawn 
{
	while {!isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}} do 
	{ // While spectator is active show messages
		cutText ["SPECTATOR\n----------\nPress RELOAD to exit","PLAIN DOWN"];
		sleep 30; // Show message every 30 seconds			
	};
};

[player, true] remoteExecCall ["hideObjectGlobal", 2];
player enableSimulation false;
player allowDamage false;

["Initialize", [player, [], false]] call BIS_fnc_EGSpectator;  // Start Spectator

private _startPos = getPosATL player;
["exitSpectator", "onEachFrame", 
{
	params ["_startPos"];
	if (inputAction "ReloadMagazine" > 0) exitWith 
	{ // Check if "Reload" key is pressed
		call Hill_fnc_exit_spectator;
	};
	if (((getPosATL player) distanceSqr _startPos ) > (5 * 5)) exitWith 
	{
		call Hill_fnc_exit_spectator;
	};
	//player respawns while in spectator box for some reason
	if (!alive player) exitWith 
	{
        call Hill_fnc_exit_spectator;
    };
}, [_startPos]] call BIS_fnc_addStackedEventHandler;

["enteredSpectator", []] call CBA_fnc_localEvent;

true