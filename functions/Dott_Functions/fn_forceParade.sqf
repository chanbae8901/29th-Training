/*
 * Name:	fnc_forceParade
 * Date:	8/27/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Swaps player not in non-combat uniform to parade uniform.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_fnc_forceParade;
 * 
 */
private _savedLoadouts = profileNamespace getVariable ["ace_arsenal_saved_loadouts", []];
private _customParadeIdx = _savedLoadouts findIf {_x select 0 == "Forced Parade"};
if (_customParadeIdx == -1) then
{
    [player, missionConfigFile >> "CfgRespawnInventory" >> "29TH_PARADE_WEST"] call BIS_fnc_loadInventory;
} else
{
    private _customParade = (_savedLoadouts select _customParadeIdx) select 1;
    [player, _customParade, true] call CBA_fnc_setLoadout;
    player spawn Hill_fnc_setInsignia;    
};

true