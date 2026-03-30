#include "script_component.hpp"
/*
 * Author: Bae [29th ID], modified from OCAP Addon
 * Registers a player unit with the OCAP recording system by
 * assigning an ID, sending unit data to the extension, and
 * attaching event handlers. Skips if a recording is already
 * running (the capture loop handles it instead).
 *
 * Arguments:
 * 0: Player unit to initialize <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [player] remoteExecCall ["TN_ocap_fnc_initializePlayer", 2];
 */

//Modified version from OCAP 2 Addon tweaked for this mission

#define BOOL(_cond) (parseNumber (_cond))

//if recording, let natural loop do below instead
if (GVAR(recording)) exitWith {};

params ["_player"];

if !(_player getVariable ["ocap_isInitialized", false]) then {
    _player setVariable ["ocap_id", ocap_recorder_nextId];

    private _newUnit = [
        ocap_recorder_captureFrameNo, //1
        ocap_recorder_nextId, //2
        name _player, //3
        groupID (group _player), //4
        str side group _player, //5
        BOOL(isPlayer _player), //6
        roleDescription _player, // 7
        typeOf _player, // 8 classname
        [configOf _player] call BIS_fnc_displayName, // 9 type displayname
        ["", getPlayerUID _player] select (isPlayer _player), // 10 player uid
        [squadParams _player] call CBA_fnc_encodeJSON // 11 squad params
    ];
    _player setVariable ["ocap_newUnitData", _newUnit];

    [
        {missionNamespace getVariable ["ocap_extension_sessionReady", false]},
        {[":SOLDIER:CREATE:", _this] call ocap_extension_fnc_sendData;},
        _newUnit,
        30
    ] call CBA_fnc_waitUntilAndExecute;

    [_player] spawn ocap_recorder_addUnitEventHandlers;

    ocap_recorder_nextId = ocap_recorder_nextId + 1;

    _player setVariable ["ocap_isInitialized", true, true];
};

nil
