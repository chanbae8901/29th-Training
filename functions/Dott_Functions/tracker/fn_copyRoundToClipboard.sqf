/*
 * Name:	fnc_copyRoundToClipboard
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Copies text from record of certain round to clipboard.
 * REQUIRES ACE 3
 *
 * Parameter(s): 
 * _roundNum (Number): Number of round to copy information of to clipboard.
 *
 * Returns:
 * true
 *
 * Example:
 * [0] call DOTT_tracker_fnc_copyRoundToClipboard;
 * 
 */

params["_roundNum"];

private _allRoundRecords = player allDiaryRecords "RoundEventLog";
private _searchTitle = format["Round %1", _roundNum];
private _idx = _allRoundRecords findIf { _x select 1 == _searchTitle };
private _recordText = (_allRoundRecords select _idx) select 2;
_recordText = _recordText select[0, _recordText find "<execute"];
_recordText call DOTT_tracker_fnc_copyToClipboard;
systemChat "Round copied to clipboard. (HTML format)";

true