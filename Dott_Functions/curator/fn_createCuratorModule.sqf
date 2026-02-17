params ["_playerVarName", "_roleDescription"];

if (time == 0) exitWith
{
    [{time > 0}, {_this call DOTT_curator_fnc_createCuratorModule}, _this] call CBA_fnc_waitUntilAndExecute;
};

_playerVarName = toLower _playerVarName;

if (DOTT_curator_units find _playerVarName == -1) exitWith {};

if !(isServer) exitWith {_this remoteExec ["DOTT_curator_fnc_createCuratorModule", 2]};

private _curatorModuleName = format ["DOTT_curator_zeus_%1", _playerVarName];

if !(isNil _curatorModuleName) then 
{
    deleteVehicle (missionNamespace getVariable _curatorModuleName);
    missionNamespace setVariable [_curatorModuleName, nil];
};

private _group = createGroup [sideLogic, true];
private _logic = _group createUnit ["ModuleCurator_F", [0, 0, 0], [], 0, "NONE"];
missionNamespace setVariable [_curatorModuleName, _logic];
_logic setVariable ["owner", _playerVarName, true];
_logic setVariable ["name", _roleDescription, true];
_logic setVariable ["Addons", 3, true];
_logic setVariable ["BIS_fnc_initModules_disableAutoActivation", false];
_logic setVariable ["isCuratorExcluded", true, false];

_logic addCuratorEditableObjects [allPlayers, true];

// -2 = NV, -1 = normal, 3rd number is TI see https://community.bistudio.com/wiki/setCamUseTi
[_logic, [-1, -2, 0]] call BIS_fnc_setCuratorVisionModes; 

_logic