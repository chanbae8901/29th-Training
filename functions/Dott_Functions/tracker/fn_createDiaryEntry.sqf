if (!hasInterface) exitWith {};
waitUntil {sleep 1; !isNil {DOTT_tracker_trackedEvents} && !isNil {DOTT_tracker_names}};

private _lines = [];

for "_i" from ((count DOTT_tracker_trackedEvents) - 1) to 0 step -1 do 
{
    private _line = ([DOTT_tracker_trackedEvents select _i] call DOTT_tracker_fnc_eventToString);
    _lines pushBack _line;
};

private _text = _lines joinString "<br />";
player createDiaryRecord ["RoundEventLog", [format["Round %1", DOTT_tracker_currentRound], _text]];

DOTT_tracker_trackedEvents = nil;
DOTT_tracker_names = nil;	