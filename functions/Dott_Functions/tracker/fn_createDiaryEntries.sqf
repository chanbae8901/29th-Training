/*
 * Name:	fnc_createDiaryEntries
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Client side function that creates diary entries after receiving information from server.
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
 *    ] remoteExec ["DOTT_tracker_fnc_createDiaryEntries"]; //from server
 * 
 */
#include "eventNumbers.hpp"
if (!hasInterface) exitWith {};
params["_events", "_names", "_sides", "_roundNum"];

if !(player diarySubjectExists "RoundEventLog") then 
{
    player createDiarySubject ["RoundEventLog", "Round Event Log"];	
};
	
private _lines = [];
for "_i" from ((count _events) - 1) to 0 step -1 do 
{
    private _line = ([_events select _i, _names, _sides] call DOTT_tracker_fnc_eventToString);
    _lines pushBack _line;
};
private _title = format["Round %1", _roundNum];
private _copyButton = format["<execute expression='[""%1"",""%2""] call DOTT_tracker_fnc_copyRecordToClipboard;'>Copy to Clipboard</execute>", "RoundEventLog", _title];
_lines pushBack _copyButton;

private _text = _lines joinString "<br />";
player createDiaryRecord ["RoundEventLog", [_title, _text]];


if !(player diarySubjectExists "RoundScoreboard") then 
{
    DOTT_tracker_diary_subject = player createDiarySubject ["RoundScoreboard", "Round Scoreboard"];	
};

private _killCounts = [_events, _sides] call DOTT_tracker_fnc_getKillCounts;
_text = [_killCounts, _names] call DOTT_tracker_fnc_killCountsToString;
_copyButton = format["<br /><execute expression='[""%1"",""%2""] call DOTT_tracker_fnc_copyRecordToClipboard;'>Copy to Clipboard</execute>", "RoundScoreboard", _title];
_text = _text + _copyButton;
player createDiaryRecord ["RoundScoreboard", [_title, _text]];

true