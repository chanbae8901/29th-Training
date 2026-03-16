/**
 * Function: TN_parade_fnc_checkNonCombatLoadout
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
 *   [player] call TN_parade_fnc_checkNonCombatLoadout;
 */

params ["_unit"];

// "r_Garrison_cap" prefix -- matches 29th ID BLUFOR garrison caps.
// "rhs_weap_m1garand_sa43" -- standard 29th parade rifle.
private _hasBluforParadeGear =
    (headgear _unit) find "r_Garrison_cap" == 0
    && primaryWeapon _unit == "rhs_weap_m1garand_sa43";

// Officers typically have no primary weapon.
private _hasNoPrimary = primaryWeapon _unit == "";

_hasBluforParadeGear || _hasNoPrimary
