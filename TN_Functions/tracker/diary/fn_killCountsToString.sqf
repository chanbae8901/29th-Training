#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Converts a sorted kill-counts array into an HTML string
 * for the scoreboard diary entry.
 *
 * Arguments:
 * 0: From fn_getKillCounts, elements are [[unitIndex, unitSide], numKills] <ARRAY>
 * 1: Name reference table <ARRAY>
 *
 * Return Value:
 * HTML-formatted scoreboard text <STRING>
 */

params ["_killCounts", "_names"];

private _lines = [];

{
    _x params ["_unit", "_killCount"];
    _unit params ["_unitIndex", "_unitSide"];
    private _unitName = _names select _unitIndex;
    _unitName = [_unitName, _unitSide] call FUNC(colorNameWithSide);
    private _line = format ["%1 (%2)", _unitName, _killCount];
    _lines pushBack _line;
}
forEach _killCounts;

private _text = _lines joinString "<br/>";

_text
