/*
 * Author: Bae [29th ID]
 * Copies a string to the system clipboard using ACE's extension
 * API. Vanilla copyToClipboard does not work in multiplayer,
 * so this is the workaround.
 * Requires ACE 3.
 *
 * Arguments:
 * 0: Text to copy to clipboard <STRING>
 *
 * Return Value:
 * Nothing
 */

params ["_str"];

"ace" callExtension ["clipboard:append", [_str]];
"ace" callExtension ["clipboard:complete", []];

nil
