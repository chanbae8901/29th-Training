/*
 * Author: Bae [29th ID]
 * Wrapper for createDiaryRecord intended to be remoteExec'd.
 * Allows server-side code to add diary entries on client machines.
 *
 * Arguments:
 * 0: Diary subject category <STRING>
 * 1: Body text for the diary entry <STRING>
 *
 * Return Value:
 * Diary Record, or nothing if no interface <DIARY_RECORD>
 *
 * Example:
 * ["Log", "Something Happened"] remoteExec ["TN_common_fnc_addDiaryRecord", 0];
 */

params ["_subject", "_textInfo"];

if (!hasInterface) exitWith {};

player createDiaryRecord [_subject, _textInfo];
