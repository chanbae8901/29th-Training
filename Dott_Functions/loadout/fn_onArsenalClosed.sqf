/**
 * DOTT_loadout_fnc_onArsenalClosed
 *
 * Purpose: Post-arsenal cleanup. Saves the player's current inventory
 *          as their respawn loadout, attempts to fix the silent weapon
 *          bug by cycling primary weapon magazines, reapplies insignia,
 *          and lowers the weapon.
 *
 * Params:  None
 * Returns: true
 *
 * Example: call DOTT_loadout_fnc_onArsenalClosed;
 */

// --- Persist inventory for respawn ---
[player, [missionNamespace, "Current Inventory"]]
    call BIS_fnc_saveInventory;
[player, ["missionNamespace:Current Inventory"]]
    call BIS_fnc_setRespawnInventory;

resetLoadout = [player] call CBA_fnc_getLoadout;

// Weak fix for potential silent weapon bug when player after
// respawn having selected loadout in previous life, enters
// ACE arsenal and picks same loadout.
// Weak meaning fixing some but not all cases.
[] spawn
{
    // Wait until unit is not reloading.
    waitUntil
    {
        sleep 1;
        (weaponState player) select 6 == 0
    };

    private _primaryMags = primaryWeaponMagazine player;

    {
        player removePrimaryWeaponItem _x;
    } forEach _primaryMags;

    sleep 1;

    {
        player addPrimaryWeaponItem _x;
    } forEach _primaryMags;
};

player spawn DOTT_loadout_fnc_setInsignia;

if !(weaponLowered player) then
{
    player action ["WeaponOnBack", player];
};

systemChat "Your gear has been saved.";

true
