/*
 * Name:	DOTT_parade_fnc_init
 * Date:	03/09/2026
 * Version: 1.1
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

if(!isClass (configFile >> "CfgPatches" >> "29thID_Uniforms")) exitWith {};

if (hasInterface) then
{
	[] spawn 
	{
		waitUntil { !isNull player };
		isNil { call DOTT_parade_fnc_handleInitialInventory }; //call unscheduled
	};
};

if (isServer) then
{
	[WEST, "29TH_PARADE_WEST"] call BIS_fnc_addRespawnInventory;
	[EAST, "29TH_PARADE_EAST"] call BIS_fnc_addRespawnInventory;
	[INDEPENDENT, "29TH_PARADE_INDEPENDENT"] call BIS_fnc_addRespawnInventory;
};