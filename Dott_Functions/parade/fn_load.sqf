/**
 * Function: TN_parade_fnc_load
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Applies the parade loadout to the local player. If the player
 *   has a custom ACE Arsenal loadout named "Forced Parade", that
 *   loadout is used instead of the default WEST parade config.
 *   Closes any open arsenal displays before applying.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   true
 */

// ACE Arsenal display IDs (from ace3/addons/arsenal/defines.hpp):
//   1127001 = main ACE Arsenal display
//   1127002 = ACE Arsenal loadouts sub-display
(findDisplay 1127002) closeDisplay 1;
(findDisplay 1127001) closeDisplay 1;

private _savedLoadouts = profileNamespace getVariable [
    "ace_arsenal_saved_loadouts", []
];
private _customParadeIdx =
    _savedLoadouts findIf { _x select 0 == "Forced Parade" };

if (_customParadeIdx == -1) then
{
    // No custom parade loadout -- use default config.
    [
        player,
        missionConfigFile
            >> "CfgRespawnInventory"
            >> "29TH_PARADE_WEST"
    ] call BIS_fnc_loadInventory;
}
else
{
    // Apply the player's custom "Forced Parade" loadout.
    private _customParade =
        (_savedLoadouts select _customParadeIdx) select 1;
    [player, _customParade, true] call CBA_fnc_setLoadout;

    // Holster weapon if no primary exists.
    if (primaryWeapon player == "") then
    {
        player action ["SwitchWeapon", player, player, -1];
    };
};

player spawn TN_loadout_fnc_setInsignia;
systemChat "Parade loadout applied.";

true
