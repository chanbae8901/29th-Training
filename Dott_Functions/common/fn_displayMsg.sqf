/**
 * DOTT_common_fnc_displayMsg
 *
 * Displays titleText messages, typically remoteExec'd for global use.
 * Supports a single format substitution (%1) via _msgVar1.
 *
 * NOTE: Only one format variable (%1) is supported. If you need
 * multiple substitutions, pre-format the string before calling.
 *
 * Parameters:
 *     _msgText   - STRING  - message body with optional HTML markup
 *     _msgEffect - STRING  - title effect (default: "PLAIN")
 *     _msgDur    - NUMBER  - display duration in seconds (default: 0.5)
 *     _msgFormat - BOOL    - true to apply format with _msgVar1
 *                            (default: false)
 *     _msgVar1   - ANY     - value substituted for %1 (default: 0)
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     ["<t color='#ffffff' size='4'>Timer Started!</t><br/>%1 Minute Time Limit", "PLAIN", 0.5, true, timerLength]
 *         remoteExec ["DOTT_common_fnc_displayMsg"];
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
    titleText [
        format [_msgText, _msgVar1],
        _msgEffect, _msgDur, true, true
    ];
}
else
{
    titleText [_msgText, _msgEffect, _msgDur, true, true];
};
