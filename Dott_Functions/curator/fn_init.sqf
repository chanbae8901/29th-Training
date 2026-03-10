/*
 * Function: DOTT_curator_fnc_init
 * Author:   Bae [29th ID]
 *
 * Description:
 *     Initializes the curator (Zeus) system for both clients
 *     and the server. On the client side, registers death
 *     marker drawing, Zeus enter/exit event logging, adds the
 *     player as editable, and requests a curator module. On
 *     the server side, ensures DOTT_curator_units exists,
 *     merges any editor-placed curator modules into the unit
 *     list, creates the admin curator module, and sets up
 *     admin login/logout handlers that reassign the shared
 *     zeus_admin module. Also spawns the object exclusion
 *     loop.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Events Used:
 *     DOTT_enteredZeus - Fired by cfgEventHandlers when a
 *         player opens the Zeus interface. Logged to server.
 *     DOTT_exitedZeus  - Fired when a player closes Zeus.
 *
 * Admin Login/Logout Handler:
 *     OnUserAdminStateChanged mission event handler manages
 *     the shared zeus_admin curator module. On login, the
 *     admin unit is assigned to zeus_admin (unassign first to
 *     handle edge cases). On logout, zeus_admin is unassigned
 *     and a personal curator module is recreated for the unit
 *     so they keep Zeus access if their role is in
 *     DOTT_curator_units.
 */

#define CREATE_CURATOR_MODULE(_obj) \
    [vehicleVarName _obj, roleDescription _obj] \
    call DOTT_curator_fnc_createModule

// --- Client-side initialization ---
if (hasInterface) then
{
    [] spawn
    {
        waitUntil { !isNull player };

        // Draw skull markers on the map for each player death.
        player call BIS_fnc_drawCuratorDeaths;

        // Log when local player opens Zeus interface.
        [
            "DOTT_enteredZeus",
            {
                private _curatorName = name player;
                private _msg = format [
                    "CURATOR INTERFACE OPENED: %1",
                    _curatorName
                ];
                _msg remoteExec [
                    "DOTT_common_fnc_diag_log", 2
                ];
            }
        ] call CBA_fnc_addEventHandler;

        [player] remoteExec [
            "DOTT_curator_fnc_addPlayerEditable", 2
        ];

        [
            vehicleVarName player,
            roleDescription player
        ] remoteExecCall [
            "DOTT_curator_fnc_createModule", 2
        ];
    };
};

// --- Server-side initialization ---
if (isServer) then
{
    // Fallback if mission maker forgot to define curator
    // units in description.ext or init.
    if (isNil "DOTT_curator_units") then
    {
        DOTT_curator_units = ["#adminLogged"];
    };

    // Merge editor-placed curator module owners into the
    // unit list so JIP players get Zeus without dying first.
    {
        private _owner = _x getVariable "owner";
        DOTT_curator_units pushBackUnique _owner;
    }
    forEach (allMissionObjects "ModuleCurator_F");

    // Create the shared admin curator module after mission
    // start. Guarded by isNil in case it already exists in
    // mission.sqm.
    // TODO: Detect #adminLogged curator in mission.sqm and
    //       assign zeus_admin to it instead of assuming the
    //       variable name.
    if (isNil "zeus_admin") then
    {
        [
            { time > 0 },
            {
                zeus_admin = [
                    "#adminLogged", "Admin"
                ] call DOTT_curator_fnc_createModule;
            }
        ] call CBA_fnc_waitUntilAndExecute;
    };

    [] spawn
    {
        waitUntil { !isNil "zeus_admin" || time > 10 };

        // Bail if zeus_admin never got created.
        if (time > 10) exitWith
        {
            diag_log
                "zeus_admin not defined, skipping event handlers";
        };

        // --- Admin login/logout handler ---
        addMissionEventHandler [
            "OnUserAdminStateChanged",
            {
                params ["_networkId", "_loggedIn"];

                private _userInfo = getUserInfo _networkId;
                if (count _userInfo < 11) exitWith {};

                private _unit = _userInfo select 10;
                if (isNil "_unit") exitWith {};

                // Admin logged in: assign shared curator.
                if (_loggedIn) exitWith
                {
                    if (isNull getAssignedCuratorLogic _unit) then
                    {
                        [_unit] spawn
                        {
                            params ["_unit"];
                            unassignCurator zeus_admin;
                            sleep 0.1;
                            _unit assignCurator zeus_admin;
                        };
                    };
                };

                // Admin logged out: revoke shared curator and
                // recreate personal module.
                [_unit] spawn
                {
                    params ["_unit"];
                    if (getAssignedCuratorLogic _unit == zeus_admin) then
                    {
                        [_unit] spawn
                        {
                            params ["_unit"];
                            unassignCurator zeus_admin;
                            sleep 0.1;
                            isNil {
                                CREATE_CURATOR_MODULE(_unit);
                            };
                        };
                    };
                };
            }
        ];
    };

    [] spawn DOTT_curator_fnc_excludeObjects;
};
