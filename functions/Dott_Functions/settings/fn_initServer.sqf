#define DEFAULT_INDEX 0
#define MISSION_ADDON "tn"
if (isServer) then
{
	missionNamespace setVariable ["DOTT_settings_default", true call CBA_fnc_createNamespace, true];
	DOTT_settings_allSettings = [];

	private _missionAddonStrLen = count MISSION_ADDON;
	
	{
		if (_x select [0,_missionAddonStrLen] != MISSION_ADDON) then {continue};
		
		//replace default with server initial setting
		private _setting = (cba_settings_default getVariable _x);
		_setting set [DEFAULT_INDEX, [_x, "server"] call CBA_settings_fnc_get];
		DOTT_settings_default setVariable [_x, _setting, true];

		DOTT_settings_allSettings pushBack _x;
	}
	forEach cba_settings_allSettings;

	publicVariable "DOTT_settings_allSettings";
};