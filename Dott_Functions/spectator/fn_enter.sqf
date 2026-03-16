/**
 * Function: TN_spectator_fnc_enter
 * Author:   Bae [29th ID], modified from Hill [29th ID]
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
 *     [] spawn TN_spectator_fnc_enter;
 */

/*
 * BIS_fnc_EGSpectator Initialize parameters:
 *
 * ["Initialize", [player, [<side>,<side>], true, true, true,
 *     true, true, true, true, true]] call BIS_fnc_EGSpectator;
 *
 * _this select 0 : The target player object
 * _this select 1 : Whitelisted sides, empty means all
 * _this select 2 : Whether AI can be viewed by the spectator
 * _this select 3 : Whether Free camera mode is available
 * _this select 4 : Whether 3rd Person Perspective camera mode
 *                   is available
 * _this select 5 : Whether to show Focus Info stats widget
 * _this select 6 : Whether or not to show camera buttons widget
 * _this select 7 : Whether to show controls helper widget
 * _this select 8 : Whether to show header widget
 * _this select 9 : Whether to show entities / locations lists
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
    case 1:
    {
        [player, [side player], false, false, false, false]
    };
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
        call TN_spectator_fnc_exit;
    };

    // Player drifted away from start position.
    if (getPosATL player distanceSqr _startPos > 25) exitWith
    {
        call TN_spectator_fnc_exit;
    };

    // Player respawned while in spectator (known issue).
    if (!alive player) exitWith
    {
        call TN_spectator_fnc_exit;
    };
}, [_startPos]] call BIS_fnc_addStackedEventHandler;

["enteredSpectator", []] call CBA_fnc_localEvent;

true
