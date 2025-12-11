// --- Fast Rope for helicopters ---
if (isClass (configFile >> "CfgPatches" >> "ace_main")) then 
{
	addMissionEventHandler ["EntityCreated", 
	{
		if (!DOTT_autoAddFRIES) exitWith {};

		private _objectCreated = _this;
		if !(isNumber ((configOf _objectCreated) >> "ace_fastroping_enabled")) exitWith {};	
		if (_objectCreated isKindOf "Helicopter") then 
		{
			[_objectCreated] call ace_fastroping_fnc_equipFRIES;
		};
	}];
};

// --- Disable thermal imaging on vehicles ---
addMissionEventHandler ["EntityCreated", 
{
	private _objectCreated = _this;
	if (_objectCreated isKindOf "AllVehicles" && !(_objectCreated isKindOf "Man")) then 
	{
		_objectCreated disableTIEquipment DOTT_disableTI;
	};
}];

{
	if !(_x isKindOf "Man") then 
	{
		_x disableTIEquipment DOTT_disableTI;
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

