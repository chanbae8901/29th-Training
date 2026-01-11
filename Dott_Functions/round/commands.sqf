[
	[
		[
			"timer",
			{
				_argument = _this select 0;
				private _minutes = abs (parsenumber _argument);
				[_minutes * 60] call DOTT_round_fnc_setTimer; 
				systemChat format["Timer set for %1 Minutes", _minutes];
			}
		],
		[
			"live",
			{
				if ([] call DOTT_round_fnc_start) then 
				{
					systemChat "Starting Round!";
				} else
				{
					systemChat "Error: Timer already running!";
				};
			}
		],
		[
			"quicktimer",
			{
				_argument = _this select 0;
				private _timerQuick = abs (parsenumber _argument);
				if ([((_timerQuick) * 60)] call DOTT_round_fnc_start) then
				{
					systemChat format["Starting %1 Minute round!",_timerQuick];				
				} else 
				{
					systemChat "Error: Timer already running! Use '!addtime' if you want to add time";
				};
			}
		],
		[
			"addtime",
			{
				_argument = _this select 0;
				private _timeAdd = parsenumber _argument;
				if ([_timeAdd*60] call DOTT_round_fnc_addTime != -1) then 
				{
					systemChat format["Adding %1 Minutes to the time limit!",_timeAdd];
				}
				else
				{
					systemChat "Error: No active timer! Use '!quicktimer' if you want to start a timer quickly";
				};
			}
		],
		[
			"game",
			{
				if !(call DOTT_round_fnc_isRoundActive) then
				{
					["<t color='#ffffff' size='5'>GAME!</t>","PLAIN",0.4] remoteExec ["DOTT_common_fnc_displayMsg"];
					systemChat "No timer running! Only displaying end game message!";
				} else 
				{
					[true] call DOTT_round_fnc_end; 
					systemChat "Calling Game!";
				};
			}
		],
		[
			"overtime",
			{
				_argument = _this select 0;
				private _minutes = abs (parsenumber _argument); //overtime can't be negative!
				if (_minutes > 0) then 
				{
					[true] call DOTT_round_fnc_setOvertimeEnabled;
					[_minutes*60] call DOTT_round_fnc_setOverTimePeriod;
					systemChat format["Overtime set for %1 Minutes", _minutes];
				}
				else 
				{
					[false] call DOTT_round_fnc_setOvertimeEnabled;
					systemChat "Overtime Disabled";
				};
			}
		],
		[
			"ready",
			{	//works based off of local player's side
				private _result = [playerSide, true] call DOTT_round_fnc_manageReady;
				switch (_result) do {
					case 0: { systemChat "Setting side ready!"; };
					case 1: { systemChat "Error: Round already started!"; };
					case 2: { systemChat "Error: Side is already ready!"; };				
				};
			}
		],
		[
			"unready",
			{
				private _result = [playerSide, false] call DOTT_round_fnc_manageReady;
				switch (_result) do {
					case 0: { systemChat "Setting side unready!"; };
					case 1: { systemChat "Error: Round already started!"; };
					case 2: { systemChat "Error: Side is already unready!"; };				
				};
			}
		]
	],
	[
		["timer", "Sets countdown timer length, specified in minutes (E.G. '!timer 20' sets the timer length to 20 minutes)"],
		["live", "Starts a countdown timer, specified by !timer"],
		["addtime", "Adds time to the current timer, specified in minutes (negative values subtract)"],
		["quicktimer", "Starts a countdown timer, specified in minutes (E.G. '!quicktimer 20' creates a 20 minute timer)"],
		["overtime", "Creates an overtime period that occurs when the timer ends, a value of 0 disables overtime. Overtime must be reapplied for each timer"],
		["game", "Calls game and ends any countdown"],
		["ready", "Sets the player's side as ready, and begins the safe start if all player sides are ready"],
		["unready", "Cancels the ready status for the player's side"]
	]
] call DOTT_commands_fnc_addModule;