#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Returns the display name for a unit. For infantry, uses the
 * player name (falling back to cached TN_tracker_name if dead). For
 * vehicles, uses the config display name.
 *
 * Arguments:
 * 0: Player or vehicle to get the name of <OBJECT>
 *
 * Return Value:
 * The unit's display name, or "?" if null <STRING>
 */

params ["_unit"];

// Placeholder for null units (e.g. deleted unit whose
// placed mine still explodes).
private _name = "?";
if (isNull _unit) exitWith { _name };

if (_unit isKindOf "Man") then {
    if (alive _unit) then {
        _name = name _unit;
    } else {
        _name = _unit getVariable [QGVAR(name), "?"];
    };
} else {
    _name = getText (
        configOf _unit >> "displayName"
    );
    if (_name isEqualTo "") then { _name = "Vehicle" };
};

_name
