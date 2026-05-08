#include "script_component.hpp"
#include "..\..\data\settingCategories.hpp"

private _defaultNoLog = "['commands', 'help', 'showchat', 'radio', 'fb', 'weaponstate']";
private _defaultRestrictedCommands = "['arsenal', 'heal', 'rearm', 'cleanup', 'fb']";
private _defaultAdminCommands = "['reset', 'debrief', 'goto', 'measure', 't', 'parade', 's', 'safe']";

[
    QGVARMAIN(noLogCommands),
    "EDITBOX",
    ["Unlogged Commands", "Commands listed here will not be logged to diary or server log. Use single quotes."],
    COMMAND_SETTINGS_CATEGORY,
    _defaultNoLog,
	1, {
		GVAR(noLogCommands) = parseSimpleArray _this;
	}
] call CBA_fnc_addSetting;

[
	QGVARMAIN(restrictedCommands),
	"EDITBOX",
	["Restricted Commands", "Commands listed here will only be usable outside of rounds unless admin. Use single quotes."],
	COMMAND_SETTINGS_CATEGORY,
	_defaultRestrictedCommands,
	1, {
		GVAR(restrictedCommands) = parseSimpleArray _this;
	}
] call CBA_fnc_addSetting;

[
	QGVARMAIN(adminCommands),
	"EDITBOX",
	["Admin Commands", "Commands listed here will only be usable by server admins. Use single quotes."],
	COMMAND_SETTINGS_CATEGORY,
	_defaultAdminCommands,
	1, {
		GVAR(adminCommands) = parseSimpleArray _this;
	}
] call CBA_fnc_addSetting;

[
	QGVARMAIN(removedCommands),
	"EDITBOX",
	["Removed Commands", "Commands listed here will not be able to be used by anyone. Use single quotes."],
	COMMAND_SETTINGS_CATEGORY,
	"[]",
	1, {
		GVAR(removedCommands) = parseSimpleArray _this;
	}
] call CBA_fnc_addSetting;
