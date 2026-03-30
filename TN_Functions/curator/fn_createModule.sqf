#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Creates a curator (Zeus) module for the specified
 * player if their variable name is listed in
 * TN_curator_units. If a module already exists for
 * that player, unassigns and reassigns.
 * Must be called in an unscheduled environment so the
 * init of the module is called in the same frame. If called before
 * mission time > 0, defers via
 * CBA_fnc_waitUntilAndExecute. If called on a client
 * it forwards to the server.
 *
 * Arguments:
 * 0: Variable name of the player unit (from mission.sqm) <STRING>
 *
 * Return Value:
 * The created curator logic, or nothing if the player is not in TN_curator_units <OBJECT>
 *
 * Example:
 * [vehicleVarName player] call TN_curator_fnc_createModule;
 */

params ["_playerVarName"];

// Need to wait until after start to create modules.
if (time isEqualTo 0) exitWith {
    [
        { time > 0 },
        { call FUNC(createModule) },
        _this
    ] call CBA_fnc_waitUntilAndExecute;
};

_playerVarName = toLowerANSI _playerVarName;

if !(_playerVarName in GVAR(units)) exitWith {};

if !(isServer) exitWith {
    _this remoteExecCall [
        QFUNC(createModule), 2
    ];
};

private _curatorModuleName = format [
    QGVAR(zeus_%1), _playerVarName
];

if !(isNil _curatorModuleName) exitWith {
    private _player = missionNamespace getVariable [_playerVarName, objNull];
    private _module = missionNamespace getVariable _curatorModuleName;
    unassignCurator _module;
    [{(_this select 0) assignCurator (_this select 1)},
        [_player, _module], 0.1] call CBA_fnc_waitAndExecute;
};

private _group = createGroup [sideLogic, true];
private _logic = _group createUnit [
    "ModuleCurator_F", [0, 0, 0], [], 0, "NONE"
];

missionNamespace setVariable [_curatorModuleName, _logic];
_logic setVariable ["owner", _playerVarName, true];
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
