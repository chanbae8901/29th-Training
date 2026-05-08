#include "script_component.hpp"
/*
 * Author: Bae [29th ID], modified from Hill [29th ID]
 * Places the player into ACE spectator mode and registers a
 * per-frame handler that exits spectator when the player presses
 * Reload, moves too far from the start position, or dies.
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

GVAR(active) = true;

#define HINT_TITLE "SPECTATOR\n----------\n"

private _hintText = HINT_TITLE;
if (!_forced) then {
    _hintText = _hintText +
    "Press Reload to Exit\n";
};

if (!isNil "ace_spectator_fnc_setSpectator") then
{
    if (GVARMAIN(limitSpectator) isEqualTo 0) then {
        _hintText = _hintText +
        "Press [ for Scoreboard\n";
    };
    _hintText = _hintText +
    "Press H for ACE Medical Stats";
};

if (_hintText isNotEqualTo HINT_TITLE) then {hintSilent _hintText};

if (!_forced) then {
    // --- Periodic reminder while spectating ---
    [{
        cutText [
            "SPECTATOR\n----------\nPress RELOAD to Exit",
            "PLAIN DOWN"
        ];
    }, 30, [], {}, {}, {true}, {
        !(GVAR(active))
    }] call CBA_fnc_createPerFrameHandlerObject;
};

if (!isNil "ace_spectator_fnc_setSpectator") then {
    [true, true, false] call ace_spectator_fnc_setSpectator;
    //Manually hide the player instead of using ACE
    //to avoid group leave
    if (alive player) then {
        player allowDamage false;
        player setVariable ["ace_medical_allowDamage", false];
        [player, "ace_spectator_isSet"] call ace_common_fnc_hideUnit;
        [player, "ace_spectator_isSet"] call ace_common_fnc_muteUnit;
    };

    [{!isNull findDisplay 60000}, {
        if (GVARMAIN(limitSpectator) isEqualTo 0) then {
            //Workaround for ACE Spectator blocking default scoreboard button 'P'
            (findDisplay 60000) displayAddEventHandler ["KeyDown", {
                params ["", "_key"];
                if (_key isEqualTo 0x1A) then { //[
                    showScoretable ([1, 0] select visibleScoretable);
                };
                false
            }];
        };

        call FUNC(aceMedicalInit);
    }] call CBA_fnc_waitUntilAndExecute;
} else {
    [_unit, true] remoteExecCall ["hideObjectGlobal", 2];
    private _params = if (GVARMAIN(limitSpectator) isEqualTo 1) then {
        [_unit, [side _unit], false, false, false, false]
    } else {
        [_unit, [], false]
    };
    ["Initialize", _params] call BIS_fnc_EGSpectator;
};


if (!_forced) then {
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

if (alive _unit) then { _unit enableSimulationGlobal false };

[QGVAR(entered), []] call CBA_fnc_localEvent;

true
