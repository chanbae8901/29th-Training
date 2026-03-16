/**
 * Function: TN_commands_fnc_arsenalRegister
 * Author:   Bae [29th ID]
 *
 * Registers an arsenal object on the server for curator
 * editing and auto-deletion when the round starts.
 * Initializes tracking and the round-start cleanup handler
 * on first call.
 *
 * Parameters:
 *     _arsenal - Object - The arsenal object to register
 *
 * Returns:
 *     Nothing
 */

params ["_arsenal"];

if (isNil "TN_cmd_arsenalObjects") then {
    TN_cmd_arsenalObjects = [];

    ["TN_round_started", {
        {
            deleteVehicle _x;
        } forEach TN_cmd_arsenalObjects;
        TN_cmd_arsenalObjects = [];
    }] call CBA_fnc_addEventHandler;
};

TN_cmd_arsenalObjects pushBack _arsenal;

[[_arsenal]] call TN_curator_fnc_addEditable;
