/**
 * Function: TN_tracker_fnc_init
 * Author:   Bae [29th ID]
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

if (("enableRoundEventLog" call BIS_fnc_getParamValue) != 1) exitWith {};

if (isServer) then
{
    TN_tracker_previous = [];
    TN_tracker_events = [];
    TN_tracker_names = [];
    TN_tracker_sides = [];
    TN_tracker_weapons = [];
    TN_tracker_currentRound = 1;

    TN_tracker_startTime = -1;
    publicVariable "TN_tracker_startTime";

    [
        "TN_round_started",
        {
            TN_tracker_startTime = serverTime;
            publicVariable "TN_tracker_startTime";

            TN_tracker_events = [];
            TN_tracker_names = [];
            TN_tracker_sides = [];
            TN_tracker_weapons = [];

            // Reset all hit info on players at start
            // of round.
            private _players = allPlayers - entities "HeadlessClient_F";
            {
                _x setVariable ["TN_lastHit", nil];
                _x setVariable ["TN_hitMap", createHashMap];
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
                _this call TN_tracker_fnc_recordKill;
            },
            _this, 0.75 // Delay to wait for info from clients.
        ] call CBA_fnc_waitAndExecute;
    }];

    addMissionEventHandler ["EntityRespawned",
    {
        params ["_unit"];
        _unit setVariable ["TN_lastHit", nil];
        _unit setVariable ["TN_hitMap", nil];
    }];

    // --- Consciousness --- //
    [
        "ace_unconscious",
        {
            // remoteExecCall for sending info occurs 1
            // frame later so wait.
            [
                {
                    _this call TN_tracker_fnc_recordACEConscious;
                },
                _this, 0.5
            ] call CBA_fnc_waitAndExecute;
        }
    ] call CBA_fnc_addEventHandler;

    // --- Tracker Diary --- //
    [
        "TN_round_ended",
        {
            TN_tracker_startTime = -1;
            [] spawn
            {
                // Wait for any last second events from
                // the network.
                sleep 1;
                publicVariable "TN_tracker_startTime";
                [
                    TN_tracker_events,
                    TN_tracker_names,
                    TN_tracker_sides,
                    TN_tracker_weapons,
                    TN_tracker_currentRound
                ] remoteExecCall ["TN_tracker_fnc_createDiaryEntries"];

                TN_tracker_previous pushBack
                [
                    +TN_tracker_events,
                    +TN_tracker_names,
                    +TN_tracker_sides,
                    +TN_tracker_weapons
                ];

                TN_tracker_currentRound = TN_tracker_currentRound + 1;
            };
        }
    ] call CBA_fnc_addEventHandler;

    // --- Sector Capture --- //
    {
        [_x, "ownerChanged",
        {
            _this call TN_tracker_fnc_recordSectorCapture;
        }] call BIS_fnc_addScriptedEventHandler;
    } forEach (allMissionObjects "ModuleSector_F");

    addMissionEventHandler ["EntityCreated",
    {
        params ["_entity"];
        if (_entity isKindOf "ModuleSector_F") then
        {
            [_entity, "ownerChanged",
            {
                _this call TN_tracker_fnc_recordSectorCapture;
            }] call BIS_fnc_addScriptedEventHandler;
        };
    }];

    // Store name as it gets deleted automatically later.
    addMissionEventHandler ["EntityKilled",
    {
        params ["_unit"];
        if (_unit isKindOf "Man") then
        {

            _unit setVariable ["TN_name", name _unit, true];
        };
    }];
};

if (hasInterface) then
{
    // --- Attacker Info --- //
    TN_tracker_cookOffs = [];

    [] spawn
    {
        waitUntil { !isNull player };
        call TN_tracker_fnc_addEventHandlersClient;
    };

    TN_weaponNameCache = createHashMap;
    // --- Remove Statistics from Map, Send All
    //     Round Histories --- //
    addMissionEventHandler ["PreloadFinished",
    {
        [player] remoteExecCall ["TN_tracker_fnc_sendAll", 2];
        player removeDiarySubject "Statistics";
        removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
    }];

    // --- Fire/Burn Related Information --- //
    [
        "TN_round_started",
        {
            TN_tracker_cookOffs = [];
            player setVariable ["TN_burnInstigator", nil];
            player setVariable ["TN_burnInstigatorTime", nil];
            player setVariable ["TN_burnWeapon", nil];
            // Burn info of other players locally is not
            // reset, but should be fine.
        }
    ] call CBA_fnc_addEventHandler;
};

true
