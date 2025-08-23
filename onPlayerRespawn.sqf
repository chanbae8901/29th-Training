/*
Executed locally (client only) when player respawns in a multiplayer mission.
		- [<newUnit>, <oldUnit>, <respawn>, <respawnDelay>]
		- This event script will also fire at the beginning of a mission if respawnOnStart is 0 or 1, oldUnit will be objNull in this instance.
		- This script will not fire at mission start if respawnOnStart equals -1 in description.ext
*/
params ["_newUnit", "_oldUnit"];

_newUnit spawn Hill_fnc_setInsignia;


if (!isNull _oldUnit) then {
	if (missionNamespace getVariable ["menuRespawn", true]) then 
    {
		if (autoSpectate) then 
    	{
			systemChat "AutoSpectate is ON.";
			[_newUnit] spawn Hill_fnc_enter_spectator;
		};
	};
};

//Dott tickets management
if (DOTT_ticketEnabled) then
{
	private _playerSide = playerSide;
	[_playerSide] remoteExec ["DOTT_fnc_ticketCount", 2];
};