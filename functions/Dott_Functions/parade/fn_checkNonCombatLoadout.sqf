/*
 * Name:	DOTT_parade_fnc_checkNonCombatLoadout
 * Date:	8/8/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Checks if a unit is in a non-combat loadout (suitable for lining up).
 *
 * Parameter(s): 
 * _unit (Object): The unit to check for non-combat loadout.
 *
 * Returns:
 * true if the unit is in a non-combat loadout, false otherwise.
 *
 * Example:
 * [player] call DOTT_parade_fnc_checkNonCombatLoadout;
 * 
 */

params["_unit"];
//BLUFOR parade gear,
(headgear _unit == "29th_rhs_patrolcap_ocp_retex" && primaryWeapon _unit == "rhs_weap_m1garand_sa43") ||
//dress blues,
(uniform _unit) find "29th_uniform" == 0 ||
//or no weapon
primaryWeapon _unit == ""