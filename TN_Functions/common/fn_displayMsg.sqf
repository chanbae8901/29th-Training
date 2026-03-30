#include "script_component.hpp"
/*
 * Author: Dott [29th ID]
 * Displays titleText messages, typically remoteExec'd for global use.
 * Supports a single format substitution (%1) via _msgVar1.
 * NOTE: Only one format variable (%1) is supported. If you need
 * multiple substitutions, pre-format the string before calling.
 *
 * Arguments:
 * 0: Message body with optional HTML markup <STRING>
 * 1: Title effect <STRING> (default: "PLAIN")
 * 2: Display duration in seconds <NUMBER> (default: 0.5)
 * 3: True to apply format with _msgVar1 <BOOL> (default: false)
 * 4: Value substituted for %1 <ANY> (default: 0)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * ["<t color='#ffffff' size='4'>Timer Started!</t><br/>%1 Minute Time Limit", "PLAIN", 0.5, true, timerLength] remoteExec ["TN_common_fnc_displayMsg"];
 */

params
[
    ["_msgText", "Error: No text defined!", [""]],
    ["_msgEffect", "PLAIN", [""]],
    ["_msgDur", 0.5, [0]],
    ["_msgFormat", false, [false]],
    ["_msgVar1", 0]
];

if (_msgFormat) then {
    titleText [
        format [_msgText, _msgVar1],
        _msgEffect, _msgDur, true, true
    ];
} else {
    titleText [_msgText, _msgEffect, _msgDur, true, true];
};

nil
