/*
 * Name:	DOTT_parade_fnc_handleInitialInventory
 * Date:	1/5/2026
 * Version: 1.3
 * Author:  Hill [29th ID]
 *
 * Description:
 * Ensures joining player has correct loadout on joining the server, using custom parade if available on BLUFOR.
 *
 * Parameter(s): 
 * none
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_parade_fnc_handleInitialInventory
 */

if (!hasInterface) exitWith {};

private _fn_loadParade =
{
	private _side = side (group player);

	switch (_side) do
	{
		case WEST:
		{
			call DOTT_parade_fnc_load;
		};
		case EAST:
		{
			[player, missionConfigfile >> "CfgRespawnInventory" >> "29TH_PARADE_EAST"] call BIS_fnc_loadInventory;
		};
		case INDEPENDENT:
		{
			[player, missionConfigfile >> "CfgRespawnInventory" >> "29TH_PARADE_INDEPENDENT"] call BIS_fnc_loadInventory;
		};
	};
};

if (isNil "bis_fnc_preload_init") then //JIP
{
	addMissionEventHandler 
	[
		"PreloadFinished", 
		{
			call (_thisArgs select 0);
			removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
		}, 
		[_fn_loadParade]
	];
} else //non-JIP
{
	call _fn_loadParade;
};

