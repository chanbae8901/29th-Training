/*
 * Name:	fnc_recordSectorCapture
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Function that records capture of sector by team.
 *
 * Parameter(s): 
 * [_sector, _owner, _ownerOld] reference "ownerChanged" Scripted Event under _sector namespace.
 * 
 * Returns:
 * true if saved, false otherwise
 *
 * Example:
 * [_sector, _owner, _ownerOld] call DOTT_tracker_fnc_recordSectorCapture;
 * 
 */

#include "eventNumbers.hpp"
params ["_sector", "_owner", "_ownerOld"];
//sideUnknown check to prevent logging when sector is placed down
if (DOTT_tracker_startTime == -1 || _owner == sideUnknown) exitWith { false };
private _timeStamp = round(serverTime - DOTT_tracker_startTime);
private _sectorName = _sector getVariable ["name", "sector"];
private _event = [SECTOR_CAPTURE_NUM, _timeStamp, [_sectorName, _owner]];
DOTT_tracker_events pushBack _event;

true
