/**
 * Function: TN_ocap_fnc_init
 * Author:   Bae [29th ID]
 *
 * Purpose:
 *   Initializes OCAP event handlers that integrate with the round
 *   system. Compiles sector/recording functions, registers CBA
 *   event handlers for round lifecycle events, and sets up marker
 *   workarounds. Must run on the server.
 *
 * Hardcoded Paths:
 *   Dott_Functions\ocap\fn_initializePlayer.sqf
 *   Dott_Functions\ocap\handleMarkers.sqf
 *
 * Parameter(s): None
 * Returns: Nothing
 *
 * Example:
 *   call TN_ocap_fnc_init;
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

    TN_ocap_roundNum = 1;

    TN_ocap_recording = false;

    //Dont start/pause recordings if autoStart is forced by server config
    if !(OCAP_settings_autoStart) then
    {
        TN_ocap_fnc_initializePlayer = compile
            preprocessFileLineNumbers
            "TN_Functions\ocap\fn_initializePlayer.sqf";

        // Trigger recording start to create captureLoop PFHObject
        [{missionNamespace getVariable ["ocap_extension_sessionReady", false]},
        {
            ocap_recorder_startTime = time;
        }] call CBA_fnc_waitUntilAndExecute;

        //hijack PFH to start and stop when we want while still saving other events
        #define SHOULD_SAVE_EVENTS \
        ((missionNamespace getVariable ["ocap_recorder_recording", false]) \
         && missionNamespace getVariable ["ocap_recorder_startTime", -1] > -1)

        [{!isNil "ocap_recorder_PFHObject"},
        {
            ocap_recorder_PFHObject setVariable
                ["run_condition",
                {SHOULD_SAVE_EVENTS && TN_ocap_recording}];
        }] call CBA_fnc_waitUntilAndExecute;

        //Add marker workarounds
        [{!isNil "ocap_listener_markers"},
            {
            ["ocap_handleMarker", ocap_listener_markers] 
                call CBA_fnc_removeEventHandler;
            call compile preprocessFileLineNumbers 
                "TN_Functions\ocap\handleMarkers.sqf"}] 
            call CBA_fnc_waitUntilAndExecute;

        #define UPDATE_TIME [] call ocap_recorder_fnc_updateTime
        #define START_RECORDING TN_ocap_recording = true; UPDATE_TIME
        #define STOP_RECORDING TN_ocap_recording = false; UPDATE_TIME

        [
            "TN_round_safeStartBegin",
            {
                START_RECORDING;
            }
        ] call CBA_fnc_addEventHandler;

        [
            "TN_round_started",
            {
                START_RECORDING;
            }
        ] call CBA_fnc_addEventHandler;

        [
            "TN_round_safeStartAborted",
            {
                STOP_RECORDING;
            }
        ] call CBA_fnc_addEventHandler;

        [
            "TN_round_ended",
            {
                STOP_RECORDING;
            }
        ] call CBA_fnc_addEventHandler;        
    };

    [OCAP_settings_autoStart] remoteExecCall
        ["TN_ocap_fnc_initClient",
        [0, -2] select isDedicated, true];

    [
        "TN_round_safeStartBegin",
        {
            ["ocap_customEvent",
                ["generalEvent", "Safe start began!"]]
                call CBA_fnc_serverEvent;
        }
    ] call CBA_fnc_addEventHandler;

    [
        "TN_round_safeStartAborted",
        {
            ["ocap_customEvent",
                ["generalEvent", "Safe start aborted!"]]
                call CBA_fnc_serverEvent;
        }
    ] call CBA_fnc_addEventHandler;

    [
        "TN_round_started",
        {
            ["ocap_customEvent",
                ["generalEvent",
                format ["Round %1 started!",
                    TN_ocap_roundNum]]]
                call CBA_fnc_serverEvent;
        }
    ] call CBA_fnc_addEventHandler;

    [
        "TN_round_ended",
        {
            ["ocap_customEvent",
                ["generalEvent",
                format ["Round %1 ended!",
                    TN_ocap_roundNum]]]
                call CBA_fnc_serverEvent;

            TN_ocap_roundNum = TN_ocap_roundNum + 1;
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
