#include "..\..\data\templates.hpp"

/*
 * Author: Bae [29th ID], modified from Hill [29th ID]
 * Initializes all base interaction objects on the client.
 * Scans every editor-placed object for a variable name
 * matching the "base_action_<type>_<id>" convention and
 * sorts them into global arrays (TN_base_terminals,
 * TN_base_arsenals, TN_base_garbages). Then sets up:
 *   - Spectator addActions on terminal objects
 *   - Proximity triggers for terminal animations
 *   - Radius-based ACE/vanilla arsenal with environment
 *     sound toggling (muted inside arsenal zone)
 *   - Respawn handler to reset arsenal action ID
 *   - Force Parade addAction on the BLUFOR ammo box
 *     (if parade module is loaded)
 *   - Clean-up addActions on garbage can objects
 *
 * Hardcoded object references:
 *   base_action_arsenal_blu - BLUFOR ammo box used for
 *       the Force Parade addAction. Must exist in
 *       mission.sqm with that exact variable name.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_base_fnc_init;
 */

/*
 * Editor-placed objects referenced in this module:
 *     base_action_arsenal_blu - Conitionally if parade module in DOTT_MODULES
 */

if !(hasInterface) exitWith {};

//Add actions to spectator terminals
TN_base_terminals = [];
TN_base_arsenals = [];
TN_base_garbages = []; //global variable for cleaner function

{ //forEach object placed in editor
    private _vicString = vehicleVarName _x;
    if (_vicString isEqualTo "") then { continue };

    _vicString = toLowerANSI _vicString;

    // E.G. "base_action_terminal_0" -> ["base","action","terminal","0"]
    private _tags = _vicString splitString "_";

    private _tagCount = count _tags;
    if (_tagCount < 3) then { continue };

    private _actionObject = _tags select 1;
    if (_actionObject isNotEqualTo "action") then
    {
        continue;
    };

    private _actionType = _tags select 2;
    switch (_actionType) do
    {
        case "arsenal":
        {
            TN_base_arsenals pushBack _x;
        };
        case "terminal":
        {
            TN_base_terminals pushBack _x;
        };
        case "garbage":
        {
            TN_base_garbages pushBack _x;
        };
        default {};
    };
}
forEach allMissionObjects "All";

{
    _x addAction [
        "<img image='\A3\Ui_f\data\GUI\Rsc\RscDisplayEGSpectator\Follow.paa'/><t color='#00ff00'>  Spectator</t>",
        "[] call TN_spectator_fnc_enter",
        nil, 6, false, true, "", "true", 4
    ];

    private _trg = createTrigger ["EmptyDetector", getPos _x, false];
    _trg setTriggerArea [0, 0, 0, false];
    _trg setTriggerActivation ["NONE", "NONE", true];

    private _condition = format ["player distance %1 < 3", _x];
    private _activate = format ["[%1,3] call BIS_fnc_dataTerminalAnimate;", _x];
    private _deActivate = format ["[%1,0] call BIS_fnc_dataTerminalAnimate;", _x];
    _trg setTriggerStatements [_condition, _activate, _deActivate];
} forEach TN_base_terminals;

//Very messy area below but I'm lazy
//------- ACE Arsenal via radius from box -------//
//------- Disable Environment Noises when in radius unless in specator or Zeus -------//

TN_base_arsenalActionId = -1;

#define ENV_ON 1 fadeEnvironment 1
#define ENV_OFF 1 fadeEnvironment 0
TN_base_keepEnvironmentSounds = false;

[
    "TN_enteredZeus",
    {
        TN_base_keepEnvironmentSounds = true;
        ENV_ON;
    }
] call CBA_fnc_addEventHandler;

[
    "TN_exitedZeus",
    {
        TN_base_keepEnvironmentSounds = false;
        if (TN_base_arsenalActionId isNotEqualTo -1) then { ENV_OFF };
    }
] call CBA_fnc_addEventHandler;

[
    "enteredSpectator",
    {
        TN_base_keepEnvironmentSounds = true;
        ENV_ON;
    }
] call CBA_fnc_addEventHandler;

[
    "exitedSpectator",
    {
        TN_base_keepEnvironmentSounds = false;
        if (TN_base_arsenalActionId isNotEqualTo -1) then { ENV_OFF };
    }
] call CBA_fnc_addEventHandler;


if (isNil "TN_arsenal_centers") then
{
    TN_arsenal_centers = [];

    {
        TN_arsenal_centers pushBack (getPosASL _x);
    } forEach TN_base_arsenals;
};

if (TN_arsenal_centers isNotEqualTo []) then
{
    [{!isNull player},
    {
        private _radius = if (isNil "TN_event_arsenalRadius") then { 75 } else { TN_event_arsenalRadius };
        [{ call TN_base_fnc_arsenalZoneCheck }, 1, [_radius * _radius]] call CBA_fnc_addPerFrameHandler;
    }] call CBA_fnc_waitUntilAndExecute;
};

[
    "TN_base_respawnArsenalActionId",
    "Respawn",
    {
        TN_base_arsenalActionId = -1;
    }
] call CBA_fnc_addBISPlayerEventHandler;

//- Add Force Parade to BLUFOR Ammo Box, maybe belongs in parade module instead -//
if ("parade" in TN_MODULES) then
{
    TN_loadout_lastDebriefTime = -10;
    base_action_arsenal_blu addAction [
        "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#3f8eff'>  Force Parade</t>",
        {
            params ["_target"];
            [_target, 125] call TN_parade_fnc_forceAll;
        },
        nil,
        0.9,
        true,
        true,
        "",
        "serverCommandAvailable '#lock' && ((player distance base_action_arsenal_blu) < 5 || (time - TN_loadout_lastDebriefTime) < 10)",
        50
    ];
};



{
    _x addAction [
        "<img image='\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa'/><t color='#FF0080'>  Clean-Up</t>",
        "call TN_base_fnc_cleaner",
        nil, 1, false, true, "", "true", 2
    ];
} forEach TN_base_garbages;

nil
