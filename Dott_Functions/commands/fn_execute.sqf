/*
 * Function: TN_commands_fnc_execute
 * Author:   Bae [29th ID]
 *
 * Description:
 *     Parses and executes a chat command from the intercepted
 *     chat text string. Strips the leading command marker,
 *     splits on the first space into command name and
 *     argument, then looks up and runs the matching handler.
 *     Enforces removed/admin/restricted command restrictions
 *     before execution. Logs usage to diary and server unless
 *     the command is in the no-log list.
 *
 * Parameters:
 *     _this - String - Chat text from the KeyDown handler
 *
 * Returns:
 *     Nothing
 */

private _text = [_this, 0, ""] call BIS_fnc_param;

// Strip leading command marker
_text = _text select [1, count _text - 1];

private _spaceIdx = _text find " ";
private ["_command", "_argument"];

if (_spaceIdx == -1) then {
    _command = toLower _text;
    _argument = "";
} else {
    _command = toLower (_text select [0, _spaceIdx]);
    _argument = _text select [_spaceIdx + 1, count _text - _spaceIdx - 1];
};

private _commandCode = TN_commands_allCommands get _command;

if !(isNil "_commandCode") then
{
    if (TN_commands_removedCommands find _command != -1) exitWith
    {
        systemChat "Command has been disabled by server!";
    };

    private _isAdmin = serverCommandAvailable "#lock";

    if (TN_commands_adminCommands find _command != -1 && !_isAdmin) exitWith
    {
        systemChat "You must be the logged in admin to do that!";
    };

    if (TN_commands_restrictedCommands find _command != -1 && !_isAdmin && (call TN_round_fnc_isRoundActive)) exitWith
    {
        systemChat "Restricted command! Round has started and you are not admin.";
    };

    [_argument] call _commandCode;

    if (TN_commands_noLogCommands find _command == -1) then
    {
        private _msg = format ["%1 executed command !%2 %3", name player, _command, _argument];
        _msg remoteExecCall ["TN_common_fnc_diag_log", 2];
        ["Log", ["Commands", _msg]] remoteExecCall ["TN_common_fnc_addDiaryRecord"];
    };
}
else
{
    systemChat format ["Unknown command: !%1", _command];
};
