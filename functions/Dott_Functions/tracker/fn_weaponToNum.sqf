/*
 * Name:	fnc_weaponToNum
 * Date:	8/26/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Server side function that checks/stores weapon name in DOTT_tracker_weapons and 
 * returns the index where it is (now) stored.
 *
 * Parameter(s): 
 * _weaponName (String): Name of weapon to check/store
 *
 * Returns:
 * (Number) Index where weapon name is in DOTT_tracker_weapons
 *
 * Example:
 * ["AK-74M"] call DOTT_tracker_fnc_weaponToNum;
 * 
 */

params["_weaponName"];
private _num = DOTT_tracker_weapons find _weaponName;
if (_num == -1) then 
{
	DOTT_tracker_weapons pushBack _weaponName;
	_num = count DOTT_tracker_weapons - 1;
};

_num