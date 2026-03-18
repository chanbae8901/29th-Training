/*
 * Author: Bae [29th ID]
 * Creates an ACE arsenal box at a given position and
 * registers it on the server for curator editing and
 * auto-deletion when the round starts.
 *
 * Arguments:
 * 0: Position ATL to create the arsenal at <ARRAY>
 * 1: Direction in degrees for offset <NUMBER> (default: 0)
 * 2: Distance in meters to offset from pos in direction dir <NUMBER> (default: 0)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [getPosATL player, getDir player, 3] call TN_commands_fnc_arsenalCreate;
 */

params ["_pos", ["_dir", 0, [0]], ["_offset", 0, [0]]];

private _posZ = _pos select 2;

if (_offset > 0) then {
    _pos = _pos getPos [_offset, _dir];
    _pos set [2, _posZ];
};

private _arsenalArr = [
    "Land_ToiletBox_F",
    "Land_FieldToilet_F"
];

private _arsenal = createVehicle [selectRandom _arsenalArr, _pos, [], 5, "NONE"];
_arsenal enableSimulationGlobal false;

[_arsenal, true] call ace_arsenal_fnc_initBox;

[_arsenal] remoteExecCall ["TN_commands_fnc_arsenalRegister", 2];
