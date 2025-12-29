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


