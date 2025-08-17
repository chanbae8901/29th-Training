#include "eventNumbers.hpp"
params["_event"];
private _eventType = _event select 0;
private _eventInfo = _event select 2;

switch (_eventType) do 
{
	case ACE_CONSCIOUSNESS_NUM: 
	{
		private _unitName = (_eventInfo select 0) select 0;
		private _unitSide = (_eventInfo select 0) select 1;
		_eventInfo set [0, [_unitName, _unitSide] call DOTT_tracker_fnc_nameToNum];
		if(count _eventInfo > 2) then 
		{ 
			private _instigatorName = (_eventInfo select 2) select 0;
			private _instigatorSide = (_eventInfo select 2) select 1;
			_eventInfo set [2, [_instigatorName, _instigatorSide] call DOTT_tracker_fnc_nameToNum];
		};
	};
	case KILL_NUM: 
	{
		private _unitName = (_eventInfo select 0) select 0;
		private _unitSide = (_eventInfo select 0) select 1;
		_eventInfo set [0, [_unitName, _unitSide] call DOTT_tracker_fnc_nameToNum];
		if(count _eventInfo > 1) then 
		{
			private _instigatorName = (_eventInfo select 1) select 0;
			private _instigatorSide = (_eventInfo select 1) select 1;
			_eventInfo set [1, [_instigatorName, _instigatorSide] call DOTT_tracker_fnc_nameToNum];
		};
	};
};

DOTT_tracker_trackedEvents pushBack _event;