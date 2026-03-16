#include "..\..\data\settingCategories.hpp"

private _defaultNoLog = "['commands', 'help', 'showchat', 'radio', 'fb']";
private _defaultRestrictedCommands = "['arsenal', 'heal', 'rearm', 'cleanup', 'fb']";
private _defaultAdminCommands = "['reset', 'debrief', 'goto', 'measure', 'tickets', 'parade', 's', 'safe']";

[
    "TN_noLogCommands", 
    "EDITBOX", 
    ["Unlogged Commands", "Commands listed here will not be logged to diary or server log. Use single quotes."],
    COMMAND_SETTINGS_CATEGORY,
    _defaultNoLog,
	1,
	{
		TN_commands_noLogCommands = parseSimpleArray _this;
	}
] call CBA_fnc_addSetting;

[
	"TN_restrictedCommands", 
	"EDITBOX", 
	["Restricted Commands", "Commands listed here will only be usable outside of rounds unless admin. Use single quotes."],
	COMMAND_SETTINGS_CATEGORY,
	_defaultRestrictedCommands,
	1,
	{
		TN_commands_restrictedCommands = parseSimpleArray _this;
	}
] call CBA_fnc_addSetting;

[
	"TN_adminCommands", 
	"EDITBOX", 
	["Admin Commands", "Commands listed here will only be usable by server admins. Use single quotes."],
	COMMAND_SETTINGS_CATEGORY,
	_defaultAdminCommands,
	1,
	{
		TN_commands_adminCommands = parseSimpleArray _this;
	}
] call CBA_fnc_addSetting;

[
	"TN_removedCommands", 
	"EDITBOX", 
	["Removed Commands", "Commands listed here will not be able to be used by anyone. Use single quotes."],
	COMMAND_SETTINGS_CATEGORY,
	"[]",
	1,
	{
		TN_commands_removedCommands = parseSimpleArray _this;
	}
] call CBA_fnc_addSetting;
