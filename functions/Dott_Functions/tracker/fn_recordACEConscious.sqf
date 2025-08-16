#include "eventNumbers.hpp"
params["_unit", "_state"];
if (DOTT_tracker_startTime == -1) exitWith { false };
private _timeStamp = round(serverTime - DOTT_tracker_startTime);
private _eventInfo = [name _unit, _state];
if (_state) then 
{
	private _instigator = [_unit, _unit, objNull] call DOTT_tracker_fnc_findInstigator;
	if (!isNull _instigator) then 
	{
		_eventInfo pushBack (name _instigator);
		private _distance = round (_unit distance _instigator);
		_eventInfo pushBack _distance;
	};
};

private _event = [ACE_CONSCIOUSNESS_NUM, _timeStamp, _eventInfo];
[_event] remoteExec ["DOTT_tracker_fnc_sendEvent", 2]; 
