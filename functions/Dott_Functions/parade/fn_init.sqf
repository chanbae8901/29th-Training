if (hasInterface) then
{
	[player] spawn DOTT_parade_fnc_handleInitialInventory;
};

if (isServer) then
{
	[WEST, "29TH_PARADE_WEST"] call BIS_fnc_addRespawnInventory;
	[EAST, "29TH_PARADE_EAST"] call BIS_fnc_addRespawnInventory;
	[INDEPENDENT, "29TH_PARADE_INDEPENDENT"] call BIS_fnc_addRespawnInventory;
};