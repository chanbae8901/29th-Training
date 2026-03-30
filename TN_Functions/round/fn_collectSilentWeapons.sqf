#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Collects the name of a player detected with the silent weapon bug
 * into a server-side hashmap. Called via remoteExecCall from each
 * client after round start.
 *
 * Arguments:
 * 0: Display name of the player holding the bugged weapon <STRING>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [_name] call TN_round_fnc_collectSilentWeapons;
 */

params ["_weaponHolder"];

if (isNil QGVAR(clientSilentWeapons)) then {
    GVAR(clientSilentWeapons) = createHashMap;
};

GVAR(clientSilentWeapons) set [_weaponHolder, true];

nil
