/*
 * Name:	Hill_fnc_arsenalClosed
 * Date:	8/13/2025
 * Version: 1.1
 * Author:  Hill [29th ID]
 *
 * Description:
 * Various things to do when arsenal closed.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call Hill_fnc_arsenalClosed;
 */

if (!hasInterface) exitWith {};
[player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
[player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

resetLoadout = getUnitLoadout player;

[] spawn 
{
	sleep 1; //previously 3
	[player] spawn DOTT_fnc_resetWeaponState;
};

player spawn Hill_fnc_setInsignia;

if (!(weaponLowered player)) then 
{
	player action ["WeaponOnBack", player];
};

systemChat "Your gear has been saved.";
hintSilent "Your gear has been saved.";
true