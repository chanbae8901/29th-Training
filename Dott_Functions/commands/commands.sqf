// Code base by conroy - Actions by Dott [29th ID]
// Help section (line 24) gives a general guide of what each command does - Dott
// By default case sensitivity doesn't matter for commands in chat, but does for arguments that follow
// E.G. !commands, !COMMANDS, and !CoMmAnDs will all work, but '!help !COMMANDS' will not (unless argument is 'toLower' before hand is the command code)
// systemChat is the best way to give feedback to the local player executing commands

/*
	pvpfw_chatIntercept_noLogCommands
	pvpfw_chatIntercept_adminCommands
	pvpfw_chatIntercept_restrictedCommands
	created in XEH_preInit.sqf
*/

pvpfw_chatIntercept_helpInfo = 
[
	["help", "Gives help on how to use commands"],
	["commands", "Lists commands"],
	["arsenal", "Places an ACE arsenal in front of the player"],
	["measure", "Measure distances on the map using shift + click markers. Set a reference using '!measure set', then use '!measure' to get distance to your current shift + click marker"],
	["showchat", "Shows chat display (for bug where chat is hidden after using menu)."],
	["weaponstate", "List all players current having silent weapon bug ONLY for executing player."]
];


pvpfw_chatIntercept_allCommands = 
[
	[
		"commands",
		{
			_commands = "";
			{
				_commands = _commands + (pvpfw_chatIntercept_commandMarker + _x) + ", ";
			}forEach (keys pvpfw_chatIntercept_allCommands);
			systemChat format["Available Commands: %1",_commands];
			systemChat "Use !help followed by the command name to see how to use it";
		}
	],
	[
		"help",
		{
			_argument = _this select 0;
			_argument = toLower _argument;
			private _helpInfo = pvpfw_chatIntercept_helpInfo get _argument;
			if !(isNil "_helpInfo") then 
			{
				private _restrictionStr = switch (true) do
				{
					case (pvpfw_chatIntercept_adminCommands find _argument != -1): 
					{
						"(ADMIN ONLY)";
					};
					case (pvpfw_chatIntercept_restrictedCommands find _argument != -1): 
					{
						"(RESTRICTED)";
					};
					default 
					{
						"";
					};
				};
				systemChat format ["!%1: %2 %3", _argument, _restrictionStr, _helpInfo];
			} else { systemChat "Can't find the specified command! Make sure to enter the command without the '!'"};
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
		"showchat",
		{
			showChat true;
		}
	],
	[
		"weaponstate",
		{
			private _buggedPlayers = [];

			private _players = allPlayers - entities "HeadlessClient_F";
			_players = _players select { alive _x }; //only get alive players, probably not needed however
			
			{
				if !(currentWeapon _x == "Throw" || currentWeapon _x == "Put") then { continue };
				_buggedPlayers pushBack (name _x);
			}
			forEach _players;

			systemChat str _buggedPlayers;
		}
	]	
];