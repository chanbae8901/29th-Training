#include "script_component.hpp"
/*
 * Author: Bae [29th ID], modified from Hill [29th ID]
 * Places the player into BIS EG Spectator mode and registers a
 * per-frame handler that exits spectator when the player presses
 * Reload, moves too far from the start position, or dies.
 *
 * KNOWN ISSUE: The player can sometimes respawn while still in the
 * spectator box. The onEachFrame handler catches this via an
 * !alive check and forces an exit to prevent a stuck state.
 *
 * Arguments:
 * 0: Unit to place into spectator (default: player) <OBJECT>
 * 1: Force spectator without exit hints or PFH checks (default: false) <BOOL>
 *
 * Return Value:
 * True if spectator entered, false if blocked <BOOL>
 *
 * Example:
 * [] call TN_spectator_fnc_enter
 * [player, true] call TN_spectator_fnc_enter
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

params [["_unit", player], ["_forced", false, [false]]];

if (isDedicated || !hasInterface) exitWith {
    ["Player must not be dedicated server or HC."]
        call BIS_fnc_error;
    false
};

// --- Spectator disabled by CBA setting ---
if (GVARMAIN(limitSpectator) isEqualTo 2) exitWith {
    ["Spectator Disabled"] call EFUNC(common,timedHint);
    false
};

if (!_forced) then {
    hintSilent "SPECTATOR\n----------\nPress RELOAD to exit";

    // --- Periodic reminder while spectating ---
    [{
        cutText [
            "SPECTATOR\n----------\nPress RELOAD to exit",
            "PLAIN DOWN"
        ];
    }, 30, [], {}, {}, {true}, {
        isNil "BIS_EGSpectator_initialized"
    }] call CBA_fnc_createPerFrameHandlerObject;
};

[_unit, true] remoteExecCall ["hideObjectGlobal", 2];

// --- Build params based on spectator restriction level ---
private _params = switch (GVARMAIN(limitSpectator)) do {
    case 0: { [_unit, [], false] };
    case 1: {
        [_unit, [side _unit], false, false, false, false]
    };
    default { [_unit, [], false] };
};

["Initialize", _params] call BIS_fnc_EGSpectator;

if (!_forced) then
{
    // --- Per-frame exit checks ---
    private _startPos = getPosATL _unit;

    GVAR(exitPFH) = [{
        params ["_args"];
        _args params ["_startPos", "_unit"];

        // Reload key pressed.
        if (inputAction "ReloadMagazine" > 0) exitWith {
            call FUNC(exit);
        };

        // Player drifted away from start position.
        if (getPosATL _unit distanceSqr _startPos > 25) exitWith {
            call FUNC(exit);
        };

        // Player respawned while in spectator (known issue).
        if (!alive _unit) exitWith {
            call FUNC(exit);
        };
    }, 0, [_startPos, _unit]] call CBA_fnc_addPerFrameHandler;
};


[QGVAR(entered), []] call CBA_fnc_localEvent;

true
