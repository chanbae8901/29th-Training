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

//weak fix for potential silent weapon bug when player after respawn having selected loadout in previous life,
//enters ace arsenal and picks same loadout
//weak meaning fixing some but not all cases
[] spawn 
{
	waitUntil { sleep 1; (weaponState player) select 6 == 0 }; //wait until unit is not reloading
	private _primaryMags = primaryWeaponMagazine player;

	{
		player removePrimaryWeaponItem _x;
	}
	forEach _primaryMags;

	sleep 1;

	{
		player addPrimaryWeaponItem _x;
	} forEach _primaryMags;
};

player spawn DOTT_loadout_fnc_setInsignia;

if (!(weaponLowered player)) then 
{
	player action ["WeaponOnBack", player];
};

systemChat "Your gear has been saved.";

true