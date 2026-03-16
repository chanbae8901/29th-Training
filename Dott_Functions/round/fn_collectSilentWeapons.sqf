/**
 * Function: TN_round_fnc_collectSilentWeapons
 * Author:   Bae [29th ID]
 *
 * Collects the name of a player detected with the silent weapon bug
 * into a server-side hashmap. Called via remoteExecCall from each
 * client after round start.
 *
 * Parameters:
 *     _weaponHolder - String - Display name of the player holding the
 *         bugged weapon.
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     [_name] call TN_round_fnc_collectSilentWeapons;
 */

params ["_weaponHolder"];

if (isNil "TN_round_clientSilentWeapons") then
{
    TN_round_clientSilentWeapons = createHashMap;
};

TN_round_clientSilentWeapons set [_weaponHolder, true];
