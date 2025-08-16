#include "eventNumbers.hpp"
params ["_unit", "_killer", "_instigator"];
if (DOTT_tracker_startTime == -1) exitWith { false };

_instigator = [_killer, _unit, _instigator] call DOTT_tracker_fnc_findInstigator;

private _timeStamp = round(serverTime - DOTT_tracker_startTime);

private _event = [KILL_NUM, _timeStamp];
private _killInfo = [name _unit];
if !(isNull _instigator) then 
{
	_killInfo pushBack (name _instigator);
	private _distance = round (_unit distance _instigator);
	_killInfo pushBack _distance;
};

_event pushBack _killInfo;

[_event] remoteExec ["DOTT_tracker_fnc_sendEvent", 2]; 

true