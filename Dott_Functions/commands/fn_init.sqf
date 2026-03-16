#include "..\..\data\defines.hpp"

/*
 * Function: DOTT_commands_fnc_init
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
 *     call DOTT_commands_fnc_init;
 */

if (hasInterface) then
{
    pvpfw_chatIntercept_commandMarker = "!"; //Character at the front of the chat input to intercept it

    #include "commands.sqf"

    // Load each module's commands.sqf if it exists.
    {
        private _commandsFile = format ["DOTT_Functions\%1\commands.sqf", _x];
        if !(fileExists _commandsFile) then { continue };

        call compile preprocessFileLineNumbers _commandsFile;
    }
    forEach (DOTT_MODULES - ["commands"]);

    // Convert flat arrays to HashMaps for fast lookup.
    pvpfw_chatIntercept_allCommands = createHashMapFromArray pvpfw_chatIntercept_allCommands;
    pvpfw_chatIntercept_helpInfo = createHashMapFromArray pvpfw_chatIntercept_helpInfo;

    DOTT_commands_finishedInit = true;
    ["DOTT_commands_initCompleted", []] call CBA_fnc_localEvent;

    DOTT_commands_chatOpen = false;

    [{
        private _display = findDisplay 24;

        if (isNull _display) then {
            DOTT_commands_chatOpen = false;
        } else {
            if (!DOTT_commands_chatOpen) then {
                DOTT_commands_chatOpen = true;

                _display displayAddEventHandler ["KeyDown", {
                    params ["_display", "_key"];

                    // 28 = Enter, 156 = Numpad Enter
                    if (_key != 28 && _key != 156) exitWith { false };

                    private _text = ctrlText (_display displayCtrl 101);
                    private _chatArr = toArray _text;

                    if (_chatArr isEqualTo []) exitWith { false };
                    if !((_chatArr select 0) isEqualTo ((toArray pvpfw_chatIntercept_commandMarker) select 0)) exitWith { false };

                    closeDialog 0;
                    _display closeDisplay 1;

                    [_chatArr] call DOTT_commands_fnc_execute;

                    true
                }];
            };
        };
    }, 0] call CBA_fnc_addPerFrameHandler;
};

/* --- Compile command subfolder functions (not in CfgFunctions) --- */

if (hasInterface) then {
    DOTT_commands_fnc_arsenalCreate = compileFinal preprocessFileLineNumbers
        "Dott_Functions\commands\arsenal\fn_create.sqf";
};

if (isServer) then {
    DOTT_commands_fnc_arsenalRegister = compileFinal preprocessFileLineNumbers
        "Dott_Functions\commands\arsenal\fn_register.sqf";
};
