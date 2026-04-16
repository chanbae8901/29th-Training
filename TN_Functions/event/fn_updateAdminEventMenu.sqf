#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Adds or removes the Event Menu self-action on the local
 * player based on admin login/logout state.
 *
 * Arguments:
 * 0: Admin logged in <BOOL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [true] call TN_event_fnc_updateAdminEventMenu;
 */

params ["_loggedIn"];

if (_loggedIn) exitWith {
    if (!isNil QGVAR(adminMenuActionId)) exitWith {};

    GVAR(adminMenuActionId) = player addAction [
        "<t color='#bf3eff'>"
            + "Event Menu (Admin)</t>",
        FUNC(gui_eventMenu),
        nil,
        1.5, false, true, "",
        "",
        50
    ];
};

// logging out
if (!isNil QGVAR(adminMenuActionId)) then {
    player removeAction GVAR(adminMenuActionId);
    GVAR(adminMenuActionId) = nil;
};

nil
