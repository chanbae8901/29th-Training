/*
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

if (("enableRoundEventLog" call BIS_fnc_getParamValue) != 1)
    exitWith {};

// ---------------------------------------------------------------
// Server-side initialization
// ---------------------------------------------------------------
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

    // -- Round start: reset tracker state --
    [
        "DOTT_round_started",
        {
            DOTT_tracker_startTime = serverTime;
            publicVariable "DOTT_tracker_startTime";

            DOTT_tracker_events = [];
            DOTT_tracker_names = [];
            DOTT_tracker_sides = [];
            DOTT_tracker_weapons = [];

            // Clear stale hit data so previous-round hits
            // don't bleed into the new round's kill credits.
            private _players =
                allPlayers - entities "HeadlessClient_F";
            {
                _x setVariable ["DOTT_lastHit", nil];
                _x setVariable
                    ["DOTT_hitMap", createHashMap];
            }
            forEach _players;
        }
    ] call CBA_fnc_addEventHandler;

    // -- Kill tracking --
    addMissionEventHandler ["EntityKilled",
    {
        params ["_unit", "_killer", "_instigator"];
        if !(isPlayer _unit
            || (!(_unit isKindOf "Man")
                && _unit isKindOf "AllVehicles"))
            exitWith {};

        // 0.75s delay: remoteExecCall from clients
        // delivering hit info runs one frame after the
        // hit event. This wait gives the network time to
        // deliver that data before we try to read it on
        // the server for kill attribution.
        [
            {
                _this call DOTT_tracker_fnc_recordKill;
            },
            _this, 0.75
        ] call CBA_fnc_waitAndExecute;
    }];

    addMissionEventHandler ["EntityRespawned",
    {
        params ["_unit"];
        _unit setVariable ["DOTT_lastHit", nil];
        _unit setVariable ["DOTT_hitMap", nil];
    }];

    // -- Consciousness tracking --
    [
        "ace_unconscious",
        {
            // 0.5s delay: same reason as kill -- wait for
            // client-side hit info to arrive via network
            // before attributing the unconscious event.
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

    // -- Round end: publish diary entries --
    [
        "DOTT_round_ended",
        {
            DOTT_tracker_startTime = -1;
            [] spawn
            {
                // 1s sleep: lets any final-moment events
                // still in transit over the network arrive
                // before we snapshot and broadcast results.
                sleep 1;
                publicVariable "DOTT_tracker_startTime";
                [
                    DOTT_tracker_events,
                    DOTT_tracker_names,
                    DOTT_tracker_sides,
                    DOTT_tracker_weapons,
                    DOTT_tracker_currentRound
                ] remoteExec
                    ["DOTT_tracker_fnc_createDiaryEntries"];

                // Deep copy (+) so future mutations to the
                // live arrays don't corrupt the archive.
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

    // -- Sector capture tracking --
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

// ---------------------------------------------------------------
// Client-side initialization
// ---------------------------------------------------------------
if (hasInterface) then
{
    DOTT_tracker_cookOffs = [];

    // Wait for player object to exist before attaching
    // event handlers that reference it directly.
    [] spawn
    {
        waitUntil { !isNull player };
        call DOTT_tracker_fnc_addEventHandlersClient;
    };

    DOTT_weaponNameCache = createHashMap;
    DOTT_tracker_last_round_Recorded = 0;

    // Request prior round histories from server on join,
    // and remove the vanilla Statistics diary subject.
    addMissionEventHandler ["PreloadFinished",
    {
        [player] remoteExec
            ["DOTT_tracker_fnc_sendAll", 2];
        player removeDiarySubject "Statistics";
        removeMissionEventHandler
            ["PreloadFinished", _thisEventHandler];
    }];

    // -- Fire/burn tracking state reset --
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
        }
    ] call CBA_fnc_addEventHandler;
};

// ---------------------------------------------------------------
// Shared (server + client): preserve player name on death
// ---------------------------------------------------------------
// Arma deletes the name property from dead units shortly after
// death. We cache it immediately so kill records can still
// reference the correct name.
addMissionEventHandler ["EntityKilled",
{
    params ["_unit"];
    if (_unit isKindOf "Man") then
    {
        _unit setVariable ["DOTT_name", name _unit];
    };
}];

true
