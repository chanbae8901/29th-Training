#include "script_component.hpp"
#include "..\..\data\templates.hpp"

/*
 * Author: Bae [29th ID]
 * Initializes the chat command system on the client.
 * Compiles and executes each module's commands.sqf to
 * populate the global command and help arrays, then
 * converts them to HashMaps for O(1) lookups. Uses a
 * per-frame handler to detect when the chat display opens
 * and adds a KeyDown handler that intercepts messages
 * beginning with the command marker ("!"), closes the chat
 * to prevent sending, and routes them to fn_execute.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_commands_fnc_init;
 */

#define COMMAND_MARKER "!"

if (hasInterface) then
{

    #include "commands.sqf"

    // Load each module's commands.sqf if it exists.
    {
        private _commandsFile = format ["TN_Functions\%1\commands.sqf", _x];
        if !(fileExists _commandsFile) then { continue };

        call compile preprocessFileLineNumbers _commandsFile;
    }
    forEach (TN_MODULES - ["commands"]);

    // Convert flat arrays to HashMaps for fast lookup after all module inits complete.
    [QGVARMAIN(initFinished), {
        GVAR(allCommands) = createHashMapFromArray GVAR(allCommands);
        GVAR(helpInfo) = createHashMapFromArray GVAR(helpInfo);
    }] call CBA_fnc_addEventHandler;

    GVAR(chatOpen) = false;

    [{
        private _display = findDisplay 24;

        if (isNull _display) then {
            GVAR(chatOpen) = false;
        } else {
            if (!GVAR(chatOpen)) then {
                GVAR(chatOpen) = true;

                _display displayAddEventHandler ["KeyDown", {
                    params ["_display", "_key"];

                    // 28 = Enter, 156 = Numpad Enter
                    if (_key isNotEqualTo 28 && _key isNotEqualTo 156) exitWith { false };

                    private _text = ctrlText (_display displayCtrl 101);

                    if (_text isEqualTo "") exitWith { false };
                    if ((_text select [0, 1]) isNotEqualTo COMMAND_MARKER) exitWith { false };

                    closeDialog 0;
                    _display closeDisplay 1;

                    [_text] call FUNC(execute);

                    true
                }];
            };
        };
    }, 0] call CBA_fnc_addPerFrameHandler;
};

/* --- Compile command subfolder functions (not in CfgFunctions) --- */

if (hasInterface) then {
    FUNC(arsenalCreate) = compileFinal preprocessFileLineNumbers
        "TN_Functions\commands\arsenal\fn_create.sqf";
};

if (isServer) then {
    FUNC(arsenalRegister) = compileFinal preprocessFileLineNumbers
        "TN_Functions\commands\arsenal\fn_register.sqf";
};

nil
