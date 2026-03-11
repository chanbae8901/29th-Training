#include "..\..\data\defines.hpp"

/*
 * Function: DOTT_base_fnc_init
 * Author:   Bae [29th ID], modified from Hill [29th ID]
 *
 * Description:
 *     Initializes all base interaction objects on the client.
 *     Scans every editor-placed object for a variable name
 *     matching the "base_action_<type>_<id>" convention and
 *     sorts them into global arrays (DOTT_terminals,
 *     DOTT_arsenals, DOTT_garbages). Then sets up:
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
 *     call DOTT_base_fnc_init;
 */

if !(hasInterface) exitWith {};

//Add actions to spectator terminals
DOTT_terminals = [];
DOTT_arsenals = [];
DOTT_garbages = []; //global variable for cleaner function

{ //forEach object placed in editor
    //get variable name in string format, if empty then skip to next object
    private _vicString = vehicleVarName _x;
    if (_vicString isEqualTo "") then { continue };

    //make all lower case to reduce user errors
    _vicString = toLowerANSI _vicString;

    //create array of tags split with an underscore (E.G. "base_action_terminal_0" becomes ["base","action","terminal","0"] )
    private _tags = _vicString splitString "_";

    //if less then 3 tags, object isn't named for this convention, skip object
    private _tagCount = count _tags;
    if (_tagCount < 3) then { continue };

    //if the second tag isn't "action", skip object, continue to next object in vehicles array
    private _actionObject = _tags select 1;
    if (_actionObject isNotEqualTo "action") then
    {
        continue;
    };

    //third tag is action type, sort variable into associated array
    private _actionType = _tags select 2;
    switch (_actionType) do
    {
        case "arsenal":
        {
            DOTT_arsenals pushBack _x;
        };
        case "terminal":
        {
            DOTT_terminals pushBack _x;
        };
        case "garbage":
        {
            DOTT_garbages pushBack _x;
        };
    };
}
forEach allMissionObjects "All";

{
    _x addAction [
        "<img image='\A3\Ui_f\data\GUI\Rsc\RscDisplayEGSpectator\Follow.paa'/><t color='#00ff00'>  Spectator</t>",
        "[] spawn DOTT_spectator_fnc_enter",
        nil, 6, false, true, "", "true", 4
    ];

    //create trigger for animating the spectator box and set it up
    private _trg = createTrigger [
        "EmptyDetector", getPos _x, false
    ];
    _trg setTriggerArea [0, 0, 0, false];
    _trg setTriggerActivation ["NONE", "NONE", true];

    private _condition = format [
        "player distance %1 < 3", _x
    ];
    private _activate = format [
        "[%1,3] call BIS_fnc_dataTerminalAnimate;", _x
    ];
    private _deActivate = format [
        "[%1,0] call BIS_fnc_dataTerminalAnimate;", _x
    ];
    _trg setTriggerStatements [
        _condition, _activate, _deActivate
    ];
} forEach DOTT_terminals;

//Very messy area below but I'm lazy
//------- ACE Arsenal via radius from box -------//
//------- Disable Environment Noises when in radius unless in specator or Zeus -------//

arsenalActionId = -1;

#define ENV_ON 1 fadeEnvironment 1
#define ENV_OFF 1 fadeEnvironment 0
DOTT_keepEnvironmentSounds = false;

[
    "DOTT_enteredZeus",
    {
        DOTT_keepEnvironmentSounds = true;
        ENV_ON;
    }
] call CBA_fnc_addEventHandler;

[
    "DOTT_exitedZeus",
    {
        DOTT_keepEnvironmentSounds = false;
        if (arsenalActionId != -1) then { ENV_OFF };
    }
] call CBA_fnc_addEventHandler;

[
    "enteredSpectator",
    {
        DOTT_keepEnvironmentSounds = true;
        ENV_ON;
    }
] call CBA_fnc_addEventHandler;

[
    "exitedSpectator",
    {
        DOTT_keepEnvironmentSounds = false;
        if (arsenalActionId != -1) then { ENV_OFF };
    }
] call CBA_fnc_addEventHandler;


if (isNil "DOTT_arsenal_centers") then
{
    DOTT_arsenal_centers = [];

    {
        DOTT_arsenal_centers pushBack (getPosASL _x);
    } forEach DOTT_arsenals;
};

[] spawn
{
    if (count DOTT_arsenal_centers == 0) exitWith {};

    waitUntil { !isNull player };

    private _radius =
        if (isNil "DOTT_event_arsenalRadius") then
    {
        75
    }
    else
    {
        DOTT_event_arsenalRadius
    };
    private _radiusSquared = _radius * _radius;

    while { true } do
    {
        private _inZone = false;
        {
            private _distSquared =
                (getPosASL player) distanceSqr _x;
            if (_distSquared <= _radiusSquared) exitWith
            {
                _inZone = true;
            };
        } forEach DOTT_arsenal_centers;

        if (_inZone) then
        {
            if (arsenalActionId == -1) then
            {
                //put inside arsenalActionId since I'm too lazy to put a check for inZone change
                if !(DOTT_keepEnvironmentSounds) then
                {
                    ENV_OFF;
                };

                if (
                    isClass (
                        configFile >> "CfgPatches"
                        >> "ace_main"
                    )
                ) then
                {
                    arsenalActionId = player addAction [
                        "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Ace Arsenal</t>",
                        {
                            [
                                _this select 1,
                                _this select 1,
                                true
                            ] call ace_arsenal_fnc_openBox;
                        },
                        nil, 1.5, true, true, "", "true"
                    ];
                }
                else
                {
                    arsenalActionId = player addAction [
                        "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Virtual Arsenal</t>",
                        {
                            ["Open", true]
                                spawn BIS_fnc_arsenal;
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
    "DOTT_base_respawnArsenalActionId",
    "Respawn",
    {
        arsenalActionId = -1;
    }
] call CBA_fnc_addBISPlayerEventHandler;

//- Add Force Parade to BLUFOR Ammo Box, maybe belongs in parade module instead -//
if (DOTT_MODULES find "parade" != -1) then
{
    lastDebriefTime = -10;
    base_action_arsenal_blu addAction [
        "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#3f8eff'>  Force Parade</t>",
        {
            params ["_target"];
            [_target, 125]
                call DOTT_parade_fnc_forceAll;
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
        "call DOTT_base_fnc_cleaner",
        nil, 1, false, true, "", "true", 2
    ];
} forEach DOTT_garbages;
