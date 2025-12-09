{
    private _setting = _x;


    private _source = "server";

    if (!isNil {uiNamespace getVariable "DOTT_settings_serverTemp" getVariable _setting}) then {
        (uiNamespace getVariable "DOTT_settings_serverTemp" getVariable _setting) params ["_value", "_priority"];

        if (isNil "_value") then {
            _value = [_setting, _source] call cba_settings_fnc_get;
        };

        if (isNil "_priority") then {
            _priority = [_setting, _source] call cba_settings_fnc_priority;
        };

        [_setting, _value, _priority, _source, false] call cba_settings_fnc_set;
    };

} forEach DOTT_settings_allSettings;

nil
