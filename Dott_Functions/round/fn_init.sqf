#include "defines.hpp"

/**
 * Function: TN_round_fnc_init
 * Author:   Bae [29th ID], modified from Dott [29th ID]
 *
 * Sets up the initial state of the round management system. Configures
 * scoreboard blocking during active rounds, wires up final checks for
 * player invulnerability and the silent weapon bug, and ensures the
 * countdown UI layer exists.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Boolean - true
 *
 * Example:
 *     call TN_round_fnc_init;
 */

/* ---- Server-side initialization ---- */
if (isServer) then
{
    TN_round_safeStartActive = false;
    publicVariable "TN_round_safeStartActive";

    TN_round_sideReady = [false, false, false];
    publicVariable "TN_round_sideReady";

    TN_round_timerLength = DEFAULT_TIMER;
    publicVariable "TN_round_timerLength";

    TN_round_overtimeEnabled = false;
    publicVariable "TN_round_overtimeEnabled";

    TN_round_overtimePeriod = DEFAULT_OVERTIME;
    publicVariable "TN_round_overtimePeriod";

    TN_round_ignoreReadiness = false;
    publicVariable "TN_round_ignoreReadiness";

    /* --- Prevent scores showing up on right side UI --- */
    [
        "TN_round_started",
        {
            {
                _x addScoreSide -SCORE_REDUCE_VALUE;
            } forEach [west, east, independent];
        }
    ] call CBA_fnc_addEventHandler;

    [
        "TN_round_ended",
        {
            {
                _x addScoreSide SCORE_REDUCE_VALUE;
            } forEach [west, east, independent];
        }
    ] call CBA_fnc_addEventHandler;
};

/* ---- Client-side initialization ---- */
if (hasInterface) then
{
    call TN_round_fnc_initReadyUI;

    /* --- JIP scoreboard suppression ---
     * showScoreTable silently fails if called too early. */
    addMissionEventHandler [
        "PreloadFinished",
        {
            if (
                call TN_round_fnc_isRoundActive
                && TN_disableScoreboard
            ) then
            {
                showScoretable 0;
            };
            removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
        }
    ];

    /* --- Prevent scoreboard in respawn menu --- */
    [
        "TN_round_scoreboardRespawnMenuStart",
        "Killed",
        {
            disableRespawnScoreboard = addMissionEventHandler [
                "Draw2D",
                {
                    if (
                        visibleScoretable
                        && call TN_round_fnc_isRoundActive
                        && TN_disableScoreboard
                    ) then
                    {
                        showScoretable 0;
                    };
                }
            ];
        }
    ] call CBA_fnc_addBISPlayerEventHandler;

    // Re-added every life
    [
        "TN_round_scoreboardRespawnMenuEnd",
        "Respawn",
        {
            if (
                call TN_round_fnc_isRoundActive
                && TN_disableScoreboard
            ) then
            {
                [] spawn
                {
                    waitUntil {shownScoreTable == -1};
                    showScoretable 0;
                };
            };
            removeMissionEventHandler ["Draw2D", disableRespawnScoreboard];
        }
    ] call CBA_fnc_addBISPlayerEventHandler;

    /* --- Fix countdown not showing if no sectors placed --- */
    [] spawn
    {
        waitUntil {!isNull (findDisplay 46)};
        ("RscMPProgress" call BIS_fnc_rscLayer)
            cutRsc ["RscMPProgress", "plain"];
    };

    /* --- Fix countdown not showing after leaving curator --- */
    [
        "TN_exitedZeus",
        {
            [] spawn
            {
                sleep 0.1;
                ("RscMPProgress" call BIS_fnc_rscLayer)
                    cutRsc ["RscMPProgress", "plain"];
            };
        }
    ] call CBA_fnc_addEventHandler;

    /* --- Allow player in Zeus to see scoreboard --- */
    [
        "TN_enteredZeus",
        {showScoretable -1}
    ] call CBA_fnc_addEventHandler;

    [
        "TN_exitedZeus",
        {
            if (
                call TN_round_fnc_isRoundActive
                && TN_disableScoreboard
            ) then
            {
                showScoretable 0;
            };
        }
    ] call CBA_fnc_addEventHandler;

    /* --- Hide scoreboard when round starts --- */
    [
        "TN_round_started",
        {
            if !(TN_disableScoreboard) exitWith {};
            if !(isNull (uiNamespace getVariable ["RscDisplayCurator", displayNull])) exitWith {};
            if (
                !isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}
                && TN_limitSpectator == 0
            ) exitWith {};
            showScoretable 0;
        }
    ] call CBA_fnc_addEventHandler;

    [
        "exitedSpectator",
        {
            if (
                call TN_round_fnc_isRoundActive
                && TN_disableScoreboard
            ) then
            {
                showScoretable 0;
            };
        }
    ] call CBA_fnc_addEventHandler;

    [
        "enteredSpectator",
        {
            if (TN_limitSpectator == 0) then
            {
                showScoretable -1;
            };
        }
    ] call CBA_fnc_addEventHandler;

    [
        "TN_round_ended",
        {
            showScoretable -1;
        }
    ] call CBA_fnc_addEventHandler;
};

/* ---- Final Checks ---- */
if (isServer) then
{
    /* --- Collect client-side silent weapons and notify --- */
    [
        "TN_round_started",
        {
            TN_round_clientSilentWeapons = nil;

            [] spawn
            {
                sleep 3;
                if (isNil "TN_round_clientSilentWeapons")
                    exitWith {};

                private _msg = format [
                    "%1 has silent weapon.",
                    keys TN_round_clientSilentWeapons
                ];
                diag_log _msg;
                [_msg] remoteExecCall ["systemChat"];

                TN_round_clientSilentWeapons = nil;
            };
        }
    ] call CBA_fnc_addEventHandler;
};

if (hasInterface) then
{
    /* --- Fix invulnerable players at round start --- */
    [
        "TN_round_started",
        {
            if (
                isDamageAllowed player
                || isObjectHidden player
            ) exitWith {};

            player allowDamage true;

            if (TN_notifyFinalCheck) then
            {
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
        "TN_round_started",
        {
            if !(TN_notifyFinalCheck) exitWith {};

            [] spawn
            {
                sleep 0.5;
                private _players = allPlayers - entities "HeadlessClient_F";
                _players = _players select {alive _x};

                {
                    if !(
                        currentWeapon _x == "Throw"
                        || currentWeapon _x == "Put"
                    ) then
                    {
                        continue;
                    };
                    [name _x] remoteExecCall ["TN_round_fnc_collectSilentWeapons", 2];
                } forEach _players;
            };
        }
    ] call CBA_fnc_addEventHandler;
};

true
