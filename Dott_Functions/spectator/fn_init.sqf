/*
 * Name:	DOTT_spectator_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes spectator module.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_spectator_fnc_init;
 * 
 */

//Only autospectate init here right now
if (hasInterface) then
{
	["DOTT_spectator_autoSpectate", "Respawn", 		
		{	
			params ["_newUnit", "_oldUnit"];	
			if (!isNull _oldUnit) then 
			{
				if (TN_autoSpectate) then 
				{
					systemChat "AutoSpectate is ON.";
					[_newUnit] spawn DOTT_spectator_fnc_enter;
				};
			};
		}
	] call CBA_fnc_addBISPlayerEventHandler;	
};


