if (!hasInterface) exitWith {};

player spawn Hill_fnc_setInsignia;
[player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
[player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

resetLoadout = getUnitLoadout player;

//prevent inaudible weapon bug
[] spawn {
	sleep 1;
	[player, resetLoadout, true] call DOTT_fnc_safeSetUnitLoadout;	
};

if (!(weaponLowered player)) then {
	player action ["WeaponOnBack", player];
};
systemChat "Your gear has been saved.";
hintSilent "Your gear has been saved.";
true