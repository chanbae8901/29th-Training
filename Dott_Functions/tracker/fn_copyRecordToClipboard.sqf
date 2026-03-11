/**
 * File: fn_copyRecordToClipboard.sqf
 * Function: DOTT_tracker_fnc_copyRecordToClipboard
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Copies text from record to clipboard up to and excluding the
 * copy clipboard button. Requires ACE 3.
 *
 * Parameters:
 * _roundNum (Number): Number of round to copy information of
 *     to clipboard.
 *
 * Returns:
 * true
 */

params ["_subject", "_title"];

private _allRoundRecords = player allDiaryRecords _subject;
private _idx =
    _allRoundRecords findIf { _x select 1 == _title };
private _recordText =
    (_allRoundRecords select _idx) select 2;
_recordText =
    _recordText select [0, _recordText find "<execute"];
_recordText call DOTT_tracker_fnc_copyToClipboard;
systemChat "Copied to clipboard. (HTML format)";

true
