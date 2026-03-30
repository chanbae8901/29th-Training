#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes the thermal restriction module.
 * - Client: monitors vision mode changes to black-screen on
 *   thermal use, and disables PIP thermal cameras on vehicle entry.
 * - Server: disables TI equipment on all current and future
 *   vehicles when the CBA setting is enabled.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_thermals_fnc_init
 */

// --- Client-side: vision mode monitoring and PIP disable ---
if (hasInterface) then {
    ["visionMode", {
        call FUNC(blackScreen);
    }] call CBA_fnc_addPlayerEventHandler;

    [QGVAR(disablePIPThermalsEvent), "GetInMan", {
        if !(GVARMAIN(disableTI)) exitWith {};

        // Brief delay required or PIP cameras won't shut off.
        [{
            call FUNC(disablePIP);
        }, [], 0.1] call CBA_fnc_waitAndExecute;
    }] call CBA_fnc_addBISPlayerEventHandler;
};

// --- Server-side: disable TI on vehicles ---
if (isServer) then {
    ["AllVehicles", "Init", {
        params ["_objectCreated"];
        _objectCreated disableTIEquipment GVARMAIN(disableTI);
    }, true, ["Man"], true] call CBA_fnc_addClassEventHandler;
};

nil
