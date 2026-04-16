#include "script_component.hpp"
#include "readyui_defines.hpp"

/*
 * Author: Wells [29th ID]
 * Handles a team ready/unready change for the ready UI panel.
 * Wakes the update PFH, triggers a flash on ready, and stops
 * the PFH when nothing needs to be shown.
 *
 * Arguments:
 * 0: Side that changed <SIDE>
 * 1: Whether the side is now ready <BOOL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [west, true] call TN_round_fnc_onReadyChange;
 */

params ["_side", "_isReady"];
GVAR(readyUI_dirty) = true;
call FUNC(startReadyUIPFH);
if (_isReady) then {
    // Find flash color for the team that just readied (index 5 in SIDE_DEFS)
    private _flashColor = [
        0.91, 0.78, 0.25, 0.8
    ];
    {
        if (
            (_x select 0) isEqualTo _side
        ) exitWith {
            _flashColor = _x select 5;
        };
    } forEach SIDE_DEFS;
    [_flashColor] call FUNC(flashReadyUI);
} else {
    // Team unreadied — if no teams ready and no safe start, stop PFH
    if (
        !(isNil QGVAR(sideReady))
        && {
            !(true in GVAR(sideReady))
        }
        && NOT_ROUND_SAFE
    ) then {
        call FUNC(stopReadyUIPFH);
    };
};

nil
