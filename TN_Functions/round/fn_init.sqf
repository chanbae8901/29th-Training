#include "defines.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Sets up the initial state of the round management system. Configures
 * scoreboard blocking during active rounds, wires up final checks for
 * player invulnerability and the silent weapon bug, ensures the
 * countdown UI layer exists, and deletes disconnecting player
 * bodies when the round is not live.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_round_fnc_init;
 */

/* ---- Server-side initialization ---- */
if (isServer) then {
    GVAR(state) = 0;
    publicVariable QGVAR(state);

    GVAR(sideReady) = [false, false, false];
    publicVariable QGVAR(sideReady);

    GVAR(timerLength) = DEFAULT_TIMER;
    publicVariable QGVAR(timerLength);

    GVAR(ignoreReadiness) = false;
    publicVariable QGVAR(ignoreReadiness);

    /* --- Prevent scores showing up on right side UI --- */
    [
        QGVAR(started), {
            if !(GVARMAIN(disableScoreboard)) exitWith {};

            {
                _x addScoreSide -SCORE_REDUCE_VALUE;
            } forEach [west, east, independent];
        }
    ] call CBA_fnc_addEventHandler;

    [
        QGVAR(ended), {
            if !(GVARMAIN(disableScoreboard)) exitWith {};
                        
            {
                _x addScoreSide SCORE_REDUCE_VALUE;
            } forEach [west, east, independent];
        }
    ] call CBA_fnc_addEventHandler;

    //Delete disconnecting bodies when not LIVE
    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];

        if (isNull _unit) exitWith {};

        if (NOT_ROUND_LIVE) then {
            deleteVehicle _unit;
        };

        false
    }];
};

#define SHOW_UI ("RscMPProgress" call BIS_fnc_rscLayer) cutRsc ["RscMPProgress", "plain"]

/* ---- Client-side initialization ---- */
if (hasInterface) then {
    call FUNC(initReadyUI);

    /* --- JIP scoreboard suppression ---
     * showScoreTable silently fails if called too early. */
    [{PRELOAD_FINISHED}, {
        if (
            ROUND_LIVE && GVARMAIN(disableScoreboard)
        ) then {
            showScoretable 0;
        };
    }] call CBA_fnc_waitUntilAndExecute;

    /* --- Prevent scoreboard in respawn menu --- */
    [
        QGVAR(scoreboardRespawnMenuStart),
        "Killed", {
            GVAR(disableRespawnScoreboard) = addMissionEventHandler [
                "Draw2D", {
                    if (
                        visibleScoretable
                        && ROUND_LIVE
                        && GVARMAIN(disableScoreboard)
                    ) then {
                        showScoretable 0;
                    };
                }
            ];
        }
    ] call CBA_fnc_addBISPlayerEventHandler;

    // Re-added every life
    [
        QGVAR(scoreboardRespawnMenuEnd),
        "Respawn", {
            if (
                ROUND_LIVE
                && GVARMAIN(disableScoreboard)
            ) then {
                [{shownScoreTable isEqualTo -1}, {
                    showScoretable 0;
                }] call CBA_fnc_waitUntilAndExecute;
            };
            if (!isNil QGVAR(disableRespawnScoreboard)) then {
                removeMissionEventHandler ["Draw2D", GVAR(disableRespawnScoreboard)];
                GVAR(disableRespawnScoreboard) = nil;
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;

    /* --- Fix countdown not showing if no sectors placed --- */
    [{!isNull (findDisplay 46)}, { SHOW_UI }] call CBA_fnc_waitUntilAndExecute;

    /* --- Fix countdown not showing after leaving curator --- */
    [
        QGVARMAIN(exitedZeus), {
            [{ SHOW_UI }, [], 0.1] call CBA_fnc_waitAndExecute;
        }
    ] call CBA_fnc_addEventHandler;

    /* --- Allow player in Zeus to see scoreboard --- */
    [
        QGVARMAIN(enteredZeus),
        {showScoretable -1}
    ] call CBA_fnc_addEventHandler;

    [
        QGVARMAIN(exitedZeus), {
            if (
                ROUND_LIVE
                && GVARMAIN(disableScoreboard)
            ) then {
                showScoretable 0;
            };
        }
    ] call CBA_fnc_addEventHandler;

    /* --- Hide scoreboard when round starts --- */
    [
        QGVAR(started), {
            if !(GVARMAIN(disableScoreboard)) exitWith {};
            if !(isNull (uiNamespace getVariable ["RscDisplayCurator", displayNull])) exitWith {};
            if (
                EGVAR(spectator,active)
                && GVARMAIN(limitSpectator) isEqualTo 0
            ) exitWith {};
            showScoretable 0;
        }
    ] call CBA_fnc_addEventHandler;

    [
        QEGVAR(spectator,exited), {
            if (
                ROUND_LIVE
                && GVARMAIN(disableScoreboard)
            ) then {
                showScoretable 0;
            };
        }
    ] call CBA_fnc_addEventHandler;

    [
        QEGVAR(spectator,entered), {
            if (GVARMAIN(limitSpectator) isEqualTo 0) then {
                showScoretable -1;
            };
        }
    ] call CBA_fnc_addEventHandler;

    [
        QGVAR(ended), {
            showScoretable -1;
        }
    ] call CBA_fnc_addEventHandler;
};

/* ---- Final Checks ---- */
if (isServer) then {
    /* --- Collect client-side silent weapons and notify --- */
    [
        QGVAR(started), {
            GVAR(clientSilentWeapons) = nil;

            [{
                if (isNil QGVAR(clientSilentWeapons)) exitWith {};

                private _msg = format [
                    "%1 has silent weapon. Drop and pickup your weapon.",
                    keys GVAR(clientSilentWeapons)
                ];
                diag_log text _msg;
                [_msg] remoteExecCall ["systemChat"];

                GVAR(clientSilentWeapons) = nil;
            }, [], 3] call CBA_fnc_waitAndExecute;
        }
    ] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    /* --- Fix invulnerable players at round start --- */
    [
        QGVAR(started), {
            if (
                isDamageAllowed player
                || isObjectHidden player
            ) exitWith {};

            player allowDamage true;

            if (GVARMAIN(notifyFinalCheck)) then {
                private _msg = format [
                    "FIXED: %1 was invulnerable, can now take damage.",
                    name player
                ];
                [_msg] remoteExecCall ["systemChat"];
            };
        }
    ] call CBA_fnc_addEventHandler;

    /* --- Detect silent weapon bug --- */
    [
        QGVAR(started), {
            if !(GVARMAIN(notifyFinalCheck)) exitWith {};

            [{
                private _players = allPlayers - entities "HeadlessClient_F";
                _players = _players select {alive _x};

                {
                    if !(
                        currentWeapon _x isEqualTo "Throw"
                        || currentWeapon _x isEqualTo "Put"
                    ) then {
                        continue;
                    };
                    [name _x] remoteExecCall [QFUNC(collectSilentWeapons), 2];
                } forEach _players;
            }, [], 0.5] call CBA_fnc_waitAndExecute;
        }
    ] call CBA_fnc_addEventHandler;
};

nil
