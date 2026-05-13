#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes OCAP event handlers that integrate with the round
 * system. Compiles sector/recording functions, registers CBA
 * event handlers for round lifecycle events, and sets up marker
 * workarounds. Must run on the server.
 *
 * Hardcoded Paths:
 *   TN_Functions\ocap\fn_initializePlayer.sqf
 *   TN_Functions\ocap\handleMarkers.sqf
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_ocap_fnc_init;
 */

/*
    A large amount of code in this folder is taken from OCAP 2
    Addon.
    https://github.com/OCAP2/OCAP?tab=License-1-ov-file#readme
*/

//NOTE: OCAP settings defined in cba_settings.sqf

#define NEWER_OCAP ocap_version isNotEqualTo "2.0.0"

if (!isServer) exitWith {};

if !(isClass (configFile >> "CfgPatches" >> "OCAP_recorder")) exitWith {};

if !(missionNamespace getVariable ["ocap_extension_sessionReady", false]) exitWith {
    [{missionNamespace getVariable ["ocap_extension_sessionReady", false]},
    FUNC(init), [],
    30,
    { diag_log text "OCAP: Timed out waiting for ocap_extension_sessionReady"; }
    ] call CBA_fnc_waitUntilAndExecute;
};

if (USING_MODULE(event) && {!EGVAR(event,useRoundSystem)}) exitWith {
    if (!OCAP_settings_autoStart) then {
        ocap_recorder_startTime = time;
    };
};

//Dont start/pause recordings if autoStart is forced by server config
#define SHOULD_SAVE_EVENTS \
((missionNamespace getVariable ["ocap_recorder_recording", false]) \
 && missionNamespace getVariable ["ocap_recorder_startTime", -1] > -1)
#define UPDATE_TIME [] call ocap_recorder_fnc_updateTime
#define START_RECORDING GVAR(recording) = true; UPDATE_TIME
#define STOP_RECORDING GVAR(recording) = false; UPDATE_TIME

if (!OCAP_settings_autoStart && NEWER_OCAP) then {
    FUNC(initializePlayer) = compile
        preprocessFileLineNumbers
        "TN_Functions\ocap\fn_initializePlayer.sqf";

    //don't use startRecording, causes double call of it
    //assigning startTime will call it properly
    ocap_recorder_startTime = time;
    publicVariable "ocap_recorder_startTime";
    
    [{ocap_recorder_captureFrameNo > 0}, {
        GVAR(recording) = false;

        ocap_recorder_PFHObject setVariable
            ["run_condition",
            {SHOULD_SAVE_EVENTS && GVAR(recording)}];

        ["ocap_handleMarker", ocap_listener_markers]
            call CBA_fnc_removeEventHandler;
        call compile preprocessFileLineNumbers
            "TN_Functions\ocap\handleMarkers.sqf";
    }, [],
    30,
    { diag_log text "OCAP: Timed out waiting for first capture frame"; }
    ] call CBA_fnc_waitUntilAndExecute;

    [
        QEGVAR(round,safeStartBegin), {
            START_RECORDING;
        }
    ] call CBA_fnc_addEventHandler;

    [
        QEGVAR(round,started), {
            START_RECORDING;
        }
    ] call CBA_fnc_addEventHandler;

    [
        QEGVAR(round,safeStartAborted), {
            STOP_RECORDING;
        }
    ] call CBA_fnc_addEventHandler;

    [
        QEGVAR(round,ended), {
            STOP_RECORDING;
        }
    ] call CBA_fnc_addEventHandler;

    remoteExecCall
        [QFUNC(initClient),
        [0, -2] select isDedicated, true];
};

GVAR(roundNum) = 1;

[
    QEGVAR(round,safeStartBegin), {
        ["ocap_customEvent",
            ["generalEvent", "Safe start began!"]]
            call CBA_fnc_serverEvent;
    }
] call CBA_fnc_addEventHandler;

[
    QEGVAR(round,safeStartAborted), {
        ["ocap_customEvent",
            ["generalEvent", "Safe start aborted!"]]
            call CBA_fnc_serverEvent;
    }
] call CBA_fnc_addEventHandler;

[
    QEGVAR(round,started), {
        ["ocap_customEvent",
            ["generalEvent",
            format ["Round %1 started!",
                GVAR(roundNum)]]]
            call CBA_fnc_serverEvent;
    }
] call CBA_fnc_addEventHandler;

[
    QEGVAR(round,ended), {
        ["ocap_customEvent",
            ["generalEvent",
            format ["Round %1 ended!",
                GVAR(roundNum)]]]
            call CBA_fnc_serverEvent;

        GVAR(roundNum) = GVAR(roundNum) + 1;
    }
] call CBA_fnc_addEventHandler;

if (missionNamespace getVariable ["ocap_settings_trackSectors", false]) then {
    [{ocap_recorder_captureFrameNo > 0}, {
        ["ModuleSector_F", "Init", {
            params ["_entity"];
            [_entity] call ocap_recorder_fnc_trackSectors;
        }] call CBA_fnc_addClassEventHandler;
    }, [],
    30,
    { diag_log text "OCAP: Timed out waiting for first capture frame (trackSectors)"; }
    ] call CBA_fnc_waitUntilAndExecute;
};

nil
