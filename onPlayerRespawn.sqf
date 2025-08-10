/*
Executed locally (client only) when player respawns in a multiplayer mission.
		- [<newUnit>, <oldUnit>, <respawn>, <respawnDelay>]
		- This event script will also fire at the beginning of a mission if respawnOnStart is 0 or 1, oldUnit will be objNull in this instance.
		- This script will not fire at mission start if respawnOnStart equals -1 in description.ext
*/
params ["_newUnit", "_oldUnit"];

_newUnit spawn Hill_fnc_setInsignia;


if (!isNull _oldUnit) then { //was '!(isNull _oldUnit)' Not sure why, changed it - Dott
  //diag_log text format ["|RESPAWN|  OLD UNIT POS:  %1, OLD UNIT IS HIDDEN?: %2, OLD UNIT SIMULATION?:  %3",position _oldUnit,isObjectHidden _oldUnit,simulationEnabled _oldUnit];
  //diag_log text format ["|RESPAWN 01|  NEW UNIT POS 01:  %1, NEW UNIT IS HIDDEN?: %2, NEW UNIT SIMULATION?:  %3",position _newUnit,isObjectHidden _newUnit,simulationEnabled _newUnit];
  //_resPos = getPos player; //BROKEN - Arma 3 V2.18 seems to have broken this. Commented out any pos related stuff
  titleText ["", "BLACK FADED", 5];
  player hideobject true;
  player enablesimulation false;
  //player setpos [10,10,10];
  //diag_log text format ["|RESPAWN 02|  NEW UNIT POS 02:  %1, NEW UNIT IS HIDDEN?: %2, NEW UNIT SIMULATION?:  %3",position _newUnit,isObjectHidden _newUnit,simulationEnabled _newUnit];
  uiSleep 1.5;
  //player setPos _resPos;
  player hideobject false;
  player enablesimulation true;
  titleText ["", "BLACK IN", 2];
  //diag_log text format ["|RESPAWN 03|  NEW UNIT POS 02:  %1, NEW UNIT IS HIDDEN?: %2, NEW UNIT SIMULATION?:  %3",position _newUnit,isObjectHidden _newUnit,simulationEnabled _newUnit];

	if ( missionNamespace getVariable [ "menuRespawn", true ] ) then {
		if (autoSpectate) then {
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