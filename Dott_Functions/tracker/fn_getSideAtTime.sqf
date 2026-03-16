/**
 * Function: TN_tracker_fnc_getSideAtTime
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Finds a unit's side at a given time by searching their side
 * history (stored as [side, time] pairs in chronological order).
 *
 * Iterates backwards because the most recent side entry whose
 * timestamp is <= _time is the correct one. Reverse iteration
 * finds that entry first, allowing an immediate exitWith instead
 * of scanning the entire array forward.
 *
 * Parameters:
 * _unitIndex (Number): Index into _sides for this unit.
 * _time (Number): The event timestamp to look up.
 * _sides (Array): Side history array for all units.
 *
 * Returns:
 * Side -- the unit's side at _time.
 */

params ["_unitIndex", "_time", "_sides"];

private _unitSides = _sides select _unitIndex;

// Not sure if ever happens but just in case.
if (_unitSides isEqualTo []) exitWith { sideUnknown };

private _currentSide = (_unitSides select 0) select 0;

for "_i" from (count _unitSides - 1) to 0 step -1 do
{
    private _sideTime =
        (_unitSides select _i) select 1;
    if (_time >= _sideTime) exitWith
    {
        _currentSide =
            (_unitSides select _i) select 0;
    };
};

_currentSide
