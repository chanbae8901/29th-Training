#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Wraps a name string in an HTML font-color tag matching the
 * given side for diary display.
 *
 * Arguments:
 * 0: The name to colorize <STRING>
 * 1: Side whose color to use <SIDE>
 *
 * Return Value:
 * HTML-wrapped name with side-appropriate color <STRING>
 */

params ["_unitName", "_side"];

private _colorString = switch (_side) do {
    case west:       { "#155DFC" };
    case east:       { "#B40404" };
    case resistance: { "#088A08" };
    default          { "#FFFFFF" };
};

format [
    "<font color='%1'>%2</font>",
    _colorString, _unitName
]
