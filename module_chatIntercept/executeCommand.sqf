private ["_chatArr","_seperator","_commandDone","_command","_argument"];

//can check local player here, executed via eventhandlers for keystrokes of either enter key

_chatArr = [_this,0,[]] call BIS_fnc_param;

// Remove leading intercept character
_chatArr set [0,-1];
_chatArr = _chatArr - [-1];

_seperator = (toArray " ") select 0;
_commandDone = false;
_command = [];
_argument = [];

{
	if (_x == _seperator && !_commandDone)then{
		_commandDone = true;
	}else{
		if (!_commandDone) then{
			_command set[count _command,_x];
		}else{
			_argument set[count _argument,_x];
		};
	};
}forEach _chatArr;

_command = toString _command;
_argument = toString _argument;

private _foundCommand = false;

{
	if (_command == (_x select 0)) exitWith 
	{
		_foundCommand = true;

		private _isAdmin = serverCommandAvailable "#lock";
		if (pvpfw_chatIntercept_adminCommands find _command != -1 && !_isAdmin) exitWith 
		{
			systemChat "You must be the logged in admin to do that!";
		};

		if (pvpfw_chatIntercept_restrictedCommands find _command != -1 && !_isAdmin && (call DOTT_round_fnc_isRoundActive)) exitWith 
		{
			systemChat "Restricted command! Round has started and you are not admin.";
		};

		[_argument] call (_x select 1);
		if (pvpfw_chatIntercept_noLogCommands find _command == -1) then 
		{
			private _msg = format ["%1 executed command !%2 %3", name player, _command, _argument];
			_msg remoteExec ["DOTT_common_fnc_diag_log",2];
			["Log", ["Commands", _msg]] remoteExec ["DOTT_common_fnc_addDiaryRecord"];
		};		
	};
} forEach pvpfw_chatIntercept_allCommands;

if !(_foundCommand) then {
	systemChat format ["Unknown command: !%1", _command];
};

