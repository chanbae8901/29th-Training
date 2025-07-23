/*	Executed when player is killed in singleplayer or in multiplayer mission.
[<oldUnit>, <killer>, <respawn>, <respawnDelay>]
*/

params ["_dead"];

_removeRadiosFromDead = "removeRadiosFromDead" call BIS_fnc_getParamValue;
if (_removeRadiosFromDead == 1) then
{
	_dead call Hill_fnc_removeRadio;
};

//diag_log text format ["|KILLED(_this select 0)|  POS:  %1, IS HIDDEN?: %2, SIMULATION?:  %3",position _dead,isObjectHidden _dead,simulationEnabled _dead];
//diag_log text format ["|KILLED(player)|  POS:  %1, IS HIDDEN?: %2, SIMULATION?:  %3",position player,isObjectHidden player,simulationEnabled player];