/*
 * Name:	fnc_colorNameWithSide
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Helper function to return side colorized version of string for diary.
 *
 * Parameter(s): 
 * _unitName (String): string to colorize with side
 * _side (Side): Side to color with
 *
 * Returns:
 * _unitName string wrapped with _side appropriate font color
 *
 * Example:
 * ["Maj. Major", west] call DOTT_tracker_fnc_colorNameWithSide;
 * 
 */
params["_unitName" , "_side"];

private _colorString = switch (_side) do {
	case west:      { "#155DFC" };
	case east:       { "#B40404" };
	case resistance: { "#088A08" };
	default             { "#FFFFFF" };
};

format ["<font color='%1'>%2</font>", _colorString, _unitName]