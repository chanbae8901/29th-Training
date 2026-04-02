#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Registers an arsenal object on the server for curator
 * editing and auto-deletion when the round starts.
 * Initializes tracking and the round-start cleanup handler
 * on first call.
 *
 * Arguments:
 * 0: The arsenal object to register <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * N/A
 */

params ["_arsenal"];

if (isNil QGVAR(arsenalObjects)) then {
    GVAR(arsenalObjects) = [];

    [QEGVAR(round,started), {
        {
            deleteVehicle _x;
        } forEach GVAR(arsenalObjects);
        GVAR(arsenalObjects) = [];
    }] call CBA_fnc_addEventHandler;
};

GVAR(arsenalObjects) pushBack _arsenal;

if (USING_MODULE(curator)) then {
    [[_arsenal]] call EFUNC(curator,addEditable);
};

nil
