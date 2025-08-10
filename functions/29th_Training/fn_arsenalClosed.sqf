if (!hasInterface) exitWith {};
[player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
[player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

resetLoadout = getUnitLoadout player;

[] spawn 
{
	sleep 3;
	[player] spawn DOTT_fnc_resetWeaponState;
};

player spawn Hill_fnc_setInsignia;

if (!(weaponLowered player)) then 
{
	player action ["WeaponOnBack", player];
};

systemChat "Your gear has been saved.";
hintSilent "Your gear has been saved.";
true