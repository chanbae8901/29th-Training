// Code base by conroy - Actions by Dott [29th ID]
// Help section (line 24) gives a general guide of what each command does - Dott
// By default case sensitivity doesn't matter for commands in chat, but does for arguments that follow
// E.G. !commands, !COMMANDS, and !CoMmAnDs will all work, but '!help !COMMANDS' will not (unless argument is 'toLower' before hand is the command code)
// systemChat is the best way to give feedback to the local player executing commands

pvpfw_chatIntercept_noLogCommands = ["commands", "help", "showchat", "radiocheck"];
//remember to change !help if you edit this
pvpfw_chatIntercept_adminCommands = ["reset", "debrief", "goto", "measure", "tickets", "parade", "s", "settings"];
//admin only IF mid-round, available otherwise
pvpfw_chatIntercept_restrictedCommands = ["arsenal", "heal", "rearm", "cleanup"];


pvpfw_chatIntercept_allCommands = [
	[
		"commands",
		{
			_commands = "";
			{
				_commands = _commands + (pvpfw_chatIntercept_commandMarker + (_x select 0)) + ", ";
			}forEach pvpfw_chatIntercept_allCommands;
			systemChat format["Available Commands: %1",_commands];
			systemChat "Use !help followed by the command name to see how to use it";
		}
	],
	[
		"help",
		{
			_argument = _this select 0;
			_argument = toLower _argument;
			switch (_argument) do
			{
				case "!help": {systemChat "!help: Gives help on how to use commands"};
				case "!commands": {systemChat "!commands: Lists commands"};
				case "!timer": {systemChat "!timer: Sets countdown timer length, specified in minutes (E.G. '!timer 20' sets the timer length to 20 minutes)"};
				case "!live": {systemChat "!live: Starts a countdown timer, specified by !timer"};
				case "!addtime": {systemChat "!addTime: Adds time to the current timer, specified in minutes (negative values subtract)"};
				case "!quicktimer": {systemChat "!quickTimer: Starts a countdown timer, specified in minutes (E.G. '!quicktimer 20' creates a 20 minute timer)"};
				case "!overtime": {systemChat "!overTime: Creates an overtime period that occurs when the timer ends, a value of 0 disables overtime. Overtime must be reapplied for each timer"};
				case "!game": {systemChat "!game: Calls game and ends any countdown"};
				case "!ready": {systemChat "!ready: Sets the player's side as ready, and begins the safe start if all player sides are ready"};
				case "!unready": {systemChat "!unReady: Cancels the ready status for the player's side"};
				case "!cleanup": {systemChat "!cleanUp: (RESTRICTED) Cleans up bodies (trash can function)"};
				case "!arsenal": {systemChat "!arsenal: (RESTRICTED) Places an ACE arsenal in front of the player"};
				case "!heal": {systemChat "!heal: (RESTRICTED) ACE Heals players. '!heal' for all players, otherwise '!heal SIDE' (blufor, opfor, grnfor)"};
				case "!rearm": {systemChat "!rearm: (RESTRICTED) Rearms players. '!rearm' for all players, otherwise '!rearm SIDE' (blufor, opfor, grnfor)"};
				case "!reset": {systemChat "!reset: (ADMIN ONLY) Rearms, heals, and (optionally) teleports players to spawn. !reset' will rearm, heal, and teleport players to spawn. '!reset stay' will rearm and heal them. May also specify side (blufor, opfor, grnfor)"};
				case "!debrief": {systemChat "!debrief: (ADMIN ONLY) ACE Heals and teleports players for debrief. '!debrief' to teleport all players to Blufor base, '!debrief here' to teleport all players to your position"};
				case "!goto": {systemChat "!goto: (ADMIN ONLY) Teleports admin to side spawns. '!goto SIDE' (blufor, opfor, grnfor)"};
				case "!measure": {systemChat "!measure: (ADMIN ONLY) Measure distances on the map using shift + click markers. Set a reference using '!measure set', then use '!measure' to get distance to your current shift + click marker"};
				case "!tickets": {systemChat "!tickets: (ADMIN ONLY) Manages tickets and changes tickets for a given side, by the given value (E.G. '!tickets Blufor 5' will add 5 tickets to Blufor). '!tickets reset' sets all tickets to zero. '!tickets' returns the current value of all teams tickets. '!tickets enable' or 'disable' to enable/disable ticket system"};
				case "!parade": {systemChat "!parade: (ADMIN ONLY) Sets all players' loadout within 125m of your position to parade."};
				case "!s";
				case "!settings": {systemChat "!settings (or !s): (ADMIN ONLY) Opens the settings GUI for global mission settings."};
				case "!showchat": {systemChat "!showChat: Shows chat display (for bug where chat is hidden after using menu)."};
				case "!radio": {systemChat "!radioCheck: Checks radio encryption codes for TFAR radios."};
				default {systemChat "Can't find the specified command! Make sure to enter the command with the '!'"};
			};
		}
	],
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
				["<t color='#ffffff' size='5'>GAME!</t>","PLAIN",0.4] remoteExec ["DOTT_fnc_displayMsg"];
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
	],
	[
		"tickets",
		{
			_argument = _this select 0;
			_argument = toLower _argument;
			
			if (_argument isEqualTo "enable") exitWith //enable ticket system
			{
				systemChat "Ticket system enabled!";
				DOTT_ticketEnabled = true; publicVariable "DOTT_ticketEnabled";
			};
		
			if (!DOTT_ticketEnabled) exitWith //only allow '!tickets enable' if system is disabled
			{
				systemChat "Error: You must enable the ticket system first with '!tickets enable'";
			};
			
			if (_argument isEqualTo "") exitWith //'!tickets' with no argument to see current ticket values
			{
				systemChat format["Current Tickets: Blu: %1, Opf: %2, Grn: %3", DOTT_ticketWEST, DOTT_ticketEAST, DOTT_ticketGUER];
			};
			
			//filter out side and number the admin provides
			private _filterAmount = [_argument, "-0123456789"] call BIS_fnc_filterString;
			private _filterArg = [_argument, "abcdefghijklmnopqrstuvwxyz"] call BIS_fnc_filterString;
			private _ticketAmount = parsenumber _filterAmount;
			switch (_filterArg) do
			{
				case "blufor": { systemChat format["Changing Blufor tickets by %1",_ticketAmount]; ["WEST", _ticketAmount] call DOTT_fnc_ticketAdd };
				case "opfor": { systemChat format["Changing Opfor tickets by %1",_ticketAmount]; ["EAST", _ticketAmount] call DOTT_fnc_ticketAdd };
				case "grnfor": { systemChat format["Changing Grnfor tickets by %1",_ticketAmount]; ["GUER", _ticketAmount] call DOTT_fnc_ticketAdd };
				case "reset": { systemChat "Resetting tickets to zero!"; ["reset"] call DOTT_fnc_ticketAdd };
				case "disable": 
				{	
					//case for disable at the end
					systemChat "Ticket system disabled!";
					DOTT_ticketEnabled = false; publicVariable "DOTT_ticketEnabled";
					DOTT_ticketWEST = 0; publicVariable "DOTT_ticketWEST";
					DOTT_ticketEAST = 0; publicVariable "DOTT_ticketEAST";
					DOTT_ticketGUER = 0; publicVariable "DOTT_ticketGUER";
				};
				default {systemChat "Error: Invalid input! Must be 'blufor', 'opfor', 'grnfor',  'reset', 'enable', 'disable'"};
			};
		}
	],
	[
		"cleanup",
		{
			call Hill_fnc_cleaner;
			systemChat "Cleaning up!"
		}
	],
	[
		"arsenal",
		{
			//arsenal object array (Fun!)
			private _arsenalArr = ["Land_ToiletBox_F", "Land_FieldToilet_F"];
			//select object
			private _arsenalObj = selectRandom _arsenalArr;
			
			//get position in front of player
			private _dir = getDir player;
			private _offset = player getPos [3, _dir];
			private _posATL = getPosATL player;
			//use offset x/y but player z
			private _pos = [_offset select 0, _offset select 1, _posATL select 2];
			
			//create arsenal
			private _arsenal = _arsenalObj createVehicle _pos;
			_arsenal enableSimulationGlobal false;
			
			//add ACE arsenal
			[_arsenal, true] call ace_arsenal_fnc_initBox;
			
			[[_arsenal],
			{
				{
					_x addCuratorEditableObjects [_this, true];
				}
				forEach allCurators;
			}] remoteExec ["spawn", 2];

		}
	],
	[
		"heal",
		{
			_argument = _this select 0;
			if (_argument isEqualTo "") exitWith //empty arg means heal all players
			{
				[[[], true], DOTT_fnc_flexibleReset] remoteExec ["spawn"];
				systemChat "Healing all players!"
			};
			_argument = toLower _argument; //otherwise select team and heal
			switch (_argument) do
			{
				case "blufor": { [{ [[], true] spawn DOTT_fnc_flexibleReset} ] remoteExec ["call", west]; systemChat "Healing Blufor players!"; };
				case "opfor": { [{ [[], true] spawn DOTT_fnc_flexibleReset} ] remoteExec ["call", east]; systemChat "Healing Opfor players!";  };
				case "grnfor": { [{ [[], true] spawn DOTT_fnc_flexibleReset} ] remoteExec ["call", resistance]; systemChat "Healing Grnfor players!";  };
				default {systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'"};
			};
		}
	],
		[
		"rearm",
		{
			_argument = _this select 0;
			if (_argument isEqualTo "") exitWith
			{
				[{ [resetLoadout] spawn DOTT_fnc_flexibleReset }] remoteExec ["call"];
				systemChat "Rearming all players!";
			};
			_argument = toLower _argument;
			switch (_argument) do
			{
				case "blufor": { [{ [resetLoadout] spawn DOTT_fnc_flexibleReset }] remoteExec ["call", west]; systemChat "Rearming Blufor players!"; };
				case "opfor": { [{ [resetLoadout] spawn DOTT_fnc_flexibleReset }] remoteExec ["call", east]; systemChat "Rearming Opfor players!"; };
				case "grnfor": { [{ [resetLoadout] spawn DOTT_fnc_flexibleReset }] remoteExec ["call", resistance]; systemChat "Rearming Grnfor players!"; };
				default {systemChat "Error: Invalid input! Must be 'blufor', 'opfor', 'grnfor'"};
			};
		}
	],
	[
		"reset",
		{
			_argument = _this select 0;
			//blank argument means reset and teleport everybody
			if (_argument isEqualTo "") exitWith
			{
				[{[resetLoadout,true, getPosASL res_blu] spawn DOTT_fnc_flexibleReset}] remoteExec ["call", west];
				[{[resetLoadout,true, getPosASL res_red] spawn DOTT_fnc_flexibleReset}] remoteExec ["call", east];
				[{[resetLoadout,true, getPosASL res_grn] spawn DOTT_fnc_flexibleReset}] remoteExec ["call", resistance];
				systemChat "Rearming, healing, and teleporting all players to spawn!"
			};
			//toLower case to reduce user error
			_argument = toLower _argument;
			private _argArr = _argument splitString " "; //split arguments with spaces into array
			
			//look for stay in argument array (returns -1 if not found)
			private _stayArg = _argArr find "stay";
			if (_stayArg != -1) exitWith //if present, exitWith stay type args
			{
				//if just stay rearm/heal everybody
				if (count _argArr isEqualTo 1) exitWith 
				{ 
					[[resetLoadout,true], DOTT_fnc_flexibleReset] remoteExec ["spawn"];
					systemChat "Rearming and healing all players!";
				};
				//simple math determines position of side argument
				private _sideArg = (1 - _stayArg);
				
				//otherwise select side and rearm/heal them
				switch (_argArr select _sideArg) do
				{
					case "blufor": { [{[resetLoadout,true] spawn DOTT_fnc_flexibleReset}] remoteExec ["call", west]; systemChat "Rearming and healing Blufor players!"; };
					case "opfor": { [{[resetLoadout,true] spawn DOTT_fnc_flexibleReset}] remoteExec ["call", east]; systemChat "Rearming and healing Opfor players!"; };
					case "grnfor": { [{[resetLoadout,true] spawn DOTT_fnc_flexibleReset}] remoteExec ["call", resistance]; systemChat "Rearming and healing Grnfor players!"; };
					default {systemChat "Error: Invalid input(s)! Must be 'stay', 'blufor', 'opfor', 'grnfor'"};
				};
			};
			//if no stay, then rearm/heal/teleport that side
			switch (_argument) do
			{
				case "blufor": { [{ [resetLoadout, true, getPosASL res_blu] spawn DOTT_fnc_flexibleReset }] remoteExec ["call", west]; systemChat "Rearming, healing, and teleporting Blufor players to spawn!"; };
				case "opfor": { [{ [resetLoadout, true, getPosASL res_red] spawn DOTT_fnc_flexibleReset }] remoteExec ["call", east]; systemChat "Rearming, healing, and teleporting Opfor players to spawn!"; };
				case "grnfor": { [{ [resetLoadout, true, getPosASL res_grn] spawn DOTT_fnc_flexibleReset }] remoteExec ["call", resistance]; systemChat "Rearming, healing, and teleporting Grnfor players to spawn!"; };
				default {systemChat "Error: Invalid input(s)! Must be 'stay', 'blufor', 'opfor', 'grnfor'"};
			};
		}	
	],
	[
		"debrief",
		{
			_argument = _this select 0;
			//blank argument means debrief in blufor base
			if (_argument isEqualTo "") then
			{
				private _pos = getPosASL res_blu;
				[[true, true, _pos], DOTT_fnc_flexibleReset ] remoteExec ["spawn"];
				systemChat "Healing, rearming, and teleporting all players to Blufor base!";
			}
			else //teleport all players to 15 meters in front of admin
			{	
				//get offset pos
				private _dir = getDir player;
				private _pos = getPosASL player;
				private _offset = _pos getPos [15, _dir];
				//use offset x/y but player z (satisfies ASL requirement)
				private _telePos = [_offset select 0, _offset select 1, _pos select 2];
				
				[[true, true, _telePos], DOTT_fnc_flexibleReset] remoteExec ["spawn"];
				systemChat "Healing, rearming, and teleporting all players to you!";
			};
			lastDebriefTime = time; //for baseObjectsInit Force Parade
		}
	],
	[
		"goto", //teleport admin only to specified spawn
		{
			_argument = _this select 0;
			_argument = toLower _argument;
			switch (_argument) do
			{
				case "blufor": { [[],false,getPosASL blu_ammo] spawn DOTT_fnc_flexibleReset; systemChat "Teleporting to Blufor spawn!"; };
				case "opfor": { [[],false,getPosASL red_ammo] spawn DOTT_fnc_flexibleReset; systemChat "Teleporting to Opfor spawn!"; };
				case "grnfor": { [[],false,getPosASL grn_ammo] spawn DOTT_fnc_flexibleReset; systemChat "Teleporting to Grnfor spawn!"; };
				default {systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'"};
			};
		}
	],
	[
		"measure",
		{
			_argument = _this select 0;
			if (_argument == "") then //blank argument for actual measurement
			{
				if (isNil "plyrRefPos") then
				{
					systemChat "Error: Please define a base point with !measure set";
				}
				else //measure current shift+click marker based off reference
				{
					private _msrDistance = round (customWaypointPosition distance plyrRefPos);
					systemChat format["Distance is %1 meters", _msrDistance];
				};
			}
			else //anything else sets reference shift+click marker
			{
				private _waypointPosCount = count customWaypointPosition;
				if (_waypointPosCount == 3) then
				{
					plyrRefPos = customWaypointPosition;
					systemChat "Measurement reference point set";
				}
				else 
				{ 
					systemChat "Error: No marker! Place a marker on the map with shift + click"; 
				};
			};
		}
	],
	[
		"parade",
		{
			[player, 125] spawn DOTT_fnc_forceParadeAll;
		}
	],
	[
		"s",
		{
			createDialog ["RscDisplayMissionOptions", true];
		}
	],
	[
		"settings",
		{
			createDialog ["RscDisplayMissionOptions", true];
		}
	],
	[
		"showChat",
		{
			showChat true;
		}
	],
	[
		"radio",
		{
			private _strs = [];
			private _activeSw = call TFAR_fnc_activeSwRadio;
			if !(isNil "_activeSw") then
			{
				private _radioName = [_activeSw, "tf_parent", "SR"] call TFAR_fnc_getWeaponConfigProperty; 
				private _swCode = _activeSw call TFAR_fnc_getSWRadioCode;
				_strs pushBack format ["%1: %2", _radioName, _swCode];
			};

			private _activeLr = player call TFAR_fnc_backpackLR;
			if !(isNil "_activeLr") then
			{
				private _radioName = [typeOf (_activeLr select 0), "displayName", "LR"] call TFAR_fnc_getVehicleConfigProperty; 
				private _lrCode = _activeLr call TFAR_fnc_getLRRadioCode;
				_strs pushBack format ["%1: %2", _radioName, _lrCode];
			};

			private _vehicleLr = (player call TFAR_fnc_vehicleLr);
			if !(isNil "_vehicleLr") then
			{
				private _radioName = [typeOf (_vehicleLr select 0), "displayName", "Vic"] call TFAR_fnc_getVehicleConfigProperty; 
				private _vehLrCode = _vehicleLr call TFAR_fnc_getLRRadioCode;
				_strs pushBack format ["%1: %2", _radioName, _vehLrCode];
			};

			player sideChat (_strs joinString " | ");
		}
	]	
];