/*
 * Name:	DOTT_loadout_fnc_resetWeaponState
 * Date:	8/10/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Force resync of weapon state server side by unequipping and requipping binoculars (or opposite if no binoculars are equipped).
 * Binoculars are used so that it will not affect the fire mode of other weapons
 * NOTE: Seems to not work perfectly, only prevents one cause of desync (weapon holder to server, server to everyone else still happens).
 *
 * Parameter(s): 
 * _unit: local unit that needs to reset weapon state
 * 
 * Returns:
 * true
 *
 * Example:
 * [_unit] spawn DOTT_loadout_fnc_resetWeaponState;
 * 
 */

params["_unit"];

private _bino = binocular _unit;

if (_bino == "") then 
{
	private _defaultBino = "Binocular"; 
	
	_unit addWeapon [_defaultBino, false];
	uiSleep 0.5; //from 0.05
	
	_unit removeWeapon [_defaultBino, false];
} else 
{
	private _attachments = binocularItems _unit;
	private _binoMags = binocularMagazine _unit;

	_unit removeWeapon [_bino, false];
	waitUntil { uiSleep 0.5; !isSwitchingWeapon _unit }; //from 0.1
	_unit addWeapon [_bino, false];

	{
		_unit addBinocularItem _x;
	} forEach _binoMags;

	{
		_unit addBinocularItem _x;
	} forEach _attachments;
};