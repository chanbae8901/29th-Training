/*
 * Name:	DOTT_radio_fnc_init
 * Date:	03/06/2026
 * Version: 1.2
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes radio module. Does nothing if TFAR Beta not enabled.
 * Should be initialized before loadout.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_radio_fnc_init;
 * 
 */

if !(isClass (configFile >> "CfgPatches" >> "tfar_core")) exitWith {};

if (hasInterface) then
{
	[missionNamespace, "arsenalClosed", {
		if !(isNull (findDisplay 312)) exitWith {}; //Don't do if Zeus Open (ZEN Loadout Editing)
		call DOTT_radio_fnc_add;
	}] call BIS_fnc_addScriptedEventHandler;

	if (isClass (configFile >> "CfgPatches" >> "ace_main")) then 
	{
		["ace_arsenal_displayClosed", 
		{
			if !(isNull (findDisplay 312)) exitWith {}; //Don't do if Zeus Open (ZEN Loadout Editing)
			call DOTT_radio_fnc_add;
		}] call CBA_fnc_addEventHandler;
	};

	["DOTT_radio_removeOnDeath", "Killed", 		
		{		
			if (TN_removeRadiosOnDeath) then
			{
				(_this select 0) call DOTT_radio_fnc_remove;
			};
		}
	] call CBA_fnc_addBISPlayerEventHandler;

	call DOTT_radio_fnc_initTransferSettings;
};

if (isServer) then
{
	//depending on setting, remove radios from disconnecting bodies
	addMissionEventHandler ["HandleDisconnect", {
		params ["_unit"];

		if (isNull _unit) exitWith {};

		if (TN_removeRadiosOnDeath) then
		{
			_unit call DOTT_radio_fnc_remove;
		};
	}];
}

