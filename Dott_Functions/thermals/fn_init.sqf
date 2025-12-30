/*
 * Name:	DOTT_thermals_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes thermal restriction module.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_thermals_fnc_init;
 * 
 */

if (hasInterface) then 
{
	["visionMode", 
		{
			[] spawn DOTT_thermals_fnc_blackScreen;
		}
	] call CBA_fnc_addPlayerEventHandler;
};

if (isServer) then
{
	// --- Disable thermal imaging on vehicles ---
	addMissionEventHandler ["EntityCreated", 
	{
		private _objectCreated = _this;
		if (_objectCreated isKindOf "AllVehicles" && !(_objectCreated isKindOf "Man")) then 
		{
			_objectCreated disableTIEquipment TN_disableTI;
		};
	}];

	{
		if !(_x isKindOf "Man") then 
		{
			_x disableTIEquipment TN_disableTI;
		};
	} forEach allMissionObjects "AllVehicles";

	["DOTT_disablePIPThermalsEvent", "GetInMan", {
		if !(TN_disableTI) exitWith {};

		//some delay is necessary or PiP won't shut off
		[{ call DOTT_thermals_fnc_disablePIP }, [] , 0.1] call CBA_fnc_waitAndExecute;
	}] call CBA_fnc_addBISPlayerEventHandler;
};