#include "script_component.hpp"
/*
 * Author: Dott [29th ID]
 * Optionally loads saved inventory, heals player, teleports
 * them to a position, and notifies them.
 * Must be spawned on client.
 *
 * Arguments:
 * 0: CBA extended loadout array, or true to use the saved resetLoadout variable <ARRAY|BOOL> (default: [])
 * 1: True to ACE full-heal the player <BOOL> (default: false)
 * 2: Position ASL to teleport to <ARRAY> (default: [])
 * 3: Skip teleport if player is already within this distance of position <NUMBER> (default: 50)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [resetLoadout, true, getPosASL _pos] spawn TN_loadout_fnc_flexibleReset;
 */

params
[
    ["_inventory", [], [[], true]],
    ["_heal", false, [false]],
    ["_point", [], [[]]],
    ["_pointRad", 50, [0]]
];

if (!hasInterface) exitWith {}; // Client only.

private _resetInventory = false;

if (_inventory isEqualTo true) then {
    _inventory = missionNamespace getVariable ["resetLoadout", []];
};

if (_inventory isNotEqualTo []) then {
    if (EGVAR(spectator,active)) exitWith {
        systemChat "Player in spectator, skipping rearm.";
    };

    if (missionNamespace getVariable [QEGVAR(base,inArsenalZone), false]) exitWith {
        systemChat "Player in base, skipping rearm.";
    };

    [player, _inventory, true] call FUNC(fullSetUnitLoadout);

    _resetInventory = true;
};

if (_heal) then {
    [player] call ACE_medical_treatment_fnc_fullHealLocal;

    if (["ace_hearing"] call ace_common_fnc_isModLoaded) then {
        ace_hearing_deafnessDV = 0;
    };
};

private _pointCount = count _point;
private _teleport = false;

if (_pointCount < 3) then {
    if (_point isNotEqualTo []) then {
        ["TN_fnc_roundReset Error: Position Array wrong size!"] call EFUNC(common,timedHint);
    };
} else {
    // Wait up to 30 seconds for player to respawn if they died
    // during the teleport call.
    private _timeStart = time;
    waitUntil {
        sleep 1;
        time - _timeStart > 30
            || (!isNull player && alive player)
    };

    call EFUNC(spectator,exit);

    GVAR(teleporting) = true;

    private _tries = 0;

    player allowDamage false;

    while {_tries < 3} do {
        waitUntil {
            uiSleep 0.1;
            !(player getVariable
                ["emr_main_isClimbing", false])
        };

        private _pointDist = player distance2D _point;
        if (_pointDist < _pointRad || !alive player)
            exitWith {};

        titleText [
            "<t color='#ffffff' size='4'>"
                + "Teleporting...</t>",
            "BLACK OUT", 0.5, true, true
        ];

        sleep 0.1;

        moveOut player;
        sleep 0.1;

        private _dir = random 359;
        player setPosASL [
            (_point select 0) - 6 * sin(_dir),
            (_point select 1) - 6 * cos(_dir),
            (_point select 2)
        ];
        sleep 0.1;

        private _ground = isTouchingGround player;

        if (!_ground) then {
            private _curr = getPos player;
            private _height = _curr select 2;

            // Snap to ground if floating above 2m.
            if (_height > 2) then {
                player setPos [
                    _curr select 0,
                    _curr select 1,
                    0
                ];
            } else {
                // Otherwise a little extra time to fall.
                sleep 0.4;
            };
        };

        sleep 0.2;

        titleText [
            "<t color='#ffffff' size='4'>"
                + "Teleporting...</t>",
            "BLACK IN", 0.5, true, true
        ];

        _tries = _tries + 1;
    };

    [{
        player allowDamage true;
        GVAR(teleporting) = nil;
    }, [], 2] call CBA_fnc_waitAndExecute;

    _teleport = _tries > 0;

    if (_teleport) then {
        [{
            params ["_point"];
            if (player distance2D _point > 75) then {
                private _msg = format
                [
                    "Error: %1 was not teleported.",
                    name player
                ];
                _msg remoteExecCall ["systemChat", 0];
            };
        }, [_point], 5] call CBA_fnc_waitAndExecute;
    };
};

switch (true) do {
    case (_resetInventory && !_heal && !_teleport): {
        ["Reset", ["Rearmed", "Player is Rearmed!"]]
            call BIS_fnc_showNotification;
    };
    case (_resetInventory && _heal && !_teleport): {
        ["Reset", ["Reset", "Rearmed and Healed!"]]
            call BIS_fnc_showNotification;
    };
    case (_resetInventory && _heal && _teleport): {
        ["Reset",
            ["Full Reset",
                "Rearmed, healed, and teleported!"]]
            call BIS_fnc_showNotification;
    };
    case (!_resetInventory && _heal && _teleport): {
        ["Document",
            ["Debrief", "Teleported for debrief!"]]
            call BIS_fnc_showNotification;
    };
    case (!_resetInventory && !_heal && _teleport): {
        ["Document",
            ["Teleported", "Player teleported!"]]
            call BIS_fnc_showNotification;
    };
    case (!_resetInventory && _heal && !_teleport): {
        ["Health", ["Healed", "Player is healed!"]]
            call BIS_fnc_showNotification;
    };
    default {};
};

nil
