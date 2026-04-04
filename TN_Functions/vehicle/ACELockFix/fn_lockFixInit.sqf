#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Workaround for ACE bug where vehicle seats stay locked
 * after unconscious or dead players are moved out via ACE
 * interaction. Hooks into get-in/get-out, unconscious, and
 * killed events to save and restore the locked seat data,
 * then retries the unlock after a short delay.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_vehicle_fnc_lockFixInit;
 */

#define DELAY_UNLOCK(_unit) [FUNC(unlockUnconsciousSeat), _unit, 0.5] call CBA_fnc_waitAndExecute

["CAManBase", "GetInMan", {
    params ["_unit", "", "_vehicle"];

    if (local _vehicle) then {
        [_unit] call FUNC(saveUnconsciousSeat);
    };
}] call CBA_fnc_addClassEventHandler;

["CAManBase", "GetOutMan", {
    params ["_unit", "", "_vehicle"];

    if (local _vehicle) then {
        DELAY_UNLOCK(_unit);
    };
}] call CBA_fnc_addClassEventHandler;

["ace_unconscious", {
    params ["_unit", "_unconscious"];
    if (!isNull objectParent _unit && {local objectParent _unit}) then {
        if (_unconscious) then {
            [_unit] call FUNC(saveUnconsciousSeat);
        } else {
            DELAY_UNLOCK(_unit);
        };
    };
}] call CBA_fnc_addEventHandler;

["ace_killed", { // global event
    params ["_unit"];
    if (!isNull objectParent _unit && {local objectParent _unit}) exitWith {
        DELAY_UNLOCK(_unit);
    };
}] call CBA_fnc_addEventHandler;

nil
