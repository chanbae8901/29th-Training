/*
 * Name:	fnc_createDiaryEntry
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Client side function that creates the diary entry after receiving information from server.
 *
 * Parameter(s): 
 * _events (Array): DOTT_tracker_events from server
 * _names (Array): DOTT_tracker_names from server
 * _sides (Array): DOTT_tracker_sides from server
 * _roundNum (Number): Round number to put in diary
 *
 * Returns:
 * true
 *
 * Example:
 * 	  [
 *        DOTT_tracker_events,
 *        DOTT_tracker_names,
 *        DOTT_tracker_sides,	
 *        DOTT_tracker_currentRound
 *    ] remoteExec ["DOTT_tracker_fnc_createDiaryEntry"]; //from server
 * 
 */
if (!hasInterface) exitWith {};
params["_events", "_names", "_sides", "_roundNum"];

if !(player diarySubjectExists "RoundEventLog") then 
{
    DOTT_tracker_diary_subject = player createDiarySubject ["RoundEventLog","Round Event Log"];	
};
	
private _lines = [];

for "_i" from ((count _events) - 1) to 0 step -1 do 
{
    private _line = ([_events select _i, _names, _sides] call DOTT_tracker_fnc_eventToString);
    _lines pushBack _line;
};
private _copyButton = format["<execute expression='%1 call DOTT_tracker_fnc_copyRoundToClipboard;'>Copy to Clipboard</execute>",_roundNum];
_lines pushBack _copyButton;

private _text = _lines joinString "<br />";
player createDiaryRecord ["RoundEventLog", [format["Round %1", _roundNum], _text]];

true