/**
 * File: fn_copyToClipboard.sqf
 * Function: DOTT_tracker_fnc_copyToClipboard
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Copies a string to the system clipboard using ACE's extension
 * API. Vanilla copyToClipboard does not work in multiplayer,
 * so this is the workaround.
 * Requires ACE 3.
 *
 * Parameters:
 * _str (String): Text to copy to clipboard.
 *
 * Returns:
 * true
 */

params ["_str"];

"ace" callExtension ["clipboard:append", [_str]];
"ace" callExtension ["clipboard:complete", []];

true
