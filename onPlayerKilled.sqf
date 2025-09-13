/*	Executed when player is killed in singleplayer or in multiplayer mission.
[<oldUnit>, <killer>, <respawn>, <respawnDelay>]
*/

params ["_dead"];
oldSwRadioSettings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
_removeRadiosFromDead = "removeRadiosFromDead" call BIS_fnc_getParamValue;
if (_removeRadiosFromDead == 1) then
{
	_dead call Hill_fnc_removeRadio;
};