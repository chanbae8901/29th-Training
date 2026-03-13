/*
 * Function: DOTT_commands_fnc_execute
 * Author:   Conroy, Bae [29th ID]
 *
 * Description:
 *     Parses and executes a chat command from the intercepted
 *     character array. Strips the leading command marker,
 *     splits on the first space into command name and
 *     argument, then looks up and runs the matching handler.
 *     Enforces removed/admin/restricted command restrictions
 *     before execution. Logs usage to diary and server unless
 *     the command is in the no-log list.
 *
 *     WARNING: The array manipulation below (set to -1, then
 *     subtract [-1]) is the original approach for stripping
 *     the leading character. It works but is fragile -- do
 *     not refactor without thorough testing.
 *
 * Parameters:
 *     _this - Array - Raw chat character array from the
 *         HandleChatMessage event handler
 *
 * Returns:
 *     Nothing
 */

private [
    "_chatArr", "_separator", "_commandDone",
    "_command", "_argument"
];

//can check local player here, executed via eventhandlers for keystrokes of either enter key

_chatArr = [_this, 0, []] call BIS_fnc_param;

// Remove leading intercept character
_chatArr set [0, -1];
_chatArr = _chatArr - [-1];

_separator = (toArray " ") select 0;
_commandDone = false;
_command = [];
_argument = [];

{
    if (_x == _separator && !_commandDone) then
    {
        _commandDone = true;
    }
    else
    {
        if (!_commandDone) then
        {
            _command set [count _command, _x];
        }
        else
        {
            _argument set [count _argument, _x];
        };
    };
} forEach _chatArr;

_command = toLower (toString _command);
_argument = toString _argument;

private _commandCode = pvpfw_chatIntercept_allCommands get _command;

if !(isNil "_commandCode") then
{
    if (pvpfw_chatIntercept_removedCommands find _command != -1) exitWith
    {
        systemChat "Command has been disabled by server!";
    };

    private _isAdmin = serverCommandAvailable "#lock";

    if (pvpfw_chatIntercept_adminCommands find _command != -1 && !_isAdmin) exitWith
    {
        systemChat "You must be the logged in admin to do that!";
    };

    if (pvpfw_chatIntercept_restrictedCommands find _command != -1 && !_isAdmin && (call DOTT_round_fnc_isRoundActive)) exitWith
    {
        systemChat "Restricted command! Round has started and you are not admin.";
    };

    [_argument] call _commandCode;

    if (pvpfw_chatIntercept_noLogCommands find _command == -1) then
    {
        private _msg = format ["%1 executed command !%2 %3", name player, _command, _argument];
        _msg remoteExec ["DOTT_common_fnc_diag_log", 2];
        ["Log", ["Commands", _msg]] remoteExec ["DOTT_common_fnc_addDiaryRecord"];
    };
}
else
{
    systemChat format ["Unknown command: !%1", _command];
};
