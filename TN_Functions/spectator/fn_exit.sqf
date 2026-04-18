#include "script_component.hpp"
/*
 * Author: Hill [29th ID]
 * Removes the player from ACE spectator mode and undoes all
 * changes made by TN_spectator_fnc_enter. Temporarily disables
 * damage to prevent collision kills when multiple players leave
 * the spectator box at once.
 *
 * NOTE: The variable TN_loadout_teleporting is a magic string
 * set by the loadout/teleport system. When present, it means the
 * player is mid-teleport and damage must stay disabled to avoid
 * conflicts. The 2-second re-enable is skipped in that case.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * False if not in spectator, true otherwise <BOOL>
 *
 * Example:
 * call TN_spectator_fnc_exit
 */

// --- Bail if spectator was never initialized ---
if !(GVAR(active)) exitWith { false };

GVAR(active) = false;
if (!isNil "ace_spectator_fnc_setSpectator") then {
    [false] call ace_spectator_fnc_setSpectator;
} else {
    ["Terminate"] call BIS_fnc_EGSpectator;
    [player, false] remoteExecCall ["hideObjectGlobal", 2];
};

cutText ["", "PLAIN DOWN"];
hintSilent "";

// Terminate makes the player vulnerable; disable damage briefly
// to survive collision with other players leaving the box.
player allowDamage false;

[{
    // Don't conflict with the loadout teleport system.
    if (!isNil QEGVAR(loadout,teleporting)) exitWith {};

    player allowDamage true;
}, [], 2] call CBA_fnc_waitAndExecute;

player switchCamera "internal";

if (!isNil QGVAR(exitPFH)) then {
    [GVAR(exitPFH)] call CBA_fnc_removePerFrameHandler;
    GVAR(exitPFH) = nil;
};


if !(weaponLowered player) then {
    player action ["WeaponOnBack", player];
};

[QGVAR(exited), []] call CBA_fnc_localEvent;

true
