/*	Executed when player is killed in singleplayer or in multiplayer mission.
[<oldUnit>, <killer>, <respawn>, <respawnDelay>]
*/

params ["_dead"];

if (DOTT_removeRadiosOnDeath) then
{
	_dead call Hill_fnc_removeRadio;
};