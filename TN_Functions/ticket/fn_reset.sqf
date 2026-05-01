#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Resets all ticket counts and starting counts to zero.
 * Optionally enables or disables the ticket system.
 *
 * Arguments:
 * 0: Enable or disable the system (optional) <BOOL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_ticket_fnc_reset;
 * [true] call TN_ticket_fnc_reset;
 * [false] call TN_ticket_fnc_reset;
 */

params [["_enabled", nil, [true]]];

GVAR(counts) = [0, 0, 0];
GVAR(startingCounts) = [0, 0, 0];
publicVariable QGVAR(counts);
publicVariable QGVAR(startingCounts);

if (!isNil "_enabled") then {
    GVAR(enabled) = _enabled;
    publicVariable QGVAR(enabled);
};

nil
