/*
 * Author: Bae [29th ID]
 * Initializes the curator (Zeus) system for both clients
 * and the server. On the client side, registers death
 * marker drawing, Zeus enter/exit event logging, adds the
 * player as editable, and requests a curator module. On
 * the server side, ensures TN_curator_units exists,
 * merges any editor-placed curator modules into the unit
 * list, creates the admin curator module, and sets up
 * admin login/logout handlers that reassign the shared
 * zeus_admin module. Also starts the object exclusion
 * perFrameHandler.
 *
 * Events Used:
 *     TN_enteredZeus - Fired by cfgEventHandlers when a
 *         player opens the Zeus interface. Logged to server.
 *     TN_exitedZeus  - Fired when a player closes Zeus.
 *
 * Admin Login/Logout Handler:
 *     OnUserAdminStateChanged mission event handler manages
 *     the shared zeus_admin curator module. On login, the
 *     admin unit is assigned to zeus_admin (unassign first to
 *     handle edge cases). On logout, zeus_admin is unassigned
 *     and a personal curator module is recreated for the unit
 *     so they keep Zeus access if their role is in
 *     TN_curator_units.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_curator_fnc_init;
 */

//Note: Events TN_enteredZeus and TN_exitedZeus are defined in cfgEventHandlers

#define CREATE_CURATOR_MODULE(_obj) \
    [vehicleVarName _obj] call TN_curator_fnc_createModule

if (hasInterface) then
{
    [{!isNull player}, {
        //Draw little skulls each time a player dies. Seen only by Zeus.
        player call BIS_fnc_drawCuratorDeaths;

        [
            "TN_enteredZeus",
            {
                private _curatorName = name player;
                private _msg = format ["CURATOR INTERFACE OPENED: %1", _curatorName];
                _msg remoteExecCall ["TN_common_fnc_diag_log", 2];
            }
        ] call CBA_fnc_addEventHandler;

        [[player]] remoteExecCall ["TN_curator_fnc_addEditable", 2];

        [vehicleVarName player] remoteExecCall ["TN_curator_fnc_createModule", 2];
    }] call CBA_fnc_waitUntilAndExecute;
};

if (isServer) then
{
    if (isNil "TN_curator_units") then //in case curator units aren't defined for some reason
    {
        TN_curator_units = ["#adminLogged"];
    };

    //add curator modules that exist in sqm to unit list to fix Zeus not working for JIP players until they die or respawn (primarily for event template)
    {
        private _owner = _x getVariable "owner";
        TN_curator_units pushBackUnique _owner;
    }
    forEach (allMissionObjects "ModuleCurator_F");

    //in case zeus_admin is in mission.sqm for some reason, I guess hope mission maker set it to this variable name
    //TODO: Check if #adminLogged owner curator module exists and assign zeus_admin to that instead of assuming above
    if (isNil "zeus_admin") then
    {
        [
            { time > 0 },
            {
                zeus_admin = ["#adminLogged"] call TN_curator_fnc_createModule;
            }
        ] call CBA_fnc_waitUntilAndExecute;
    };

    [{!isNil "zeus_admin" || time > 10}, {
        //failsafe if zeus_admin isn't defined by now
        if (time > 10) exitWith
        {
            diag_log text format ["zeus_admin not defined, skipping event handlers"];
        };

        addMissionEventHandler ["OnUserAdminStateChanged",
            { call TN_curator_fnc_handleAdminStateChanged }];
    }] call CBA_fnc_waitUntilAndExecute;

    call TN_curator_fnc_excludeObjects;
};

nil
