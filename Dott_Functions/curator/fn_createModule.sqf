/*
 * Function: TN_curator_fnc_createModule
 * Author:   Bae [29th ID]
 *
 * Description:
 *     Creates a curator (Zeus) module for the specified
 *     player if their variable name is listed in
 *     TN_curator_units. Deletes any existing module for
 *     that player first to avoid duplicates. Must be called
 *     in an unscheduled environment so the module is created
 *     atomically. If called before mission time > 0, defers
 *     via CBA_fnc_waitUntilAndExecute. If called on a client
 *     it forwards to the server.
 *
 * Parameters:
 *     _playerVarName  - String - Variable name of the player
 *         unit (from mission.sqm)
 *     _roleDescription - String - Role description shown in
 *         the Zeus interface
 *
 * Returns:
 *     Object - The created curator logic, or nothing if
 *         the player is not in TN_curator_units
 *
 * Example:
 *     [vehicleVarName player, roleDescription player]
 *         call TN_curator_fnc_createModule;
 */

params ["_playerVarName", "_roleDescription"];

// Need to wait until after start to create modules.
if (time == 0) exitWith
{
    [
        { time > 0 },
        { _this call TN_curator_fnc_createModule },
        _this
    ] call CBA_fnc_waitUntilAndExecute;
};

_playerVarName = toLower _playerVarName;

if (TN_curator_units find _playerVarName == -1) exitWith {};

if !(isServer) exitWith
{
    _this remoteExecCall [
        "TN_curator_fnc_createModule", 2
    ];
};

private _curatorModuleName = format [
    "TN_curator_zeus_%1", _playerVarName
];

if !(isNil _curatorModuleName) then
{
    deleteVehicle (
        missionNamespace getVariable _curatorModuleName
    );
    missionNamespace setVariable [_curatorModuleName, nil];
};

private _group = createGroup [sideLogic, true];
private _logic = _group createUnit [
    "ModuleCurator_F", [0, 0, 0], [], 0, "NONE"
];

missionNamespace setVariable [_curatorModuleName, _logic];
_logic setVariable ["owner", _playerVarName, true];
_logic setVariable ["name", _roleDescription, true];
_logic setVariable ["Addons", 3, true];
_logic setVariable [
    "BIS_fnc_initModules_disableAutoActivation", false
];

// Flag so the exclusion loop skips this module itself.
_logic setVariable ["isCuratorExcluded", true, false];

_logic addCuratorEditableObjects [allPlayers, true];

// -2 = NV, -1 = normal, 3rd number is TI see https://community.bistudio.com/wiki/setCamUseTi
[_logic, [-1, -2, 0]] call BIS_fnc_setCuratorVisionModes;

_logic
