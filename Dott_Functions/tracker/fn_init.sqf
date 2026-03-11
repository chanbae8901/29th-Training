/**
 * File: fn_init.sqf
 * Function: DOTT_tracker_fnc_init
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Initializes the tracker system on both server and client.
 * Projectiles created by players have weapon/player info saved
 * onto them, which transfers to any alive player/vehicle on hit.
 * On unconscious/death events, this info is used to record the
 * event server-side, then released to clients via Map Diary at
 * end of round.
 *
 * Parameters:
 * None
 *
 * Returns:
 * true
 */

if (("enableRoundEventLog"
    call BIS_fnc_getParamValue) != 1) exitWith {};

if (isServer) then
{
    DOTT_tracker_previous = [];
    DOTT_tracker_events = [];
    DOTT_tracker_names = [];
    DOTT_tracker_sides = [];
    DOTT_tracker_weapons = [];
    DOTT_tracker_currentRound = 1;

    DOTT_tracker_startTime = -1;
    publicVariable "DOTT_tracker_startTime";

    [
        "DOTT_round_started",
        {
            DOTT_tracker_startTime = serverTime;
            publicVariable "DOTT_tracker_startTime";

            DOTT_tracker_events = [];
            DOTT_tracker_names = [];
            DOTT_tracker_sides = [];
            DOTT_tracker_weapons = [];

            // Reset all hit info on players at start
            // of round.
            private _players =
                allPlayers
                - entities "HeadlessClient_F";
            {
                _x setVariable
                    ["DOTT_lastHit", nil];
                _x setVariable
                    ["DOTT_hitMap", createHashMap];
            }
            forEach _players;
        }
    ] call CBA_fnc_addEventHandler;

    // --- Kill --- //
    addMissionEventHandler ["EntityKilled",
    {
        params ["_unit", "_killer", "_instigator"];
        if !(isPlayer _unit
            || (!(_unit isKindOf "Man")
                && _unit isKindOf "AllVehicles"))
            exitWith {};

        // remoteExecCall for sending info occurs 1
        // frame later so wait.
        [
            {
                _this call DOTT_tracker_fnc_recordKill;
            },
            _this, 0.75 // Delay to wait for info from clients.
        ] call CBA_fnc_waitAndExecute;
    }];

    addMissionEventHandler ["EntityRespawned",
    {
        params ["_unit"];
        _unit setVariable ["DOTT_lastHit", nil];
        _unit setVariable ["DOTT_hitMap", nil];
    }];

    // --- Consciousness --- //
    [
        "ace_unconscious",
        {
            // remoteExecCall for sending info occurs 1
            // frame later so wait.
            [
                {
                    _this call
                        DOTT_tracker_fnc_recordACEConscious;
                },
                _this, 0.5
            ] call CBA_fnc_waitAndExecute;
        }
    ]
    call CBA_fnc_addEventHandler;

    // --- Tracker Diary --- //
    [
        "DOTT_round_ended",
        {
            DOTT_tracker_startTime = -1;
            [] spawn
            {
                // Wait for any last second events from
                // the network.
                sleep 1;
                publicVariable
                    "DOTT_tracker_startTime";
                [
                    DOTT_tracker_events,
                    DOTT_tracker_names,
                    DOTT_tracker_sides,
                    DOTT_tracker_weapons,
                    DOTT_tracker_currentRound
                ] remoteExec
                    ["DOTT_tracker_fnc_createDiaryEntries"];

                DOTT_tracker_previous pushBack
                [
                    +DOTT_tracker_events,
                    +DOTT_tracker_names,
                    +DOTT_tracker_sides,
                    +DOTT_tracker_weapons
                ];

                DOTT_tracker_currentRound =
                    DOTT_tracker_currentRound + 1;
            };
        }
    ] call CBA_fnc_addEventHandler;

    // --- Sector Capture --- //
    {
        [_x, "ownerChanged",
        {
            _this call
                DOTT_tracker_fnc_recordSectorCapture;
        }] call BIS_fnc_addScriptedEventHandler;
    } forEach (allMissionObjects "ModuleSector_F");

    addMissionEventHandler ["EntityCreated",
    {
        params ["_entity"];
        if (_entity isKindOf "ModuleSector_F") then
        {
            [_entity, "ownerChanged",
            {
                _this call
                    DOTT_tracker_fnc_recordSectorCapture;
            }] call BIS_fnc_addScriptedEventHandler;
        };
    }];
};

if (hasInterface) then
{
    // --- Attacker Info --- //
    DOTT_tracker_cookOffs = [];

    [] spawn
    {
        waitUntil { !isNull player };
        call DOTT_tracker_fnc_addEventHandlersClient;
    };

    DOTT_weaponNameCache = createHashMap;
    // --- Remove Statistics from Map, Send All
    //     Round Histories --- //
    DOTT_tracker_last_round_Recorded = 0;

    addMissionEventHandler ["PreloadFinished",
    {
        [player] remoteExec
            ["DOTT_tracker_fnc_sendAll", 2];
        player removeDiarySubject "Statistics";
        removeMissionEventHandler
            ["PreloadFinished", _thisEventHandler];
    }];

    // --- Fire/Burn Related Information --- //
    [
        "DOTT_round_started",
        {
            DOTT_tracker_cookOffs = [];
            player setVariable
                ["DOTT_burnInstigator", nil];
            player setVariable
                ["DOTT_burnInstigatorTime", nil];
            player setVariable
                ["DOTT_burnWeapon", nil];
            // Burn info of other players locally is not
            // reset, but should be fine.
        }
    ] call CBA_fnc_addEventHandler;
};

// Run for both server and client.
addMissionEventHandler ["EntityKilled",
{
    params ["_unit"];
    if (_unit isKindOf "Man") then
    {
        // Store name as it gets deleted automatically
        // later.
        _unit setVariable ["DOTT_name", name _unit];
    };
}];

true
