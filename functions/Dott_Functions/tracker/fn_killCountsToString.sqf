/*
 * Name:	fnc_killCountsToString
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Converts kill counts array info into string for diary.
 *
 * Parameter(s): 
 * _killCounts (Array): Reference fn_getKillCounts.
 * _names (Array): Name references for event.
 *
 * Returns:
 * Diary appropriate string representing scoreboard of round
 *
 * Example:
 * [_KillCounts, _names] call DOTT_tracker_fnc_killCountsToString;
 * 
 */

params["_killCounts", "_names"];

private _lines = [];

{
	private _unit = _x select 0;
	private _unitIndex = _unit select 0;
	private _unitName = _names select _unitIndex;
	private _unitSide = _unit select 1;
	_unitName = [_unitName, _unitSide] call DOTT_tracker_fnc_colorNameWithSide;

	private _killCount = _x select 1;
	private _line = format["%1 (%2)", _unitName, _killCount];
	_lines pushBack _line;
}
forEach _killCounts;

private _text = _lines joinString "<br />";
_text;