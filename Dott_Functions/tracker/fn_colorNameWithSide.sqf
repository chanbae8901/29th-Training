/**
 * File: fn_colorNameWithSide.sqf
 * Function: DOTT_tracker_fnc_colorNameWithSide
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Wraps a name string in an HTML font-color tag matching the
 * given side for diary display.
 *
 * Parameters:
 * _unitName (String): The name to colorize.
 * _side (Side): Side whose color to use.
 *
 * Returns:
 * String -- HTML-wrapped name with side-appropriate color.
 */

params ["_unitName", "_side"];

private _colorString = switch (_side) do
{
    case west:       { "#155DFC" };
    case east:       { "#B40404" };
    case resistance: { "#088A08" };
    default          { "#FFFFFF" };
};

format [
    "<font color='%1'>%2</font>",
    _colorString, _unitName
]
