/*
 * Name:	fnc_cleaner
 * Date:	7/26/2025
 * Version: 1.1
 * Author:  Rellikplug	AKA: Hill [29th ID]
 *
 * Description:
 * Removes all dead bodies along with items (ex. weapons, magazines) around 250 meters from 
 * the base garbage cans (which should have this function attached with addAction).
 *
 * Parameter(s): None
 *
 * Returns:
 * false if no objects deleted, true otherwise
 *
 * Example:
 * call Hill_fnc_cleaner;
 * 
 */

private ["_dead","_posBlu","_posRed","_posGreen","_all_garbages","_near_objects","_countObjects","_countDead","_countAllNear"];

_dead = allDeadMen;

	//  define positions of objects addAction is attached to
_posBlu = getPosATL blu_garbage;
_posRed = getPosATL red_garbage;
_posGreen = getPosATL green_garbage;
_all_garbages = [_posBlu,_posRed,_posGreen];

	//  get items around trash cans
_near_objects =  [];
{
    _near_objects append (nearestObjects [_x, ["WeaponHolder", "GroundWeaponHolder"], 250]);
} forEach _all_garbages;

_countObjects = count _near_objects;
_countDead = count _dead;
_countAllNear = _countObjects + _countDead;

if (_countAllNear < 1) exitWith 
{
	hintSilent "Nothing to delete.";
	false
};

{ deleteVehicle _x; } forEach _dead;
{ deleteVehicle _x; } forEach _near_objects;
_text = format ["Cleaned:\n%1 Objects\n%2 Dead Bodies",_countObjects,_countDead];
hintSilent _text;
true