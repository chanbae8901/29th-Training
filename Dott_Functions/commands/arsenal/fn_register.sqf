/**
 * DOTT_commands_fnc_arsenalRegister
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

if (isNil "DOTT_cmd_arsenalObjects") then {
    DOTT_cmd_arsenalObjects = [];

    ["DOTT_round_started", {
        {
            deleteVehicle _x;
        } forEach DOTT_cmd_arsenalObjects;
        DOTT_cmd_arsenalObjects = [];
    }] call CBA_fnc_addEventHandler;
};

DOTT_cmd_arsenalObjects pushBack _arsenal;

[[_arsenal]] call DOTT_curator_fnc_addEditable;
