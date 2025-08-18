/*
 * Name:	fnc_saveEvent
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Server side function that converts event array and stores it in DOTT_tracker_events.
 * New array stored replaces info with index numbers that can be dereferenced in DOTT_tracker_names 
 * and DOTT_tracker_sides. Hopefully reduces total storage for network transmission.
 *
 * Parameter(s): 
 * _event (Array): Array of event created by other tracker functions.
 * 
 * Returns:
 * true
 *
 * Example:
 * [_event] call DOTT_tracker_fnc_saveEvent;
 * 
 */

#include "eventNumbers.hpp"
params["_event"];
private _eventType = _event select 0;
private _eventTime = _event select 1;
private _eventInfo = _event select 2;

switch (_eventType) do 
{
	case ACE_CONSCIOUSNESS_NUM: 
	{
		private _unit = _eventInfo select 0;		
		private _unitName = _unit select 0;
		private _unitSide = _unit select 1;
		_eventInfo set [0, [_unitName, _unitSide, _eventTime] call DOTT_tracker_fnc_nameToNum];
		if(count _eventInfo > 2) then 
		{ 
			private _instigator = _eventInfo select 2;
			private _instigatorName = _instigator select 0;
			private _instigatorSide = _instigator select 1;
			_eventInfo set [2, [_instigatorName, _instigatorSide, _eventTime] call DOTT_tracker_fnc_nameToNum];
		};
	};
	case KILL_NUM: 
	{
		private _unit = _eventInfo select 0;		
		private _unitName = _unit select 0;
		private _unitSide = _unit select 1;
		_eventInfo set [0, [_unitName, _unitSide, _eventTime] call DOTT_tracker_fnc_nameToNum];
		if(count _eventInfo > 1) then 
		{
			private _instigator = _eventInfo select 1;
			private _instigatorName = _instigator select 0;
			private _instigatorSide = _instigator select 1;
			_eventInfo set [1, [_instigatorName, _instigatorSide, _eventTime] call DOTT_tracker_fnc_nameToNum];
		};
	};
};

DOTT_tracker_events pushBack _event;

true