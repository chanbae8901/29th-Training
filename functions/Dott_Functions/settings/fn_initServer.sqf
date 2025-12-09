#define DEFAULT_INDEX 0
#define MISSION_ADDON "dott"
if (isServer) then
{
	if (isNil "DOTT_settings_allSettings") then {DOTT_settings_allSettings = []};

	missionNamespace setVariable ["DOTT_settings_default", true call CBA_fnc_createNamespace, true];

	private _missionAddonStrLen = count MISSION_ADDON;
	{
		if (_x select [0,_missionAddonStrLen] != MISSION_ADDON) then {continue};

		private _setting = (cba_settings_default getVariable _x);
		_setting set [DEFAULT_INDEX, [_x, "server"] call CBA_settings_fnc_get];
		DOTT_settings_default setVariable [_x, _setting, true];
		DOTT_settings_allSettings pushBack _x;
	}
	forEach cba_settings_allSettings;
};

if (hasInterface) then
{
	{
		private _scriptName = format ["DOTT_settings_fnc_%1", _x];
		if (isNil {uiNamespace getVariable _scriptName}) then {
			private _filePath = format ["functions\Dott_Functions\settings\fn_%1.sqf", _x];
			uiNamespace setVariable [_scriptName, compile preprocessFile _filePath];
		};
	}
	forEach ["gui_settingCheckbox", "gui_settingSlider", "gui_settingList"];

	{
		private _scriptName = format ["DOTT_settings_fnc_%1", _x];
		if (isNil {missionNamespace getVariable _scriptName}) then {
			private _filePath = format ["functions\Dott_Functions\settings\fn_%1.sqf", _x];
			missionNamespace setVariable [_scriptName, compile preprocessFile _filePath];
		};
	}
	forEach ["gui_settingDefault","gui_sourceChanged", "gui_addonChanged","gui_saveTempData"];
};