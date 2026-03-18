/*
 * Author: Bae [29th ID]
 * Handles the OnUserAdminStateChanged mission event.
 * On login, assigns the admin to zeus_admin curator module.
 * On logout, unassigns zeus_admin and recreates a personal
 * curator module if their role is in TN_curator_units.
 *
 * Arguments:
 * OnUserAdminStateChanged EH params
 *
 * Return Value:
 * Nothing
 */

params ["_networkId", "_loggedIn"];

private _userInfo = getUserInfo _networkId;
if (count _userInfo < 11) exitWith {};

private _unit = _userInfo select 10;
if (isNil "_unit") exitWith {};

if (_loggedIn) exitWith
{
    if (isNull getAssignedCuratorLogic _unit) then
    {
        unassignCurator zeus_admin;
        [{
            _this assignCurator zeus_admin;
        }, _unit, 0.1] call CBA_fnc_waitAndExecute;
    };
};

//logging out
if (getAssignedCuratorLogic _unit == zeus_admin) then
{
    unassignCurator zeus_admin;
    [{
        [vehicleVarName _this, roleDescription _this]
            call TN_curator_fnc_createModule;
    }, _unit, 0.1] call CBA_fnc_waitAndExecute;
};
