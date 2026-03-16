/**
 * Function: TN_tracker_fnc_killCountsToString
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Converts a sorted kill-counts array into an HTML string
 * for the scoreboard diary entry.
 *
 * Parameters:
 * _killCounts (Array): From fn_getKillCounts. Elements are
 *     [[unitIndex, unitSide], numKills].
 * _names (Array): Name reference table.
 *
 * Returns:
 * String -- HTML-formatted scoreboard text.
 */

params ["_killCounts", "_names"];

private _lines = [];

{
    private _unit = _x select 0;
    private _unitIndex = _unit select 0;
    private _unitName = _names select _unitIndex;
    private _unitSide = _unit select 1;
    _unitName = [_unitName, _unitSide]
        call TN_tracker_fnc_colorNameWithSide;

    private _killCount = _x select 1;
    private _line =
        format ["%1 (%2)", _unitName, _killCount];
    _lines pushBack _line;
}
forEach _killCounts;

private _text = _lines joinString "<br />";

_text
