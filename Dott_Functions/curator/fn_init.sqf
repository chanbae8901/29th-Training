/*
 * Name:	DOTT_curator_fnc_init
 * Date:	02/19/2026
 * Version: 2.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes curator modules, fixes, and settings.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_curator_fnc_init;
 * 
 */

//Note: Events DOTT_enteredZeus and DOTT_exitedZeus are defined in cfgEventHandlers

#define CREATE_CURATOR_MODULE(_obj) [vehicleVarName _obj, roleDescription _obj] call DOTT_curator_fnc_createModule

if (hasInterface) then 
{
	[] spawn 
	{
		waitUntil { !isNull player };

		//Draw little skulls each time a player dies. Seen only by Zeus.
		player call BIS_fnc_drawCuratorDeaths;

		["DOTT_enteredZeus",
			{
				private _curatorName = name player;
				private _msg = format ["CURATOR INTERFACE OPENED: %1", _curatorName];
				_msg remoteExec ["DOTT_common_fnc_diag_log",2];
			}
		] call CBA_fnc_addEventHandler;
	};	
};

if (isServer) then
{
	if (isNil "DOTT_curator_units") then //in case curator units aren't defined for some reason
	{
		DOTT_curator_units = ["#adminLogged"];
	};

	//add curator modules that exist in sqm to unit list to fix Zeus not working for JIP players until they die or respawn (primarily for event template)
	{
		private _owner = _x getVariable "owner";
		DOTT_curator_units pushBackUnique _owner;
	}
	forEach (allMissionObjects "ModuleCurator_F");

	//in case zeus_admin is in mission.sqm for some reason, I guess hope mission maker set it to this variable name
	//TODO: Check if #adminLogged owner curator module exists and assign zeus_admin to that instead of assuming above
	if (isNil "zeus_admin") then { 
		[{time > 0}, { zeus_admin = ["#adminLogged", "Admin"] call DOTT_curator_fnc_createModule }] call CBA_fnc_waitUntilAndExecute;
	};

	{
		CREATE_CURATOR_MODULE(_x);		
	}
	forEach allPlayers; //below event handler fires too late for non-JIP players

	addMissionEventHandler ["OnUserSelectedPlayer", 
	{
		params ["_networkId", "_playerObject"];
		
		if (isNull _playerObject) exitWith { diag_log "Player was null for curator module creation." };

		[_playerObject] call DOTT_curator_fnc_addPlayerEditable;

		CREATE_CURATOR_MODULE(_playerObject);
	}];

	addMissionEventHandler ["OnUserAdminStateChanged", {
		params ["_networkId", "_loggedIn"];
		private _userInfo = (getUserInfo _networkId);
		if (count _userInfo < 11) exitWith {};
		private _unit = _userInfo select 10;	
		if (isNil "_unit") exitWith {};
		if (_loggedIn) exitWith 
		{
			if (isNull getAssignedCuratorLogic _unit) then 
			{
				[_unit] spawn
				{
					params ["_unit"];
					unassignCurator zeus_admin;
					sleep .1;
					_unit assignCurator zeus_admin; 
				};

			};
		};
		//logging out
		[_unit] spawn {
			params ["_unit"];
			if (getAssignedCuratorLogic _unit == zeus_admin) then
			{
				[_unit] spawn
				{
					params ["_unit"];					
					unassignCurator zeus_admin;
					sleep .1;
					CREATE_CURATOR_MODULE(_unit);
				};
			};
		};
	}];

	[] spawn DOTT_curator_fnc_excludeObjects;
};