/*
 * Name:	fnc_roundEvents
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Stores and manages round events, such as time warnings.
 * Also handles the end of the round by calling the end function.
 * Should be remote executed on server and all clients.
 * Stored in roundEventsScript to terminate from fn_end if needed.
 * Lot of things hardcoded to assume its only used for notifications right now. 
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * None
 *
 * Example:
 * [] remoteExec ["DOTT_round_fnc_roundEvents"]; 
 * 
 */

if (!hasInterface) exitWith {}; //no server sided things to do here for now

DOTT_round_timeAdded = false;
private _events = 
[
	[5*60, DOTT_round_fnc_timeWarning, []],   
	[1*60, DOTT_round_fnc_timeWarning, []]
];
private _timeLeft = call DOTT_round_fnc_getTime; 
private _eventIndex = 0;

while {_timeLeft > 0 || overtimeEnabled == true} do 
{
	//handle addTime increasing time
	if(DOTT_round_timeAdded) then 
	{
		_eventIndex = 0;
		DOTT_round_timeAdded = false;
	};

	while {(_eventIndex < count _events) && ((_events select _eventIndex) select 0 >= _timeLeft)} do 
	{
		private _nextEvent = _events select _eventIndex;
		private _eventTime = _nextEvent select 0;
		private _fn = _nextEvent select 1;
		private _params = _nextEvent select 2;

		//avoid overlapping due to addTime and skip events before starting time
		//but do at least one time notification unless end was called
		if(_eventTime - _timeLeft < 30 || (_eventIndex == count _events - 1 && _timeLeft > 0)) then 
		{
			_params call _fn;
		};

		_eventIndex = _eventIndex + 1;
	};
	uiSleep 1; 
	_timeLeft = call DOTT_round_fnc_getTime; 		
};