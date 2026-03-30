#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Converts between side values and display name strings.
 * Accepts either direction, case-insensitive for string input.
 *
 * Arguments:
 * 0: Side value or side name string <SIDE|STRING>
 *
 * Return Value:
 * If given a string: the SQF side, or sideUnknown if not recognized <SIDE>
 * If given a side: display name, or "Unknown" if not recognized <STRING>
 *
 * Example:
 * ["blufor"] call TN_common_fnc_convertSide;
 * // => west
 * [west] call TN_common_fnc_convertSide;
 * // => "BLUFOR"
 */

params ["_input"];

if (_input isEqualType "") then {
    GVAR(strToSideMap) getOrDefault [toLower _input, sideUnknown]
} else {
    GVAR(sideToStrMap) getOrDefault [_input, "Unknown"]
}
