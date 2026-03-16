#include "..\..\data\defines.hpp"

/*
 * Function: TN_base_fnc_init
 * Author:   Bae [29th ID], modified from Hill [29th ID]
 *
 * Description:
 *     Initializes all base interaction objects on the client.
 *     Scans every editor-placed object for a variable name
 *     matching the "base_action_<type>_<id>" convention and
 *     sorts them into global arrays (TN_terminals,
 *     TN_arsenals, TN_garbages). Then sets up:
 *       - Spectator addActions on terminal objects
 *       - Proximity triggers for terminal animations
 *       - Radius-based ACE/vanilla arsenal with environment
 *         sound toggling (muted inside arsenal zone)
 *       - Respawn handler to reset arsenal action ID
 *       - Force Parade addAction on the BLUFOR ammo box
 *         (if parade module is loaded)
 *       - Clean-up addActions on garbage can objects
 *
 *     Hardcoded object references:
 *       base_action_arsenal_blu - BLUFOR ammo box used for
 *           the Force Parade addAction. Must exist in
 *           mission.sqm with that exact variable name.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     call TN_base_fnc_init;
 */

if !(hasInterface) exitWith {};

//Add actions to spectator terminals
TN_terminals = [];
TN_arsenals = [];
TN_garbages = []; //global variable for cleaner function

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
            TN_arsenals pushBack _x;
        };
        case "terminal":
        {
            TN_terminals pushBack _x;
        };
        case "garbage":
        {
            TN_garbages pushBack _x;
        };
        default {};
    };
}
forEach allMissionObjects "All";

{
    _x addAction [
        "<img image='\A3\Ui_f\data\GUI\Rsc\RscDisplayEGSpectator\Follow.paa'/><t color='#00ff00'>  Spectator</t>",
        "[] spawn TN_spectator_fnc_enter",
        nil, 6, false, true, "", "true", 4
    ];

    private _trg = createTrigger ["EmptyDetector", getPos _x, false];
    _trg setTriggerArea [0, 0, 0, false];
    _trg setTriggerActivation ["NONE", "NONE", true];

    private _condition = format ["player distance %1 < 3", _x];
    private _activate = format ["[%1,3] call BIS_fnc_dataTerminalAnimate;", _x];
    private _deActivate = format ["[%1,0] call BIS_fnc_dataTerminalAnimate;", _x];
    _trg setTriggerStatements [_condition, _activate, _deActivate];
} forEach TN_terminals;

//Very messy area below but I'm lazy
//------- ACE Arsenal via radius from box -------//
//------- Disable Environment Noises when in radius unless in specator or Zeus -------//

arsenalActionId = -1;

#define ENV_ON 1 fadeEnvironment 1
#define ENV_OFF 1 fadeEnvironment 0
TN_keepEnvironmentSounds = false;

[
    "TN_enteredZeus",
    {
        TN_keepEnvironmentSounds = true;
        ENV_ON;
    }
] call CBA_fnc_addEventHandler;

[
    "TN_exitedZeus",
    {
        TN_keepEnvironmentSounds = false;
        if (arsenalActionId != -1) then { ENV_OFF };
    }
] call CBA_fnc_addEventHandler;

[
    "enteredSpectator",
    {
        TN_keepEnvironmentSounds = true;
        ENV_ON;
    }
] call CBA_fnc_addEventHandler;

[
    "exitedSpectator",
    {
        TN_keepEnvironmentSounds = false;
        if (arsenalActionId != -1) then { ENV_OFF };
    }
] call CBA_fnc_addEventHandler;


if (isNil "TN_arsenal_centers") then
{
    TN_arsenal_centers = [];

    {
        TN_arsenal_centers pushBack (getPosASL _x);
    } forEach TN_arsenals;
};

[] spawn
{
    if (count TN_arsenal_centers == 0) exitWith {};

    waitUntil { !isNull player };

    private _radius =
        if (isNil "TN_event_arsenalRadius") then
    {
        75
    }
    else
    {
        TN_event_arsenalRadius
    };
    private _radiusSquared = _radius * _radius;

    while { true } do
    {
        private _inZone = false;
        {
            private _distSquared = (getPosASL player) distanceSqr _x;
            if (_distSquared <= _radiusSquared) exitWith
            {
                _inZone = true;
            };
        } forEach TN_arsenal_centers;

        if (_inZone) then
        {
            if (arsenalActionId == -1) then
            {
                //put inside arsenalActionId since I'm too lazy to put a check for inZone change
                if !(TN_keepEnvironmentSounds) then
                {
                    ENV_OFF;
                };

                if (isClass (configFile >> "CfgPatches" >> "ace_main")) then
                {
                    arsenalActionId = player addAction [
                        "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Ace Arsenal</t>",
                        {
                            [_this select 1, _this select 1, true] call ace_arsenal_fnc_openBox;
                        },
                        nil, 1.5, true, true, "", "true"
                    ];
                }
                else
                {
                    arsenalActionId = player addAction [
                        "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Virtual Arsenal</t>",
                        {
                            ["Open", true] spawn BIS_fnc_arsenal;
                        },
                        nil, 1.5, true, true, "", "true"
                    ];
                };
            };
        }
        else
        {
            if (arsenalActionId != -1) then
            {
                ENV_ON;
                player removeAction arsenalActionId;
                arsenalActionId = -1;
            };
        };

        sleep 1;
    };
};

[
    "TN_base_respawnArsenalActionId",
    "Respawn",
    {
        arsenalActionId = -1;
    }
] call CBA_fnc_addBISPlayerEventHandler;

//- Add Force Parade to BLUFOR Ammo Box, maybe belongs in parade module instead -//
if (TN_MODULES find "parade" != -1) then
{
    lastDebriefTime = -10;
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
        "serverCommandAvailable '#lock' && ((player distance base_action_arsenal_blu) < 5 || (time - lastDebriefTime) < 10)",
        50
    ];
};



{
    _x addAction [
        "<img image='\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa'/><t color='#FF0080'>  Clean-Up</t>",
        "call TN_base_fnc_cleaner",
        nil, 1, false, true, "", "true", 2
    ];
} forEach TN_garbages;
