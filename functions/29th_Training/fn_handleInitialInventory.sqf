/*
 * Name:	Hill_fnc_handleInitialInventory
 * Date:	9/30/2025
 * Version: 1.2
 * Author:  Hill [29th ID]
 *
 * Description:
 * Ensures joining player has correct loadout on joining the server, using custom parade if available on BLUFOR.
 *
 * Parameter(s): 
 * _theClient: unit to handle initial inventory
 *
 * Returns:
 * n/a
 *
 * Example:
 * [player] spawn Hill_fnc_handleInitialInventory
 */

if (!hasInterface) exitWith {};

private _theClient = _this select 0;

waitUntil {!isNull player};

if (side (group _theClient) == WEST) then {
	addMissionEventHandler ["PreloadFinished", {
		[true] call DOTT_fnc_loadParade;
		removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
	}];
};
if (side (group _theClient) == EAST) then {
	[_theClient, missionConfigfile >> "CfgRespawnInventory" >> "29TH_PARADE_EAST"] call BIS_fnc_loadInventory;
};
if (side (group _theClient) == INDEPENDENT) then {
	[_theClient, missionConfigfile >> "CfgRespawnInventory" >> "29TH_PARADE_INDEPENDENT"] call BIS_fnc_loadInventory;
};