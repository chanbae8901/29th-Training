#include "eventNumbers.hpp"
params["_event"];
private _eventType = _event select 0;
private _eventTime = _event select 1;
private _eventInfo = _event select 2;

private _minutes = floor (_eventTime / 60);
private _seconds = _eventTime % 60;
private _secondStr = if (_seconds < 10) then { "0" + str _seconds } else { _seconds };

private _eventString = "";

switch (_eventType) do 
{
	case KILL_NUM: 
	{
		private _unitName = DOTT_tracker_names select (_eventInfo select 0);
		if(count _eventInfo > 1) then 
		{
			private _instigatorName = 	DOTT_tracker_names select (_eventInfo select 1);
			private _distance = _eventInfo select 2;	
			_eventString = format["%1:%2 - %3 killed by %4 from %5 meters.", _minutes, _secondStr, _unitName, _instigatorName, _distance];
		} else 
		{
			_eventString = format ["%1:%2 - %3 killed by unknown.", _minutes, _secondStr, _unitName];
		};

	};

	case SECTOR_CAPTURE_NUM:
	{
		private _sectorName = _eventInfo select 0;
		private _newOwner = _eventInfo select 1;
		private _newOwnerName = _newOwner call BIS_fnc_sideName;
		_eventString = format ["%1:%2 - %3 captured by %4.", _minutes, _secondStr, _sectorName, _newOwnerName];
	};

	case ACE_CONSCIOUSNESS_NUM: 
	{
		private _unitName = DOTT_tracker_names select (_eventInfo select 0);
		private _state = _eventInfo select 1;
		if (_state) then 
		{
			if(count _eventInfo > 2) then 
			{ 
				private _instigatorName = 	DOTT_tracker_names select (_eventInfo select 2);
				private _distance = _eventInfo select 3;
				_eventString = format ["%1:%2 - %3 knocked unconscious by %4 from %5 meters.", _minutes, _secondStr, _unitName, _instigatorName, _distance];			
			};
		} else
		{
			_eventString = format ["%1:%2 - %3 regained consciousness.", _minutes, _secondStr, _unitName];
		};
	};
};

_eventString
