/**
 * Function: TN_tracker_fnc_copyRecordToClipboard
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Copies text from record to clipboard up to and excluding the
 * copy clipboard button. Requires ACE 3.
 *
 * Parameters:
 * _subject (String): Diary subject name (e.g. "RoundEventLog").
 * _title (String): Title of the specific diary record to copy.
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
_recordText call TN_tracker_fnc_copyToClipboard;
systemChat "Copied to clipboard. (HTML format)";

true
