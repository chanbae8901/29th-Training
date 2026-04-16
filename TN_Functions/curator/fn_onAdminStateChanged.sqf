#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Handles admin login/logout for the curator system.
 * On login, assigns the admin to zeus_admin curator module.
 * On logout, unassigns zeus_admin and reassigns the unit's
 * personal curator module.
 *
 * Called via CBA event "TN_common_adminStateChanged".
 *
 * Arguments:
 * 0: Admin unit <OBJECT>
 * 1: Logged in <BOOL>
 *
 * Return Value:
 * Nothing
 */

params ["_unit", "_loggedIn"];

if (_loggedIn) exitWith {
    if (isNull getAssignedCuratorLogic _unit) then {
        unassignCurator zeus_admin;
        [{
            _this assignCurator zeus_admin;
        }, _unit, 0.1] call CBA_fnc_waitAndExecute;
    };
};

//logging out
if (getAssignedCuratorLogic _unit isEqualTo zeus_admin) then {
    unassignCurator zeus_admin;
    [{
        [vehicleVarName _this]
            call FUNC(createModule);
    }, _unit, 0.1] call CBA_fnc_waitAndExecute;
};

nil
