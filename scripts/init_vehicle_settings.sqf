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

