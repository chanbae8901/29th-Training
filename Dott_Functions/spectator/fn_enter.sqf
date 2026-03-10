/**
 * DOTT_spectator_fnc_enter
 *
 * Places the player into BIS EG Spectator mode and registers a
 * per-frame handler that exits spectator when the player presses
 * Reload, moves too far from the start position, or dies.
 *
 * Must be spawned, not called.
 *
 * KNOWN ISSUE: The player can sometimes respawn while still in the
 * spectator box. The onEachFrame handler catches this via an
 * !alive check and forces an exit to prevent a stuck state.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     BOOL - true if spectator entered, false if blocked
 *
 * Example:
 *     [] spawn DOTT_spectator_fnc_enter;
 */

if (isDedicated || !hasInterface) exitWith
{
    ["Player must not be dedicated server or HC."]
        call BIS_fnc_error;
    false
};

// --- Spectator disabled by CBA setting ---
if (TN_limitSpectator == 2) exitWith
{
    hint "Spectator Disabled";
    false
};

hintSilent "SPECTATOR\n----------\nPress RELOAD to exit";

// --- Periodic reminder while spectating ---
[] spawn
{
    while {
        !isNil {
            missionNamespace getVariable
                "BIS_EGSpectator_initialized"
        }
    } do
    {
        cutText [
            "SPECTATOR\n----------\nPress RELOAD to exit",
            "PLAIN DOWN"
        ];
        sleep 30;
    };
};

[player, true] remoteExecCall ["hideObjectGlobal", 2];

// --- Build params based on spectator restriction level ---
private _params = switch (TN_limitSpectator) do
{
    case 0: { [player, [], false] };
    case 1: { [player, [side player], false, false, false, false] };
    default { [player, [], false] };
};

["Initialize", _params] call BIS_fnc_EGSpectator;

// --- Per-frame exit checks ---
private _startPos = getPosATL player;

["exitSpectator", "onEachFrame",
{
    params ["_startPos"];

    // Reload key pressed.
    if (inputAction "ReloadMagazine" > 0) exitWith
    {
        call DOTT_spectator_fnc_exit;
    };

    // Player drifted away from start position.
    if (getPosATL player distanceSqr _startPos > 25) exitWith
    {
        call DOTT_spectator_fnc_exit;
    };

    // Player respawned while in spectator (known issue).
    if (!alive player) exitWith
    {
        call DOTT_spectator_fnc_exit;
    };
}, [_startPos]] call BIS_fnc_addStackedEventHandler;

["enteredSpectator", []] call CBA_fnc_localEvent;

true
