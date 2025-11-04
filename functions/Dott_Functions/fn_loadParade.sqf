/*
 * Name:	DOTT_fnc_loadParade
 * Date:	8/27/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Swaps player not in non-combat uniform to parade uniform.
 *
 * Parameter(s): 
 * _force (Boolean - default false): Load parade uniform even if in non-combat uniform.
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_fnc_loadParade;
 * 
 */
params [["_force", false, [true]]];
//https://github.com/acemod/ACE3/blob/master/addons/arsenal/defines.hpp
(findDisplay 1127002) closeDisplay 1; //close loadouts first
(findDisplay 1127001) closeDisplay 1; //close ace arsenal

if !(_force || !([player] call DOTT_fnc_checkNonCombatLoadout)) exitWith {};
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
player spawn Hill_fnc_setInsignia;
if !(_force) then { systemChat "Parade loadout applied." };
true