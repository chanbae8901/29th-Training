#include "script_component.hpp"
#include "readyui\readyui_defines.hpp"

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
FUNC(getActiveDisplay) = {
    private _zeus = findDisplay 312;
    if (!isNull _zeus) exitWith {_zeus};
    findDisplay 46
};

// Starts the update PFH if it isn't already running.
// Called from event handlers when conditions might require the panel.
FUNC(startReadyUIPFH) = {
    if !(isNil QGVAR(readyUI_pfhHandle)) exitWith {};
    GVAR(readyUI_dirty) = true;
    GVAR(readyUI_refreshCounter) = 0;
    GVAR(readyUI_pfhHandle) = [
        FUNC(updateReadyUI), 0
    ] call CBA_fnc_addPerFrameHandler;
};

// Wait for game display, then wire event-driven PFH lifecycle
[
    {!isNull findDisplay 46}, {
        call FUNC(createReadyUIControls);

        // Only start PFH at init if UI is actually needed right now (JIP into safe start, etc.)
        if (
            ROUND_SAFE
            || {
                !(isNil QGVAR(sideReady))
                && {true in GVAR(sideReady)}
            }
        ) then {
            call FUNC(startReadyUIPFH);
        };

        // --- Event handlers drive PFH lifecycle ---

        // Safe start begins -> wake PFH so panel appears
        GVAR(readyUI_ehSafeStart) = [
            QGVAR(safeStartBegin), {
                GVAR(readyUI_dirty) = true;
                call FUNC(startReadyUIPFH);
            }
        ] call CBA_fnc_addEventHandler;

        // Ready state changes -> wake PFH, flash on ready, stop if nothing to show
        GVAR(readyUI_ehReady) = [
            QGVAR(manageReadyChange),
            FUNC(handleReadyChange)
        ] call CBA_fnc_addEventHandler;

        // Safe start aborted -> stop PFH if no teams are still ready
        GVAR(readyUI_ehAborted) = [
            QGVAR(safeStartAborted), {
                GVAR(readyUI_dirty) = true;
                if (
                    !(isNil QGVAR(sideReady))
                    && {true in GVAR(sideReady)}
                ) then {
                    // Teams still ready — keep PFH alive to show their status
                } else {
                    call FUNC(stopReadyUIPFH);
                };
            }
        ] call CBA_fnc_addEventHandler;

        // Round started -> unconditionally stop PFH (fn_start.sqf already unreadies all sides)
        GVAR(readyUI_ehStarted) = [
            QGVAR(started),
            FUNC(stopReadyUIPFH)
        ] call CBA_fnc_addEventHandler;
    }
] call CBA_fnc_waitUntilAndExecute;

nil
