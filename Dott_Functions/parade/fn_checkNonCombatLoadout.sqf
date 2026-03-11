/**
 * Function: DOTT_parade_fnc_checkNonCombatLoadout
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Checks if a unit is in a non-combat loadout (suitable for
 *   lining up).
 *
 * Parameters:
 *   _unit (Object) - The unit to check for non-combat loadout
 *
 * Returns:
 *   Boolean - true if the unit is in a non-combat loadout,
 *             false otherwise
 *
 * Example:
 *   [player] call DOTT_parade_fnc_checkNonCombatLoadout;
 */

params ["_unit"];

// BLUFOR parade gear,
((headgear _unit) find "r_Garrison_cap" == 0
    && primaryWeapon _unit == "rhs_weap_m1garand_sa43")
// or no weapon (Common Forced Parade Officer Loadout condition).
|| primaryWeapon _unit == ""
