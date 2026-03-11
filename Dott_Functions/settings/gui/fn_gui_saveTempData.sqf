/**
 * fn_gui_saveTempData.sqf
 * Applies every pending setting override stored in the
 * temporary namespace back into CBA's live settings.
 * Called when the user clicks OK in the settings dialog.
 *
 * Params: none (reads globals directly)
 * Return: nil
 */

#define SERVER_TEMP \
    (uiNamespace getVariable "DOTT_settings_serverTemp")

{
    private _setting = _x;
    private _source = "server";

    if (!isNil {SERVER_TEMP getVariable _setting}) then
    {
        (SERVER_TEMP getVariable _setting) params [
            "_value", "_priority"
        ];

        if (isNil "_value") then
        {
            _value = [_setting, _source]
                call cba_settings_fnc_get;
        };

        if (isNil "_priority") then
        {
            _priority = [_setting, _source]
                call cba_settings_fnc_priority;
        };

        [_setting, _value, _priority, _source, false]
            call cba_settings_fnc_set;
    };
} forEach DOTT_settings_allSettings;

nil
