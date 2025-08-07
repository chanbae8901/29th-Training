if (!hasInterface) exitWith {};
[player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
[player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

resetLoadout = getUnitLoadout player;

[] spawn 
{
	sleep 2;
	[player, true] spawn DOTT_fnc_checkPlayerWeaponState;	
	sleep 2;
	private _weaponStateMsg = format [
		"%1 has incorrect weapon state - Drop and re-equip your weapon. - On Arsenal Closed",
		name player
	];	
	//check player weapon state again in case autoFix didn't work, notify if it didn't
	//remove in future if this never shows up in systemChat
	[player, false, _weaponStateMsg] spawn DOTT_fnc_checkPlayerWeaponState;
};

player spawn Hill_fnc_setInsignia;

if (!(weaponLowered player)) then {
	player action ["WeaponOnBack", player];
};

systemChat "Your gear has been saved.";
hintSilent "Your gear has been saved.";
true