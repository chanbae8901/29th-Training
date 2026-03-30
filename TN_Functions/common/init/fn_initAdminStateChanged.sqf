#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Registers a single OnUserAdminStateChanged mission event
 * handler that extracts the admin unit and fires a CBA event
 * ("TN_common_adminStateChanged") for all consumer modules.
 *
 * Consumers subscribe via:
 *     ["TN_common_adminStateChanged", { params ["_unit", "_loggedIn"]; ... }]
 *         call CBA_fnc_addEventHandler;
 *
 * _unit may be objNull if user info was unavailable.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_common_fnc_initAdminStateChanged;
 */

addMissionEventHandler [
    "OnUserAdminStateChanged", {
    params ["_networkId", "_loggedIn"];

    private _userInfo = getUserInfo _networkId;
    private _unit = if (count _userInfo > 10) then
        { _userInfo select 10 } else { objNull };

    [QGVAR(adminStateChanged), [_unit, _loggedIn]] call CBA_fnc_localEvent;
}];
