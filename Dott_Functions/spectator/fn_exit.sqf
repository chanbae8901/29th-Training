/**
 * Function: TN_spectator_fnc_exit
 * Author:   Hill [29th ID]
 *
 * Removes the player from BIS EG Spectator mode and undoes all
 * changes made by TN_spectator_fnc_enter. Temporarily disables
 * damage to prevent collision kills when multiple players leave
 * the spectator box at once.
 *
 * NOTE: The variable TN_loadout_teleporting is a magic string
 * set by the loadout/teleport system. When present, it means the
 * player is mid-teleport and damage must stay disabled to avoid
 * conflicts. The 2-second re-enable is skipped in that case.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     BOOL - false if not in spectator, true otherwise
 *
 * Example:
 *     call TN_spectator_fnc_exit;
 */

// --- Bail if spectator was never initialized ---
if (isNil {
    missionNamespace getVariable "BIS_EGSpectator_initialized"
}) exitWith { false };

["Terminate"] call BIS_fnc_EGSpectator;
[player, false] remoteExecCall ["hideObjectGlobal", 2];

cutText ["", "PLAIN DOWN"];
hintSilent "";

// Terminate makes the player vulnerable; disable damage briefly
// to survive collision with other players leaving the box.
player allowDamage false;

[] spawn
{
    sleep 2;

    // Don't conflict with the loadout teleport system.
    if (!isNil "TN_loadout_teleporting") exitWith {};

    player allowDamage true;
};

player switchCamera "internal";

["exitSpectator", "onEachFrame"]
    call BIS_fnc_removeStackedEventHandler;

if !(weaponLowered player) then
{
    player action ["WeaponOnBack", player];
};

["exitedSpectator", []] call CBA_fnc_localEvent;

true
