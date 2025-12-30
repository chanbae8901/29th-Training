/*
 * Name:	DOTT_parade_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes parade loadout and first spawn.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_parade_fnc_init;
 * 
 */

if (hasInterface) then
{
	[player] spawn DOTT_parade_fnc_handleInitialInventory;
};

if (isServer) then
{
	[WEST, "29TH_PARADE_WEST"] call BIS_fnc_addRespawnInventory;
	[EAST, "29TH_PARADE_EAST"] call BIS_fnc_addRespawnInventory;
	[INDEPENDENT, "29TH_PARADE_INDEPENDENT"] call BIS_fnc_addRespawnInventory;
};