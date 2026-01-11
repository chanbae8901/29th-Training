/*
 * Name:	DOTT_spectator_fnc_exit
 * Date:	9/6/2016
 * Version: 1.0
 * Author: Rellikplug AKA: Hill [29th ID]
 *
 * Description: Removes the player from spectator mode and undos the changes made by DOTT_spectator_fnc_enter.sqf.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * false if player not in spectator, true otherwise
 *
 * Example:
 * [] spawn DOTT_spectator_fnc_exit
 */

// Check if spectator mode is initialized
if (isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}) exitWith { false }; 

["Terminate"] call BIS_fnc_EGSpectator; //  End Spectator
[player, false] remoteExecCall ["hideObjectGlobal", 2];
cutText ["","PLAIN DOWN"]; // Clear cutText
hintSilent ""; // Clear Hint
[] spawn 
{
	sleep 2; //wait so player does not take collision damage from other players leaving box
	if (!isNil "DOTT_loadout_teleporting") exitWith {}; //don't conflict with command teleport	
	player allowDamage true; // Make player vulnerable again
};

player switchCamera "internal"; // Make sure the camera is returned to the player
player enableSimulation true;
["exitSpectator", "onEachFrame"] call BIS_fnc_removeStackedEventHandler; //  Remove the stackedEventHandler as we no longer need it
if (!(weaponLowered player)) then 
{
	player action ["WeaponOnBack", player];
};

["exitedSpectator", []] call CBA_fnc_localEvent;

true