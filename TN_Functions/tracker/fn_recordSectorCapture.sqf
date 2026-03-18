/*
 * Author: Bae [29th ID]
 * Records a sector ownership change event. Bypasses the
 * conversion logic in fn_saveEvent since sector events use
 * raw names/sides rather than indexed references.
 *
 * Arguments:
 * 0: The sector module <OBJECT>
 * 1: New owning side <SIDE>
 * 2: Previous owning side <SIDE>
 *
 * Return Value:
 * true if saved, false otherwise <BOOL>
 */

#include "eventNumbers.hpp"
params ["_sector", "_owner", "_ownerOld"];

// sideUnknown check to prevent logging when sector is
// placed down.
if (TN_tracker_startTime == -1
    || _owner == sideUnknown) exitWith { false };

private _timeStamp =
    round(serverTime - TN_tracker_startTime);
private _sectorName =
    _sector getVariable ["name", "sector"];
private _event = [
    SECTOR_CAPTURE_NUM,
    _timeStamp,
    [_sectorName, _owner]
];
TN_tracker_events pushBack _event;

true
