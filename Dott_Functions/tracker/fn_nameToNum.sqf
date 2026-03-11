/**
 * File: fn_nameToNum.sqf
 * Function: DOTT_tracker_fnc_nameToNum
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Server-side function that registers or looks up a unit's name
 * in DOTT_tracker_names and maintains their side history in
 * DOTT_tracker_sides. Returns the index for compact storage.
 *
 * Parameters:
 * _name (String): Unit name to register/look up.
 * _side (Side): Unit's current side.
 * _eventTime (Number): Timestamp for side history tracking.
 *
 * Returns:
 * Number -- index into DOTT_tracker_names / DOTT_tracker_sides.
 */

params ["_name", "_side", "_eventTime"];

private _num = DOTT_tracker_names find _name;

if (_num == -1) then
{
    DOTT_tracker_names pushBack _name;
    DOTT_tracker_sides pushBack
        [[_side, _eventTime]];
    _num = count DOTT_tracker_names - 1;
}
else
{
    private _sides = DOTT_tracker_sides select _num;
    private _lastSide =
        (_sides select ((count _sides) - 1)) select 0;
    if (_side != _lastSide) then
    {
        _sides pushBack [_side, _eventTime];
    };
};

_num
