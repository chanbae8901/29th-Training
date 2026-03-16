#include "..\..\data\defines.hpp"

/*
 * Function: TN_commands_fnc_init
 * Author:   Bae [29th ID]
 *
 * Description:
 *     Initializes the chat command system on the client.
 *     Compiles and executes each module's commands.sqf to
 *     populate the global command and help arrays, then
 *     converts them to HashMaps for O(1) lookups. Uses a
 *     per-frame handler to detect when the chat display opens
 *     and adds a KeyDown handler that intercepts messages
 *     beginning with the command marker ("!"), closes the chat
 *     to prevent sending, and routes them to fn_execute. Should
 *     be initialized after the round system.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     call TN_commands_fnc_init;
 */

if (hasInterface) then
{
    TN_commands_commandMarker = "!"; //Character at the front of the chat input to intercept it

    #include "commands.sqf"

    // Load each module's commands.sqf if it exists.
    {
        private _commandsFile = format ["TN_Functions\%1\commands.sqf", _x];
        if !(fileExists _commandsFile) then { continue };

        call compile preprocessFileLineNumbers _commandsFile;
    }
    forEach (TN_MODULES - ["commands"]);

    // Convert flat arrays to HashMaps for fast lookup.
    TN_commands_allCommands = createHashMapFromArray TN_commands_allCommands;
    TN_commands_helpInfo = createHashMapFromArray TN_commands_helpInfo;

    TN_commands_finishedInit = true;
    ["TN_commands_initCompleted", []] call CBA_fnc_localEvent;

    TN_commands_chatOpen = false;

    [{
        private _display = findDisplay 24;

        if (isNull _display) then {
            TN_commands_chatOpen = false;
        } else {
            if (!TN_commands_chatOpen) then {
                TN_commands_chatOpen = true;

                _display displayAddEventHandler ["KeyDown", {
                    params ["_display", "_key"];

                    // 28 = Enter, 156 = Numpad Enter
                    if (_key != 28 && _key != 156) exitWith { false };

                    private _text = ctrlText (_display displayCtrl 101);

                    if (_text isEqualTo "") exitWith { false };
                    if !((_text select [0, 1]) isEqualTo TN_commands_commandMarker) exitWith { false };

                    closeDialog 0;
                    _display closeDisplay 1;

                    [_text] call TN_commands_fnc_execute;

                    true
                }];
            };
        };
    }, 0] call CBA_fnc_addPerFrameHandler;
};

/* --- Compile command subfolder functions (not in CfgFunctions) --- */

if (hasInterface) then {
    TN_commands_fnc_arsenalCreate = compileFinal preprocessFileLineNumbers
        "Dott_Functions\commands\arsenal\fn_create.sqf";
};

if (isServer) then {
    TN_commands_fnc_arsenalRegister = compileFinal preprocessFileLineNumbers
        "Dott_Functions\commands\arsenal\fn_register.sqf";
};
