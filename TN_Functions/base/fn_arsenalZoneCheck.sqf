#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * PFH body that checks if the player is within arsenal
 * zone radius and fires enter/exit CBA events on
 * state transitions.
 *
 * Arguments:
 * PFH args: [radiusSquared]
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [{ call TN_base_fnc_arsenalZoneCheck }, 1, [_radiusSquared]] call CBA_fnc_addPerFrameHandler;
 */

params ["_args", "_handle"];
_args params ["_radiusSquared"];

private _inZone = false;
{
    if ((getPosASL player) distanceSqr _x <= _radiusSquared) exitWith {
        _inZone = true;
    };
} forEach GVAR(arsenalCenters);

if (_inZone) then {
    if !(GVAR(inArsenalZone)) then {
        GVAR(inArsenalZone) = true;
        [QGVAR(enteredArsenalZone)] call CBA_fnc_localEvent;
    };
} else {
    if (GVAR(inArsenalZone)) then {
        GVAR(inArsenalZone) = false;
        [QGVAR(exitedArsenalZone)] call CBA_fnc_localEvent;
    };
};

nil
