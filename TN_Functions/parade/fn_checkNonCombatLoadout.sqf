/*
 * Author: Bae [29th ID]
 * Checks if a unit is in a non-combat loadout (suitable for
 * lining up).
 *
 * Arguments:
 * 0: The unit to check for non-combat loadout <OBJECT>
 *
 * Return Value:
 * true if the unit is in a non-combat loadout, false otherwise <BOOL>
 *
 * Example:
 * [player] call TN_parade_fnc_checkNonCombatLoadout;
 */

params ["_unit"];

// "r_Garrison_cap" prefix -- matches 29th ID BLUFOR garrison caps.
// "rhs_weap_m1garand_sa43" -- standard 29th parade rifle.
private _hasBluforParadeGear =
    "r_Garrison_cap" in (headgear _unit)
    && primaryWeapon _unit == "rhs_weap_m1garand_sa43";

// Officers typically have no primary weapon.
private _hasNoPrimary = primaryWeapon _unit == "";

_hasBluforParadeGear || _hasNoPrimary
