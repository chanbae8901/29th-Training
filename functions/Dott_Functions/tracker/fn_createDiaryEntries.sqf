/*
 * Name:	fnc_createDiaryEntries
 * Date:	8/26/2025
 * Version: 1.1
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
params["_events", "_names", "_sides", "_weapons", "_roundNum"];

waitUntil {DOTT_tracker_last_round_Recorded == (_roundNum - 1)};

if !(player diarySubjectExists "RoundEventLog") then 
{
    player createDiarySubject ["RoundEventLog", "Round Event Log"];
    private _infoLines = ["All Events show every recorded event for each round. (Kills, Unconscious, Sector Captures)"];
    _infoLines pushBack "Personal Events shows events relevant to you, including if the people you knock unconscious regain consciousness or are killed.";
    _infoLines pushBack "Information is updated at the end of the round and is lost when aborting/disconnecting.";
    private _infoText = _infoLines joinString "<br />";
    player createDiaryRecord ["RoundEventLog", ["Information", _infoText]];    	
};

//generate all event strings and store from last to first occurance
private _playerIndex = _names find (name player);
private _numEvents = (count _events);
private _eventStrings = [];
for "_i" from (_numEvents - 1) to 0 step -1 do 
{
    private _event = _events select _i;
    private _eventString = ([_event, _names, _sides, _weapons] call DOTT_tracker_fnc_eventToString);
    _eventStrings pushBack _eventString;
};

//find all player relevant events
private _playerEventIndexes = [_playerIndex, _events] call DOTT_tracker_fnc_findPlayerEvents;

//"reverse" numbers so they confirm with _eventStrings indexes
for "_i" from 0 to ((count _playerEventIndexes) - 1) do {
    _playerEventIndexes set [_i, _numEvents - 1 - (_playerEventIndexes select _i)];
};

private _playerEventStrings = [];
for "_i" from (count _playerEventIndexes - 1) to 0 step -1 do 
{
    private _playerEventIndex = _playerEventIndexes select _i;
    _playerEventStrings pushBack (_eventStrings select _playerEventIndex);
};

private _title = format["Round %1 - Personal Events", _roundNum];
private _copyButton = format["<execute expression='[""%1"",""%2""] call DOTT_tracker_fnc_copyRecordToClipboard;'>Copy to Clipboard</execute>", "RoundEventLog", _title];
_playerEventStrings pushBack _copyButton;
private _text = _playerEventStrings joinString "<br />";
player createDiaryRecord ["RoundEventLog", [_title, _text]];

_title = format["Round %1 - All Events", _roundNum];
_copyButton = format["<execute expression='[""%1"",""%2""] call DOTT_tracker_fnc_copyRecordToClipboard;'>Copy to Clipboard</execute>", "RoundEventLog", _title];
_eventStrings pushBack _copyButton;
_text = _eventStrings joinString "<br />";
player createDiaryRecord ["RoundEventLog", [_title, _text]];


if !(player diarySubjectExists "RoundScoreboard") then 
{
    DOTT_tracker_diary_subject = player createDiarySubject ["RoundScoreboard", "Round Scoreboard"];	
    private _infoLines = ["Lists how many infantry kills (no vehicles) each player got during the round, from highest to lowest."];
    _infoLines pushBack "Any players who remain unconscious at the end of the round are credited as kills for the player who incapacitated them.";
    _infoLines pushBack "AI Infantry kills will not be tracked.";    
    _infoLines pushBack "Information is updated at the end of the round and is lost when aborting/disconnecting.";    
    private _infoText = _infoLines joinString "<br />";    
    player createDiaryRecord ["RoundScoreboard", ["Information", _infoText]]; 
};

private _killCounts = [_events, _sides] call DOTT_tracker_fnc_getKillCounts;
_title = format["Round %1", _roundNum];
_text = [_killCounts, _names] call DOTT_tracker_fnc_killCountsToString;
_copyButton = format["<br /><execute expression='[""%1"",""%2""] call DOTT_tracker_fnc_copyRecordToClipboard;'>Copy to Clipboard</execute>", "RoundScoreboard", _title];
_text = _text + _copyButton;
player createDiaryRecord ["RoundScoreboard", [_title, _text]];

DOTT_tracker_last_round_Recorded = _roundNum;

true