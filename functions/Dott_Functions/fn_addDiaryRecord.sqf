/*
 * Name:	DOTT_fnc_addDiaryRecord
 * Date:	8/21/2025
 * Version:	1.0
 * Author:	Bae [29th ID]
 *
 * Description:
 * Helper/wrapper function for createDiaryRecord intended to be remoteExec'd. 
 *
 * Parameter(s):
 *  _subject (String): Name of subject to add record.
 *	_textInfo (String): String to add to record.
 *
 * Returns:
 * Diary Record
 *
 * Example:
 * ["Something Happened", "Log"] remoteExec ["addDiaryRecord", 0];
 * 
 */
 
params["_subject", "_textInfo"];
if (!hasInterface) exitWith {};

player createDiaryRecord [_subject, _textInfo];