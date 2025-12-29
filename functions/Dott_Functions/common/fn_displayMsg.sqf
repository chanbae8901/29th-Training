/*
 * Name:	DOTT_common_fnc_displayMsg
 * Date:	2/16/2024
 * Version:	1.0
 * Author:	Dott [29th ID]
 *
 * Description:
 * Displays titleText messages globally
 *
 * Parameter(s):
 * _msgText (string): The message, including formating and markups (E.G. "<t color='#ffffff' size='2'><br/> %1 is dead!</t>")
 * _msgEffect (string): Title effect
 * _msgDur (number): The duration of the message, in seconds
 * _msgFormat (bool): Whether the message requires formatting (%1)
 * _msgVar1 (any): Whatever %1 should be
 *
 * Returns:
 * n/a
 *
 * Example:
 * ["<t color='#ffffff' size='4'>Timer Started!</t><br/>%1 Minute Time Limit","PLAIN",0.5, true, timerLength] remoteExec ["DOTT_common_fnc_displayMsg"];
 * 
 */

params 
[
	["_msgText", "Error: No text defined!", [""]],
	["_msgEffect", "PLAIN", [""]],
	["_msgDur", 0.5, [0]],
	["_msgFormat", false, [false]], 
	["_msgVar1", 0]
];

if (_msgFormat) then
{
	titleText [format [_msgText, _msgVar1], _msgEffect, _msgDur, true, true];
}
else
{
	titleText [_msgText, _msgEffect, _msgDur, true, true];
};