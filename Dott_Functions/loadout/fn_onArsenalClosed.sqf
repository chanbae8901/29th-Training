/*
 * Name:	DOTT_loadout_fnc_onArsenalClosed
 * Date:	02/04/2026
 * Version: 1.3
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
 * call DOTT_loadout_fnc_onArsenalClosed;
 */

[player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
[player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

resetLoadout = [player] call CBA_fnc_getLoadout;

[] spawn 
{
	[player] spawn DOTT_loadout_fnc_resetWeaponState;
};

player spawn DOTT_loadout_fnc_setInsignia;

if (!(weaponLowered player)) then 
{
	player action ["WeaponOnBack", player];
};

systemChat "Your gear has been saved.";

true