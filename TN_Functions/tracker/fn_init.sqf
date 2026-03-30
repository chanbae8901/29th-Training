#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes the tracker system on both server and client.
 * Projectiles created by players have weapon/player info saved
 * onto them, which transfers to any alive player/vehicle on hit.
 * On unconscious/death events, this info is used to record the
 * event server-side, then released to clients via Map Diary at
 * end of round.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 */

if (("enableRoundEventLog" call BIS_fnc_getParamValue) isNotEqualTo 1) exitWith {};

if (isServer) then {
    GVAR(previous) = [];
    GVAR(events) = [];
    GVAR(names) = [];
    GVAR(sides) = [];
    GVAR(weapons) = [];
    GVAR(currentRound) = 1;

    GVAR(startTime) = -1;
    publicVariable QGVAR(startTime);

    [
        QEGVAR(round,started), {
            GVAR(startTime) = serverTime;
            publicVariable QGVAR(startTime);

            GVAR(events) = [];
            GVAR(names) = [];
            GVAR(sides) = [];
            GVAR(weapons) = [];

            // Reset all hit info on players at start
            // of round.
            private _players = allPlayers - entities "HeadlessClient_F";
            {
                _x setVariable [QGVAR(lastHit), nil];
                _x setVariable [QGVAR(hitMap), createHashMap];
            }
            forEach _players;
        }
    ] call CBA_fnc_addEventHandler;

    // --- Kill --- //
    addMissionEventHandler ["EntityKilled", {
        params ["_unit", "_killer", "_instigator"];
        if !(isPlayer _unit
            || (!(_unit isKindOf "Man")
                && _unit isKindOf "AllVehicles"))
            exitWith {};

        // remoteExecCall for sending info occurs 1
        // frame later so wait.
        [ {
                call FUNC(recordKill);
            },
            _this, 0.75 // Delay to wait for info from clients.
        ] call CBA_fnc_waitAndExecute;
    }];

    addMissionEventHandler ["EntityRespawned", {
        params ["_unit"];
        _unit setVariable [QGVAR(lastHit), nil];
        _unit setVariable [QGVAR(hitMap), nil];
    }];

    // --- Consciousness --- //
    [
        "ace_unconscious", {
            // remoteExecCall for sending info occurs 1
            // frame later so wait.
            [ {
                    call FUNC(recordACEConscious);
                },
                _this, 0.5
            ] call CBA_fnc_waitAndExecute;
        }
    ] call CBA_fnc_addEventHandler;

    // --- Tracker Diary --- //
    [
        QEGVAR(round,ended), {
            GVAR(startTime) = -1;
            // Wait for any last second events from
            // the network.
            [ {
                    publicVariable QGVAR(startTime);
                    [
                        GVAR(events),
                        GVAR(names),
                        GVAR(sides),
                        GVAR(weapons),
                        GVAR(currentRound)
                    ] remoteExecCall [QFUNC(createDiaryEntries)];

                    GVAR(previous) pushBack
                    [
                        +GVAR(events),
                        +GVAR(names),
                        +GVAR(sides),
                        +GVAR(weapons)
                    ];

                    GVAR(currentRound) = GVAR(currentRound) + 1;
                },
                [], 1
            ] call CBA_fnc_waitAndExecute;
        }
    ] call CBA_fnc_addEventHandler;

    // --- Sector Capture --- //
    ["ModuleSector_F", "Init", {
        params ["_entity"];
        [_entity, "ownerChanged", {
            call FUNC(recordSectorCapture);
        }] call BIS_fnc_addScriptedEventHandler;
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    // Store name as it gets deleted automatically later.
    addMissionEventHandler ["EntityKilled", {
        params ["_unit"];
        if (_unit isKindOf "Man") then {

            _unit setVariable [QGVAR(name), name _unit, true];
        };
    }];
};

if (hasInterface) then {
    // --- Attacker Info --- //
    GVAR(cookOffs) = [];

    [
        { !isNull player },
        { call FUNC(addEventHandlersClient) }
    ] call CBA_fnc_waitUntilAndExecute;

    GVAR(weaponNameCache) = createHashMap;
    // --- Remove Statistics from Map, Send All
    //     Round Histories --- //
    [
        QEGVAR(common,preloadFinished), {
            [player] remoteExecCall [QFUNC(sendAll), 2];
            player removeDiarySubject "Statistics";
        }
    ] call CBA_fnc_addEventHandler;

    // --- Fire/Burn Related Information --- //
    [
        QEGVAR(round,started), {
            GVAR(cookOffs) = [];
            player setVariable [QGVAR(burnInstigator), nil];
            player setVariable [QGVAR(burnInstigatorTime), nil];
            player setVariable [QGVAR(burnWeapon), nil];
            // Burn info of other players locally is not
            // reset, but should be fine.
        }
    ] call CBA_fnc_addEventHandler;
};

nil
