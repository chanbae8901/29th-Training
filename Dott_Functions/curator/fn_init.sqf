#include "..\..\data\defines.hpp"

/*
 * Name:	DOTT_curator_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes curator fixes and settings.
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

if (hasInterface) then 
{
	{
		// -2 = NV, -1 = normal, 3rd number is TI see https://community.bistudio.com/wiki/setCamUseTi	
		[_x, [-1, -2, 0]] call BIS_fnc_setCuratorVisionModes; 
	} forEach allCurators;

	[] spawn 
	{
		waitUntil { !isNull player };

		//Draw little skulls each time a player dies.  Seen only by Zeus.
		player call BIS_fnc_drawCuratorDeaths;

		["DOTT_enteredZeus",
			{
				private _curatorName = name player;
				private _msg = format ["CURATOR INTERFACE OPENED: %1", _curatorName];
				_msg remoteExec ["DOTT_common_fnc_diag_log",2];
			}
		] call CBA_fnc_addEventHandler;

		//Fix role-based Zeus not working on first life when JIP
		if (isNil "bis_fnc_preload_init") then //JIP
		{
			addMissionEventHandler 
			[
				"PreloadFinished", 
				{
					[player] call DOTT_curator_fnc_checkAssignment;
					removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
				}
			];
		} else //non-JIP, but might not be needed because this is a JIP problem
		{
			[player] call DOTT_curator_fnc_checkAssignment;
		};

		[player] remoteExec ["DOTT_curator_fnc_addPlayerEditable", 2];
	};	
};

if (isServer) then
{
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
					[_unit] spawn DOTT_curator_fnc_checkAssignment;
				};
			};
		};
	}];

	#ifdef DOTT_TRAINING
	[] spawn DOTT_curator_fnc_excludeObjects;
	#endif

	#ifdef DOTT_EVENT
	[] spawn DOTT_curator_fnc_eventExcludeObjects;
	#endif
};