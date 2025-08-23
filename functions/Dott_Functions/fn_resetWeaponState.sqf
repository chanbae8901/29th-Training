/*
 * Name:	fnc_resetWeaponState
 * Date:	8/10/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Force resync of weapon state server side by unequipping and requipping binoculars (or opposite if no binoculars are equipped).
 * Binoculars are used so that it will not affect the fire mode of other weapons
 *
 * Parameter(s): 
 * _unit: local unit that needs to reset weapon state
 * 
 * Returns:
 * true
 *
 * Example:
 * [_unit] spawn resetWeaponState;
 * 
 */

params["_unit"];

private _bino = binocular _unit;

if (_bino == "") then 
{
	private _defaultBino = "Binocular"; 
	
	_unit addWeapon _defaultBino;
	uiSleep 0.05;
	
	_unit removeWeapon _defaultBino;
} else 
{
	private _attachments = binocularItems _unit;
	private _binoMags = binocularMagazine _unit;

	_unit removeWeapon _bino;
	waitUntil { uiSleep 0.1; !isSwitchingWeapon _unit };
	_unit addWeapon _bino;

	{
		_unit addBinocularItem _x;
	} forEach _binoMags;

	{
		_unit addBinocularItem _x;
	} forEach _attachments;
};