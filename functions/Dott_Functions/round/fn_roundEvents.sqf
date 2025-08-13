private _events = [
	[5*60, DOTT_round_fnc_timeWarning, []],   
    [1*60, DOTT_round_fnc_timeWarning, []]
];
private _timeLeft = call DOTT_round_fnc_getTime; 
private _eventIndex = 0;

while {_eventIndex < count _events} do {
    // Exit if round is no longer active
	if !(call DOTT_round_fnc_isRoundActive) exitWith {};

    _timeLeft = call DOTT_round_fnc_getTime; 

    while {(_eventIndex < count _events) && ((_events select _eventIndex) select 0 >= _timeLeft)} do {
        private _nextEvent = _events select _eventIndex;
		private _eventTime = _nextEvent select 0;
        private _fn = _nextEvent select 1;
        private _params = _nextEvent select 2;

		//avoid overlapping due to addTime and skip events before starting time
		//but do at least one time notification unless end was called
        if(_eventTime - _timeLeft < 10 || (_eventIndex == count _events - 1 && _timeLeft > 0)) then 
		{
			_params call _fn;
		};

        _eventIndex = _eventIndex + 1;
    };
    uiSleep 1; 
};
if !(call DOTT_round_fnc_isRoundActive) exitWith {}; //don't double call end in case of manual end
[] call DOTT_round_fnc_end;