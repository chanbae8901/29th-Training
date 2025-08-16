#include "eventNumbers.hpp"
params ["_sector", "_owner", "_ownerOld"];
if (DOTT_tracker_startTime == -1 || _owner == sideUnknown) exitWith { false };
private _timeStamp = round(serverTime - DOTT_tracker_startTime);
private _sectorName = _sector getVariable ["name", "sector"];
private _event = [SECTOR_CAPTURE_NUM, _timeStamp, [_sectorName, _owner]];
DOTT_tracker_trackedEvents pushBack _event;

true
