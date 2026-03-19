#include "readyui\readyui_defines.hpp"
#include "..\..\data\roundState.hpp"

/*
 * Author: PFC Wells [29th ID] being nagged at by Bae [29th ID]
 * Creates a top-right HUD overlay showing team ready status during safe start.
 * Anchored to the vanilla MP HUD position (IGUI_GRID_MP layout editor slot) so
 * it sits beside the scoreboard / mission-status area and respects the player's
 * UI layout preferences. Resolution-adaptive via aspect-ratio grid (GRID_W/H).
 *
 * Panel visibility logic:
 *   Shown  -- safe start is active OR at least one team is ready
 *   Hidden -- round goes live, or neither condition is met
 *   Event-driven PFH lifecycle: the update loop only runs when the panel is
 *   needed. CBA event handlers start/stop the PFH externally -- it never
 *   removes itself. Start triggers: safeStartBegin, manageReadyChange (ready).
 *   Stop triggers: round_started (unconditional), manageReadyChange (unready,
 *   when no teams ready + no safe start), safeStartAborted (no teams ready).
 *   Zeus-aware: controls migrate between display 46 (game) and display 312
 *   (Curator) automatically so the overlay stays visible inside Zeus.
 *
 * Client-side only.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_round_fnc_initReadyUI;
 */

if (!hasInterface) exitWith {};

// Returns whichever display is on top — Zeus (312) if open, otherwise game (46).
// Controls must live on the topmost display or they render behind it.
TN_round_fnc_getActiveDisplay =
{
    private _zeus = findDisplay 312;
    if (!isNull _zeus) exitWith {_zeus};
    findDisplay 46
};

// Starts the update PFH if it isn't already running.
// Called from event handlers when conditions might require the panel.
TN_round_fnc_startReadyUIPFH =
{
    if !(isNil "TN_readyUI_pfhHandle") exitWith {};
    TN_readyUI_dirty = true;
    TN_readyUI_refreshCounter = 0;
    TN_readyUI_pfhHandle = [
        {call TN_round_fnc_updateReadyUI}, 0
    ] call CBA_fnc_addPerFrameHandler;
};

// Wait for game display, then wire event-driven PFH lifecycle
[
    {!isNull findDisplay 46},
    {
        call TN_round_fnc_createReadyUIControls;

        // Only start PFH at init if UI is actually needed right now (JIP into safe start, etc.)
        if (
            ROUND_SAFE
            || {
                !(isNil "TN_round_sideReady")
                && {true in TN_round_sideReady}
            }
        ) then
        {
            call TN_round_fnc_startReadyUIPFH;
        };

        // --- Event handlers drive PFH lifecycle ---

        // Safe start begins -> wake PFH so panel appears
        TN_readyUI_ehSafeStart = [
            "TN_round_safeStartBegin",
            {
                TN_readyUI_dirty = true;
                call TN_round_fnc_startReadyUIPFH;
            }
        ] call CBA_fnc_addEventHandler;

        // Ready state changes -> wake PFH, flash on ready, stop if nothing to show
        TN_readyUI_ehReady = [
            "TN_round_manageReadyChange",
            {
                params ["_side", "_isReady"];
                TN_readyUI_dirty = true;
                call TN_round_fnc_startReadyUIPFH;
                if (_isReady) then
                {
                    // Find flash color for the team that just readied (index 5 in SIDE_DEFS)
                    private _flashColor = [
                        0.91, 0.78, 0.25, 0.8
                    ];
                    {
                        if (
                            (_x select 0) isEqualTo _side
                        ) exitWith
                        {
                            _flashColor = _x select 5;
                        };
                    } forEach SIDE_DEFS;
                    [_flashColor]
                        call TN_round_fnc_flashReadyUI;
                }
                else
                {
                    // Team unreadied — if no teams ready and no safe start, stop PFH
                    if (
                        !(isNil "TN_round_sideReady")
                        && {
                            !(true in TN_round_sideReady)
                        }
                        && NOT_ROUND_SAFE
                    ) then
                    {
                        call TN_round_fnc_stopReadyUIPFH;
                    };
                };
            }
        ] call CBA_fnc_addEventHandler;

        // Safe start aborted -> stop PFH if no teams are still ready
        TN_readyUI_ehAborted = [
            "TN_round_safeStartAborted",
            {
                TN_readyUI_dirty = true;
                if (
                    !(isNil "TN_round_sideReady")
                    && {true in TN_round_sideReady}
                ) then
                {
                    // Teams still ready — keep PFH alive to show their status
                }
                else
                {
                    call TN_round_fnc_stopReadyUIPFH;
                };
            }
        ] call CBA_fnc_addEventHandler;

        // Round started -> unconditionally stop PFH (fn_start.sqf already unreadies all sides)
        TN_readyUI_ehStarted = [
            "TN_round_started",
            {
                call TN_round_fnc_stopReadyUIPFH;
            }
        ] call CBA_fnc_addEventHandler;
    }
] call CBA_fnc_waitUntilAndExecute;

nil
