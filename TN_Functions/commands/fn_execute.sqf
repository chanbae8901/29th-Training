#include "script_component.hpp"
#include "..\..\data\roundState.hpp"

/*
 * Author: Bae [29th ID]
 * Parses and executes a chat command from the intercepted
 * chat text string. Strips the leading command marker,
 * splits on the first space into command name and
 * argument, then looks up and runs the matching handler.
 * Enforces removed/admin/restricted command restrictions
 * before execution. Logs usage to diary and server unless
 * the command is in the no-log list.
 *
 * Arguments:
 * 0: Chat text from the KeyDown handler <STRING>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * N/A
 */

params [["_text", "", [""]]];

// Strip leading command marker
_text = _text select [1, count _text - 1];

private _spaceIdx = _text find " ";
private ["_command", "_argument"];

if (_spaceIdx isEqualTo -1) then {
    _command = toLower _text;
    _argument = "";
} else {
    _command = toLower (_text select [0, _spaceIdx]);
    _argument = _text select [_spaceIdx + 1, count _text - _spaceIdx - 1];
};

private _commandCode = GVAR(allCommands) get _command;

if !(isNil "_commandCode") then {
    if (_command in GVAR(removedCommands)) exitWith {
        systemChat "Command has been disabled by server!";
    };

    private _isAdmin = serverCommandAvailable "#lock";

    if (_command in GVAR(adminCommands) && !_isAdmin) exitWith {
        systemChat "You must be the logged in admin to do that!";
    };

    if (_command in GVAR(restrictedCommands) && !_isAdmin && ROUND_LIVE) exitWith {
        systemChat "Restricted command! Round has started and you are not admin.";
    };

    [_argument] call _commandCode;

    if !(_command in GVAR(noLogCommands)) then {
        private _msg = format ["%1 executed command !%2 %3", name player, _command, _argument];
        _msg remoteExecCall [QEFUNC(common,diag_log), 2];
        ["Log", ["Commands", _msg]] remoteExecCall [QEFUNC(common,addDiaryRecord)];
        if (clientOwner isNotEqualTo EGVAR(common,adminClient)) then {
             _msg call EFUNC(common,notifyAdmin) 
        };
    };
} else {
    systemChat format ["Unknown command: !%1", _command];
};

nil
