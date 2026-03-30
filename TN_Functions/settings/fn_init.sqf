/*
 * Author: Bae [29th ID]
 * Server-side initialization for the TN settings system.
 * Snapshots each CBA mission setting's server value as the
 * "default" baseline and builds the global settings list,
 * skipping any non-global settings.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call TN_settings_fnc_init
 */

#include "script_component.hpp"

#define MISSION_ADDON "tn"

if (isServer) then {
    missionNamespace setVariable [
        QGVAR(default),
        true call CBA_fnc_createNamespace,
        true
    ];
    GVAR(allSettings) = [];

    private _missionAddonStrLen = count MISSION_ADDON;

    private _excludeList = [
        "noLogCommands",
        "restrictedCommands",
        "adminCommands",
        "removedCommands"
    ];

    {
        if (_x select [0, _missionAddonStrLen]
            != MISSION_ADDON) then {
            continue;
        };

        if ((_x select [_missionAddonStrLen + 1])
            in _excludeList) then {
            continue;
        };

        private _setting = cba_settings_default getVariable _x;

        // skip non-global settings
        if (_setting select 7 != 1) then {
            continue;
        };

        //replace default with server initial setting
        _setting set [
            0,
            [_x, "server"] call CBA_settings_fnc_get
        ];
        GVAR(default) setVariable [_x, _setting, true];

        GVAR(allSettings) pushBack _x;
    }
    forEach cba_settings_allSettings;

    publicVariable QGVAR(allSettings);
};

nil
