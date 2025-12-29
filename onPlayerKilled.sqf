/*	Executed when player is killed in singleplayer or in multiplayer mission.
[<oldUnit>, <killer>, <respawn>, <respawnDelay>]
*/

params ["_dead"];

if (TN_removeRadiosOnDeath) then
{
	_dead call DOTT_radio_fnc_removeRadio;
};