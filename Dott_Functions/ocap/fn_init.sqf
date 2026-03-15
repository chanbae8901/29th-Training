/**
 * DOTT_ocap_fnc_init
 *
 * Purpose:
 *   Initializes OCAP event handlers that integrate with the round
 *   system. Compiles sector/recording functions, registers CBA
 *   event handlers for round lifecycle events, and sets up marker
 *   workarounds. Must run on the server.
 *
 * Hardcoded Paths:
 *   Dott_Functions\ocap\fn_initializePlayer.sqf
 *
 * Parameter(s): None
 * Returns: Nothing
 *
 * Example:
 *   call DOTT_ocap_fnc_init;
 *
 * Date: 02/04/2026
 * Version: 1.1
 * Author: Bae [29th ID]
 */

/*
    A large amount of code in this folder is taken from OCAP 2
    Addon.
    https://github.com/OCAP2/OCAP?tab=License-1-ov-file#readme
*/

//NOTE: OCAP settings defined in cba_settings.sqf

if (isServer) then
{
    if !(isClass (configFile >> "CfgPatches" >> "OCAP_recorder")) exitWith {};

    DOTT_ocap_roundNum = 1;

    //Dont start/pause recordings if autoStart is forced by server config
    if !(OCAP_settings_autoStart) then
    {
        DOTT_ocap_fnc_initializePlayer = compile
            preprocessFileLineNumbers
            "DOTT_Functions\ocap\fn_initializePlayer.sqf";

        // Trigger recording start to create captureLoop PFHObject
        [{missionNamespace getVariable ["ocap_extension_sessionReady", false]},
        {
            ocap_recorder_startTime = time;
        }] call CBA_fnc_waitUntilAndExecute;

        //hijack PFH to start and stop when we want while still saving other events
        #define SHOULD_SAVE_EVENTS ((missionNamespace getVariable ["ocap_recorder_recording", false]) \
         && missionNamespace getVariable ["ocap_recorder_startTime", -1] > -1)

        [{!isNil "ocap_recorder_PFHObject"},
        {
            DOTT_ocap_recording = false;
            ocap_recorder_PFHObject setVariable ["run_condition", {SHOULD_SAVE_EVENTS && DOTT_ocap_recording}];
        }] call CBA_fnc_waitUntilAndExecute;

        #define UPDATE_TIME [] call ocap_recorder_fnc_updateTime
        #define START_RECORDING DOTT_ocap_recording = true; UPDATE_TIME
        #define STOP_RECORDING DOTT_ocap_recording = false; UPDATE_TIME

        [
            "DOTT_round_safeStartBegin",
            {
                START_RECORDING;
            }
        ] call CBA_fnc_addEventHandler;

        [
            "DOTT_round_started",
            {
                START_RECORDING;
            }
        ] call CBA_fnc_addEventHandler;

        [
            "DOTT_round_safeStartAborted",
            {
                STOP_RECORDING;
            }
        ] call CBA_fnc_addEventHandler;

        [
            "DOTT_round_ended",
            {
                STOP_RECORDING;
            }
        ] call CBA_fnc_addEventHandler;        
    };

    [OCAP_settings_autoStart] remoteExecCall
        ["DOTT_ocap_fnc_initClient",
        [0, -2] select isDedicated, true];

    [
        "DOTT_round_safeStartBegin",
        {
            ["ocap_customEvent",
                ["generalEvent", "Safe start began!"]]
                call CBA_fnc_serverEvent;
        }
    ] call CBA_fnc_addEventHandler;

    [
        "DOTT_round_safeStartAborted",
        {
            ["ocap_customEvent",
                ["generalEvent", "Safe start aborted!"]]
                call CBA_fnc_serverEvent;
        }
    ] call CBA_fnc_addEventHandler;

    [
        "DOTT_round_started",
        {
            ["ocap_customEvent",
                ["generalEvent",
                format ["Round %1 started!",
                    DOTT_ocap_roundNum]]]
                call CBA_fnc_serverEvent;
        }
    ] call CBA_fnc_addEventHandler;

    [
        "DOTT_round_ended",
        {
            ["ocap_customEvent",
                ["generalEvent",
                format ["Round %1 ended!",
                    DOTT_ocap_roundNum]]]
                call CBA_fnc_serverEvent;

            DOTT_ocap_roundNum = DOTT_ocap_roundNum + 1;
        }
    ] call CBA_fnc_addEventHandler;

    //Curators created mid mission do not trigger OCAP 2 trackSectors
    //So we must manually add sectors
    if (ocap_settings_trackSectors) then
    {
        addMissionEventHandler ["EntityCreated", 
        {
            params ["_entity"];
            if !(_entity isKindOf "ModuleSector_F") exitWith {};
            [_entity] call ocap_recorder_fnc_trackSectors;
        }];
    };
};
