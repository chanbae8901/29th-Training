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
[] spawn 
{
	waitUntil {!isNil "disabledTI"};

	if (disabledTI == 0) then 
	{
		addMissionEventHandler ["EntityCreated", 
		{
			private _objectCreated = _this;
			if (_objectCreated isKindOf "AllVehicles" && !(_objectCreated isKindOf "Man")) then 
			{
				_objectCreated disableTIEquipment true;
			};
		}];

		{
			if !(_x isKindOf "Man") then 
			{
				_x disableTIEquipment true;
			};
		} forEach allMissionObjects "AllVehicles";
	};
};

// --- Remove vehicle inventories ---
[] spawn 
{
	waitUntil {!isNil "removeDefaultVehicleInventories"};

	if (removeDefaultVehicleInventories == 1) then 
	{
		addMissionEventHandler ["EntityCreated", 
		{
			private _objectCreated = _this;
			if (_objectCreated isKindOf "AllVehicles" && !(_objectCreated isKindOf "Man")) then 
			{
				clearWeaponCargoGlobal _objectCreated;
				clearMagazineCargoGlobal _objectCreated;
				clearItemCargoGlobal _objectCreated;
				clearBackpackCargoGlobal _objectCreated;
			};
		}];

		{
			if !(_x isKindOf "Man") then 
			{
				clearWeaponCargoGlobal _x;
				clearMagazineCargoGlobal _x;
				clearItemCargoGlobal _x;
				clearBackpackCargoGlobal _x;
			};
		} forEach allMissionObjects "AllVehicles";
	};
};