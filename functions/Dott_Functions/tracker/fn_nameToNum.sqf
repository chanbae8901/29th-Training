/*
 * Name:	fnc_nameToNum
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Server side function that checks/stores unit's name and (potenitally updates) current side in 
 * DOTT_tracker_names and DOTT_tracker_sides and returns index to reference said arrays.
 *
 * Parameter(s): 
 * _name (String): Name to check/store
 * _side (Side): Side to check/store/update
 * _eventTime (Number): Used to save time of _side for side history
 *
 * Returns:
 * Index where unit info is stored in DOTT_tracker_names and DOTT_tracker_sides
 *
 * Example:
 * [_name, _side, _eventTime] call DOTT_tracker_fnc_nameToNum;
 * 
 */

params["_name", "_side", "_eventTime"];
private _num = DOTT_tracker_names find _name;
if (_num == -1) then 
{
	DOTT_tracker_names pushBack _name;
	DOTT_tracker_sides pushBack [[_side, _eventTime]];

	_num = count DOTT_tracker_names - 1;
} else {
	private _sides = DOTT_tracker_sides select _num;
	private _lastSide = (_sides select ((count _sides) - 1)) select 0;
	if (_side != _lastSide) then {
		_sides pushBack [_side, _eventTime];
	}	
};

_num
