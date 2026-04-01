#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Copies text from record to clipboard up to and excluding the
 * copy clipboard button. Requires ACE 3.
 *
 * Arguments:
 * 0: Diary subject name (e.g. "RoundEventLog") <STRING>
 * 1: Title of the specific diary record to copy <STRING>
 *
 * Return Value:
 * Nothing
 */

params ["_subject", "_title"];

private _allRoundRecords = player allDiaryRecords _subject;
private _idx = _allRoundRecords findIf { _x select 1 isEqualTo _title };
private _recordText = (_allRoundRecords select _idx) select 2;
_recordText = _recordText select [0, _recordText find "<execute"];
_recordText call FUNC(copyToClipboard);
systemChat "Copied to clipboard. (HTML format)";

nil
