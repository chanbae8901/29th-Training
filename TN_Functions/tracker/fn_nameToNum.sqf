/*
 * Author: Bae [29th ID]
 * Server-side function that registers or looks up a unit's name
 * in TN_tracker_names and maintains their side history in
 * TN_tracker_sides. Returns the index for compact storage.
 *
 * Arguments:
 * 0: Unit name to register/look up <STRING>
 * 1: Unit's current side <SIDE>
 * 2: Timestamp for side history tracking <NUMBER>
 *
 * Return Value:
 * Index into TN_tracker_names / TN_tracker_sides <NUMBER>
 */

params ["_name", "_side", "_eventTime"];

private _num = TN_tracker_names find _name;

if (_num == -1) then
{
    TN_tracker_names pushBack _name;
    TN_tracker_sides pushBack
        [[_side, _eventTime]];
    _num = count TN_tracker_names - 1;
}
else
{
    private _sides = TN_tracker_sides select _num;
    private _lastSide =
        (_sides select -1) select 0;
    if (_side != _lastSide) then
    {
        _sides pushBack [_side, _eventTime];
    };
};

_num
