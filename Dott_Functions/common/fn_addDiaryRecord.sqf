/**
 * DOTT_common_fnc_addDiaryRecord
 *
 * Wrapper for createDiaryRecord intended to be remoteExec'd.
 * Allows server-side code to add diary entries on client machines.
 *
 * Parameters:
 *     _subject  - STRING - diary subject category
 *     _textInfo - STRING - body text for the diary entry
 *
 * Returns:
 *     Diary Record, or nothing if no interface
 *
 * Example:
 *     ["Something Happened", "Log"]
 *         remoteExec ["addDiaryRecord", 0];
 */

params ["_subject", "_textInfo"];

if (!hasInterface) exitWith {};

player createDiaryRecord [_subject, _textInfo];
