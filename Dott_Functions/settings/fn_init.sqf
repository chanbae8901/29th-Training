/**
 * fn_init.sqf
 * Server-side initialization for the DOTT settings system.
 * Snapshots each CBA mission setting's server value as the
 * "default" baseline and builds the global settings list.
 *
 * Params: none
 * Return: none
 */

#define MISSION_ADDON "tn"

if (isServer) then
{
    missionNamespace setVariable [
        "DOTT_settings_default",
        true call CBA_fnc_createNamespace,
        true
    ];
    DOTT_settings_allSettings = [];

    private _missionAddonStrLen = count MISSION_ADDON;

    private _excludeList = [
        "noLogCommands",
        "restrictedCommands",
        "adminCommands",
        "removedCommands"
    ];

    {
        if (_x select [0, _missionAddonStrLen]
            != MISSION_ADDON) then
        {
            continue;
        };

        if (_excludeList find (
            _x select [_missionAddonStrLen + 1]
        ) != -1) then
        {
            continue;
        };

        //replace default with server initial setting
        private _setting =
            cba_settings_default getVariable _x;
        _setting set [
            0,
            [_x, "server"] call CBA_settings_fnc_get
        ];
        DOTT_settings_default setVariable [
            _x, _setting, true
        ];

        DOTT_settings_allSettings pushBack _x;
    }
    forEach cba_settings_allSettings;

    publicVariable "DOTT_settings_allSettings";
};
