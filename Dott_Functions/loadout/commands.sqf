[
	[
		[
			"heal",
			{
				_argument = _this select 0;
				if (_argument isEqualTo "") exitWith //empty arg means heal all players
				{
					[[[], true], DOTT_loadout_fnc_flexibleReset] remoteExec ["spawn"];
					systemChat "Healing all players!"
				};
				_argument = toLower _argument; //otherwise select team and heal
				switch (_argument) do
				{
					case "blufor": { [{ [[], true] spawn DOTT_loadout_fnc_flexibleReset} ] remoteExec ["call", west]; systemChat "Healing Blufor players!"; };
					case "opfor": { [{ [[], true] spawn DOTT_loadout_fnc_flexibleReset} ] remoteExec ["call", east]; systemChat "Healing Opfor players!";  };
					case "grnfor": { [{ [[], true] spawn DOTT_loadout_fnc_flexibleReset} ] remoteExec ["call", resistance]; systemChat "Healing Grnfor players!";  };
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
					[{ [resetLoadout] spawn DOTT_loadout_fnc_flexibleReset }] remoteExec ["call"];
					systemChat "Rearming all players!";
				};
				_argument = toLower _argument;
				switch (_argument) do
				{
					case "blufor": { [{ [resetLoadout] spawn DOTT_loadout_fnc_flexibleReset }] remoteExec ["call", west]; systemChat "Rearming Blufor players!"; };
					case "opfor": { [{ [resetLoadout] spawn DOTT_loadout_fnc_flexibleReset }] remoteExec ["call", east]; systemChat "Rearming Opfor players!"; };
					case "grnfor": { [{ [resetLoadout] spawn DOTT_loadout_fnc_flexibleReset }] remoteExec ["call", resistance]; systemChat "Rearming Grnfor players!"; };
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
					[{[resetLoadout,true, getPosASL base_res_blu] spawn DOTT_loadout_fnc_flexibleReset}] remoteExec ["call", west];
					[{[resetLoadout,true, getPosASL base_res_red] spawn DOTT_loadout_fnc_flexibleReset}] remoteExec ["call", east];
					[{[resetLoadout,true, getPosASL base_res_grn] spawn DOTT_loadout_fnc_flexibleReset}] remoteExec ["call", resistance];
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
						[[resetLoadout,true], DOTT_loadout_fnc_flexibleReset] remoteExec ["spawn"];
						systemChat "Rearming and healing all players!";
					};
					//simple math determines position of side argument
					private _sideArg = (1 - _stayArg);
					
					//otherwise select side and rearm/heal them
					switch (_argArr select _sideArg) do
					{
						case "blufor": { [{[resetLoadout,true] spawn DOTT_loadout_fnc_flexibleReset}] remoteExec ["call", west]; systemChat "Rearming and healing Blufor players!"; };
						case "opfor": { [{[resetLoadout,true] spawn DOTT_loadout_fnc_flexibleReset}] remoteExec ["call", east]; systemChat "Rearming and healing Opfor players!"; };
						case "grnfor": { [{[resetLoadout,true] spawn DOTT_loadout_fnc_flexibleReset}] remoteExec ["call", resistance]; systemChat "Rearming and healing Grnfor players!"; };
						default {systemChat "Error: Invalid input(s)! Must be 'stay', 'blufor', 'opfor', 'grnfor'"};
					};
				};
				//if no stay, then rearm/heal/teleport that side
				switch (_argument) do
				{
					case "blufor": { [{ [resetLoadout, true, getPosASL base_res_blu] spawn DOTT_loadout_fnc_flexibleReset }] remoteExec ["call", west]; systemChat "Rearming, healing, and teleporting Blufor players to spawn!"; };
					case "opfor": { [{ [resetLoadout, true, getPosASL base_res_red] spawn DOTT_loadout_fnc_flexibleReset }] remoteExec ["call", east]; systemChat "Rearming, healing, and teleporting Opfor players to spawn!"; };
					case "grnfor": { [{ [resetLoadout, true, getPosASL base_res_grn] spawn DOTT_loadout_fnc_flexibleReset }] remoteExec ["call", resistance]; systemChat "Rearming, healing, and teleporting Grnfor players to spawn!"; };
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
					private _pos = getPosASL base_res_blu;
					[[true, true, _pos], DOTT_loadout_fnc_flexibleReset ] remoteExec ["spawn"];
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
					
					[[true, true, _telePos], DOTT_loadout_fnc_flexibleReset] remoteExec ["spawn"];
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
					case "blufor": { [[],false,getPosASL blu_ammo] spawn DOTT_loadout_fnc_flexibleReset; systemChat "Teleporting to Blufor spawn!"; };
					case "opfor": { [[],false,getPosASL red_ammo] spawn DOTT_loadout_fnc_flexibleReset; systemChat "Teleporting to Opfor spawn!"; };
					case "grnfor": { [[],false,getPosASL grn_ammo] spawn DOTT_loadout_fnc_flexibleReset; systemChat "Teleporting to Grnfor spawn!"; };
					default {systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'"};
				};
			}
		]
	],
	[
		["heal", "ACE Heals players. '!heal' for all players, otherwise '!heal SIDE' (blufor, opfor, grnfor)"],
		["rearm", "Rearms players. '!rearm' for all players, otherwise '!rearm SIDE' (blufor, opfor, grnfor)"],
		["reset", "Rearms, heals, and (optionally) teleports players to spawn. !reset' will rearm, heal, and teleport players to spawn. '!reset stay' will rearm and heal them. May also specify side (blufor, opfor, grnfor)"],
		["debrief", "ACE Heals and teleports players for debrief. '!debrief' to teleport all players to Blufor base, '!debrief here' to teleport all players to your position"],
		["goto", "Teleports admin to side spawns. '!goto SIDE' (blufor, opfor, grnfor)"]
	]
] call DOTT_commands_fnc_addModule;