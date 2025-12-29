#include "..\..\..\data\defines.hpp"

//Note: Events DOTT_enteredZeus and DOTT_exitedZeus are defined in cfgEventHandlers

if (hasInterface) then 
{
	{
		// -2 = NV, -1 = normal, 3rd number is TI see https://community.bistudio.com/wiki/setCamUseTi	
		[_x, [-1, -2, 0]] call BIS_fnc_setCuratorVisionModes; 
	} forEach allCurators;

	//Draw little skulls each time a player dies.  Seen only by Zeus.
	player call BIS_fnc_drawCuratorDeaths;

	["DOTT_enteredZeus",
		{
			private _curatorName = name player;
			private _msg = format ["CURATOR INTERFACE OPENED: %1", _curatorName];
			_msg remoteExec ["DOTT_common_fnc_diag_log",2];
		}
	] call CBA_fnc_addEventHandler;

	[player] spawn DOTT_curator_fnc_checkAssignment;

	[player] remoteExec ["DOTT_curator_fnc_addPlayerEditable", 2];	
};

if (isServer) then
{
	addMissionEventHandler ["OnUserAdminStateChanged", {
		params ["_networkId", "_loggedIn"];
		private _unit = (getUserInfo _networkId) select 10;	
		if (isNil "_unit") exitWith {};
		if (_loggedIn) exitWith 
		{
			if (isNull getAssignedCuratorLogic _unit) then 
			{ 
				_unit assignCurator zeus_admin; 
			};
		};
		[_unit] spawn {
			params ["_unit"];
			if (getAssignedCuratorLogic _unit == zeus_admin) then
			{
				waitUntil { isNull (getAssignedCuratorLogic _unit) };
			};  
			[_unit] spawn DOTT_curator_fnc_checkAssignment;
		}
	}];

	#ifdef DOTT_TRAINING
	[] spawn DOTT_curator_fnc_excludeObjects;
	#endif

	#ifdef DOTT_EVENT
	[] spawn DOTT_curator_fnc_eventExcludeObjects;
	#endif
};