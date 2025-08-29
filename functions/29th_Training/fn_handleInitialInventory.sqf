if (!hasInterface) exitWith {};

private _theClient = _this select 0;

waitUntil {!isNull player};

if (side (group _theClient) == WEST) then {
	addMissionEventHandler ["PreloadFinished", {
		call DOTT_fnc_forceParade;
		removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
	}];
};
if (side (group _theClient) == EAST) then {
	[_theClient, missionConfigfile >> "CfgRespawnInventory" >> "29TH_PARADE_EAST"] call BIS_fnc_loadInventory;
};
if (side (group _theClient) == INDEPENDENT) then {
	[_theClient, missionConfigfile >> "CfgRespawnInventory" >> "29TH_PARADE_INDEPENDENT"] call BIS_fnc_loadInventory;
};