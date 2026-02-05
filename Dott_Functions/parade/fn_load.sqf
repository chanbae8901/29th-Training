/*
 * Name:	DOTT_parade_fnc_load
 * Date:	02/04/2026
 * Version: 1.1
 * Author:  Bae [29th ID]
 *
 * Description:
 * Swaps player not in non-combat uniform to parade uniform.
 *
 * Parameter(s): 
 * n/a
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_parade_fnc_load;
 * 
 */
//https://github.com/acemod/ACE3/blob/master/addons/arsenal/defines.hpp
(findDisplay 1127002) closeDisplay 1; //close loadouts first
(findDisplay 1127001) closeDisplay 1; //close ace arsenal

private _savedLoadouts = profileNamespace getVariable ["ace_arsenal_saved_loadouts", []];
private _customParadeIdx = _savedLoadouts findIf {_x select 0 == "Forced Parade"};
if (_customParadeIdx == -1) then
{
    [player, missionConfigFile >> "CfgRespawnInventory" >> "29TH_PARADE_WEST"] call BIS_fnc_loadInventory;
} else
{
    private _customParade = (_savedLoadouts select _customParadeIdx) select 1;
    [player, _customParade, true] call CBA_fnc_setLoadout;
    //don't pull out weapon if no primary 
    if (primaryWeapon player == "") then 
    {
        player action ["SwitchWeapon", player, player, -1] 
    };
};
player spawn DOTT_loadout_fnc_setInsignia;
systemChat "Parade loadout applied.";
true