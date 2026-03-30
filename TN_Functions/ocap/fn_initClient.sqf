#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Client-side OCAP initialization.
 * Handles JIP player registration.
 *
 * Arguments:
 * 0: Whether OCAP autoStart is enabled <BOOL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [false] remoteExecCall ["TN_ocap_fnc_initClient", 0, true];
 */

params ["_autoStart"];

if !(hasInterface) exitWith {};

//do OCAP initalization on players outside of capture loop so we can save proper marker info
if !(_autoStart) then {
    [{!isNull player}, {
        [player] remoteExecCall
            [QFUNC(initializePlayer), 2];
    }] call CBA_fnc_waitUntilAndExecute;
};

nil
