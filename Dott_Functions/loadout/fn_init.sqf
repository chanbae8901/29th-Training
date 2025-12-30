/*
 * Name:	DOTT_loadout_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes loadout module.
 * Should be initialized after radio.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_loadout_fnc_init;
 * 
 */

if (hasInterface) then 
{
	[missionNamespace, "arsenalClosed", {
		call DOTT_loadout_fnc_arsenalClosed;
	}] call BIS_fnc_addScriptedEventHandler;

	if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {
		["ace_arsenal_displayClosed", 
			{
				call DOTT_loadout_fnc_arsenalClosed;
			}
		] call CBA_fnc_addEventHandler;
	};

	["DOTT_loadout_setInsigniaRespawn", "Respawn", {(_this select 0) spawn DOTT_loadout_fnc_setInsignia}] call CBA_fnc_addBISPlayerEventHandler;
};

if (isServer) then
{

};