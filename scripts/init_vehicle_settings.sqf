// --- Fast Rope for helicopters ---
if (isClass (configFile >> "CfgPatches" >> "ace_main")) then 
{
	addMissionEventHandler ["EntityCreated", 
	{
		private _objectCreated = _this;
		if (_objectCreated isKindOf "Helicopter") then 
		{
			[_objectCreated] call ace_fastroping_fnc_equipFRIES;
		};
	}];

	{
		if (_x isKindOf "Helicopter") then 
		{
			[_x] call ace_fastroping_fnc_equipFRIES;
		};
	} forEach allMissionObjects "AllVehicles";
};

// --- Disable thermal imaging on vehicles ---
addMissionEventHandler ["EntityCreated", 
{
	private _objectCreated = _this;
	if (_objectCreated isKindOf "AllVehicles" && !(_objectCreated isKindOf "Man")) then 
	{
		_objectCreated disableTIEquipment DOTT_disabledTI;
	};
}];

{
	if !(_x isKindOf "Man") then 
	{
		_x disableTIEquipment DOTT_disabledTI;
	};
} forEach allMissionObjects "AllVehicles";

["DOTT_disablePIPThermalsEvent", "GetInMan", {
	if !(DOTT_disableTI) exitWith {};

	//some delay is necessary or PiP won't shut off
	[{ call DOTT_fnc_disablePIPThermals }, [] , 0.1] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addBISPlayerEventHandler;

// --- Remove vehicle inventories ---
addMissionEventHandler ["EntityCreated", 
{
	if !(DOTT_removeDefaultVehicleInventories) exitWith {};
	private _objectCreated = _this;
	if (_objectCreated isKindOf "AllVehicles" && !(_objectCreated isKindOf "Man")) then 
	{
		clearWeaponCargoGlobal _objectCreated;
		clearMagazineCargoGlobal _objectCreated;
		clearItemCargoGlobal _objectCreated;
		clearBackpackCargoGlobal _objectCreated;
	};
}];

if !(DOTT_removeDefaultVehicleInventories) exitWith {};

{
	if (_x isKindOf "Man") then {continue}; 

	clearWeaponCargoGlobal _x;
	clearMagazineCargoGlobal _x;
	clearItemCargoGlobal _x;
	clearBackpackCargoGlobal _x;
} forEach allMissionObjects "AllVehicles";

