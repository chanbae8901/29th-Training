/*
 * Name:	DOTT_tracker_fnc_eventToString
 * Date:	9/30/2025
 * Version: 1.2
 * Author:  Bae [29th ID]
 *
 * Description:
 * Converts event array info into string for diary.
 *
 * Parameter(s): 
 * _event (Array): Event to make string.
 * _names (Array): Name references for event.
 * _sides (Array): Side references for event.
 *
 * Returns:
 * String of event
 *
 * Example:
 * [_events select 0, _names, _sides] call DOTT_tracker_fnc_eventToString;
 * 
 */

#include "eventNumbers.hpp"
params["_event", "_names", "_sides", "_weapons"];
private _eventType = _event select 0;
private _eventTime = _event select 1;
private _eventInfo = _event select 2;

private _fn_formatTime = {
	params["_time"];
	private _minutes = floor (_time / 60);
	private _seconds = _time % 60;
	private _secondStr = if (_seconds < 10) then { "0" + str _seconds } else { _seconds };
	[_minutes, _secondStr];
};


private _time = if (_eventTime isEqualType []) then {_eventTime select 0} else {_eventTime};
(_time call _fn_formatTime) params ["_minutes", "_secondStr"];

private _eventString = "";

switch (_eventType) do 
{
	case INFANTRY_KILL_NUM: 
	{
		private _unitIndex = _eventInfo select 0;
		private _unitName = _names select _unitIndex;
		private _unitSide = [_unitIndex, _eventTime, _sides] call DOTT_tracker_fnc_getSideAtTime;
		_unitName = [_unitName, _unitSide] call DOTT_tracker_fnc_colorNameWithSide;
		if(count _eventInfo > 1) then 
		{
			private _instigatorIndex = _eventInfo select 1;
			private _instigatorName = _names select (_instigatorIndex);
			private _instigatorSide = [_instigatorIndex, _eventTime, _sides] call DOTT_tracker_fnc_getSideAtTime;
			_instigatorName = [_instigatorName, _instigatorSide] call DOTT_tracker_fnc_colorNameWithSide;			
			private _distance = _eventInfo select 2;
			private _weapon = _weapons select (_eventInfo select 3);	
			_eventString = format["%1:%2 - %3 killed by %4 [%5] from %6 meters.", _minutes, _secondStr, _unitName, _instigatorName, _weapon, _distance];
		} else 
		{
			_eventString = format ["%1:%2 - %3 killed.", _minutes, _secondStr, _unitName];
		};
	};
	case DELAY_KILL_NUM: 
	{
		private _unitIndex = _eventInfo select 0;
		private _unitName = _names select _unitIndex;
		private _unitSide = [_unitIndex, _eventTime select 0, _sides] call DOTT_tracker_fnc_getSideAtTime; 
		_unitName = [_unitName, _unitSide] call DOTT_tracker_fnc_colorNameWithSide;

		private _instigatorIndex = _eventInfo select 1;
		private _instigatorName = _names select (_instigatorIndex);
		private _instigatorSide = [_instigatorIndex, _eventTime select 1, _sides] call DOTT_tracker_fnc_getSideAtTime; //note we use the hitTime here
		_instigatorName = [_instigatorName, _instigatorSide] call DOTT_tracker_fnc_colorNameWithSide;	

		private _distance = _eventInfo select 2;
		private _weapon = _weapons select (_eventInfo select 3);	

		private _time2 = _eventTime select 1;
		(_time2 call _fn_formatTime) params ["_minutes2", "_secondStr2"];		
		_eventString = format["%1:%2 - %3 finally killed by %4 [%5] (%6:%7) from %8 meters. ", _minutes, _secondStr, _unitName, _instigatorName, _weapon, _minutes2, _secondStr2, _distance];
	};	
	//same as infantry
	case VEHICLE_KILL_NUM: 
	{
		private _unitIndex = _eventInfo select 0;
		private _unitName = _names select _unitIndex;
		private _unitSide = [_unitIndex, _eventTime, _sides] call DOTT_tracker_fnc_getSideAtTime;
		_unitName = [_unitName, _unitSide] call DOTT_tracker_fnc_colorNameWithSide;
		if(count _eventInfo > 1) then 
		{
			private _instigatorIndex = _eventInfo select 1;
			private _instigatorName = _names select (_instigatorIndex);
			private _instigatorSide = [_instigatorIndex, _eventTime, _sides] call DOTT_tracker_fnc_getSideAtTime;
			_instigatorName = [_instigatorName, _instigatorSide] call DOTT_tracker_fnc_colorNameWithSide;			
			private _distance = _eventInfo select 2;
			private _weapon = _weapons select (_eventInfo select 3);			
			_eventString = format["%1:%2 - %3 destroyed by %4 [%5] from %6 meters.", _minutes, _secondStr, _unitName, _instigatorName, _weapon, _distance];
		} else 
		{
			_eventString = format ["%1:%2 - %3 destroyed.", _minutes, _secondStr, _unitName];
		};
	};
	case SECTOR_CAPTURE_NUM:
	{
		private _sectorName = _eventInfo select 0;
		private _newOwner = _eventInfo select 1;
		private _newOwnerName = _newOwner call BIS_fnc_sideName;
		_newOwnerName = [_newOwnerName, _newOwner] call DOTT_tracker_fnc_colorNameWithSide;
		_eventString = format ["%1:%2 - %3 captured by %4.", _minutes, _secondStr, _sectorName, _newOwnerName];
	};

	case ACE_CONSCIOUSNESS_NUM: 
	{
		private _unitIndex = _eventInfo select 0;
		private _unitName = _names select _unitIndex;
		private _unitSide = [_unitIndex, _eventTime, _sides] call DOTT_tracker_fnc_getSideAtTime;
		_unitName = [_unitName, _unitSide] call DOTT_tracker_fnc_colorNameWithSide;
		private _state = _eventInfo select 1;
		if (_state) then 
		{
			if(count _eventInfo > 2) then 
			{ 
				private _instigatorIndex = _eventInfo select 2;
				private _instigatorName = _names select (_instigatorIndex);
				private _instigatorSide = [_instigatorIndex, _eventTime, _sides] call DOTT_tracker_fnc_getSideAtTime;
				_instigatorName = [_instigatorName, _instigatorSide] call DOTT_tracker_fnc_colorNameWithSide;
				private _distance = _eventInfo select 3;
				private _weapon = _weapons select (_eventInfo select 4);
				_eventString = format ["%1:%2 - %3 unconscious by %4 [%5] from %6 meters.", _minutes, _secondStr, _unitName, _instigatorName, _weapon, _distance];			
			} else
			{
				_eventString = format ["%1:%2 - %3 unconscious.", _minutes, _secondStr, _unitName];				
			};
		} else
		{
			_eventString = format ["%1:%2 - %3 conscious.", _minutes, _secondStr, _unitName];
		};
	};

	case DELAY_ACE_CONSCIOUSNESS_NUM: 
	{
		private _unitIndex = _eventInfo select 0;
		private _unitName = _names select _unitIndex;
		private _unitSide = [_unitIndex, _eventTime select 0, _sides] call DOTT_tracker_fnc_getSideAtTime;
		_unitName = [_unitName, _unitSide] call DOTT_tracker_fnc_colorNameWithSide;

		private _state = _eventInfo select 1;

		private _instigatorIndex = _eventInfo select 2;
		private _instigatorName = _names select (_instigatorIndex);
		private _instigatorSide = [_instigatorIndex, _eventTime select 1, _sides] call DOTT_tracker_fnc_getSideAtTime; //note we use the hitTime here
		_instigatorName = [_instigatorName, _instigatorSide] call DOTT_tracker_fnc_colorNameWithSide;

		private _distance = _eventInfo select 3;
		private _weapon = _weapons select (_eventInfo select 4);

		private _time2 = _eventTime select 1;
		(_time2 call _fn_formatTime) params ["_minutes2", "_secondStr2"];		
		_eventString = format ["%1:%2 - %3 finally unconscious by %4 [%5] (%6:%7) from %8 meters. ", _minutes, _secondStr, _unitName, _instigatorName, _weapon, _minutes2, _secondStr2, _distance];
	};	
};

_eventString
