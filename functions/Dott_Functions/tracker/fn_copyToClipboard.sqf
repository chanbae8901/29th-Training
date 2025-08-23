/*
 * Name:	fnc_copyToClipboard
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Helper function that copies to clipboard since vanilla function does not work in MP.
 * REQUIRES ACE 3
 *
 * Parameter(s): 
 * _str (String): string to copy to clipboard
 *
 * Returns:
 * true
 *
 * Example:
 * ["hello there"] call DOTT_tracker_fnc_copyToClipboard;
 * 
 */
params["_str"];
"ace" callExtension ["clipboard:append", [_str]]; 
"ace" callExtension ["clipboard:complete", []];
true