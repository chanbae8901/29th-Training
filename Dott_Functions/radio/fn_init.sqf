/*
 * Name:	DOTT_radio_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
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
	if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {
		["ace_arsenal_displayClosed", 
		{
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

