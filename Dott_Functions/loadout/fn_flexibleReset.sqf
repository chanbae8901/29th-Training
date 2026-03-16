/**
 * Function: TN_loadout_fnc_flexibleReset
 * Author:   Dott [29th ID]
 *
 * Purpose: Optionally loads saved inventory, heals player, teleports
 *          them to a position, and notifies them.
 *          Must be spawned on client.
 *
 * Params (all optional):
 *   _inventory - Array|Bool: CBA extended loadout array, or true to
 *                use the saved resetLoadout variable. Default: []
 *   _heal      - Bool: true to ACE full-heal the player. Default: false
 *   _point     - Array: position ASL to teleport to. Default: []
 *   _pointRad  - Number: skip teleport if player is already within
 *                this distance of _point. Default: 50
 *   _msgClass  - String: CfgNotifications class. Empty = auto-pick.
 *   _msgTitle  - String: notification title
 *   _msgDesc   - String: notification description
 *
 * Returns: Nothing
 *
 * Example:
 *   [resetLoadout, true, getPosASL _pos]
 *       spawn TN_loadout_fnc_flexibleReset;
 */

params
[
    ["_inventory", [], [[], true]],
    ["_heal", false, [false]],
    ["_point", [], [[]]],
    ["_pointRad", 50, [0]],
    ["_msgClass", "", [""]],
    ["_msgTitle", "", [""]],
    ["_msgDesc", "", [""]]
];

if (!hasInterface) exitWith {}; // Client only.

private _resetInventory = false;

if (_inventory isEqualTo true) then
{
    _inventory = missionNamespace getVariable ["resetLoadout", []];
};

if (count _inventory != 0) then
{
    if (!isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}) exitWith
    {
        systemChat "Player in spectator, skipping rearm.";
    };

    if (arsenalActionId != -1) exitWith
    {
        systemChat "Player in base, skipping rearm.";
    };

    [player, _inventory, true] spawn TN_loadout_fnc_fullSetUnitLoadout;

    _resetInventory = true;
};

if (_heal) then
{
    [player] call ACE_medical_treatment_fnc_fullHealLocal;

    if (["ace_hearing"] call ace_common_fnc_isModLoaded) then
    {
        ace_hearing_deafnessDV = 0;
    };
};

private _pointCount = count _point;
private _teleport = false;

if (_pointCount < 3) then
{
    if (_point isNotEqualTo []) then
    {
        hint "TN_fnc_roundReset Error: Position Array wrong size!";
    };
}
else
{
    // Wait up to 30 seconds for player to respawn if they died
    // during the teleport call.
    private _timeStart = time;
    waitUntil
    {
        sleep 1;
        time - _timeStart > 30
            || (!isNull player && alive player)
    };

    call TN_spectator_fnc_exit;

    TN_loadout_teleporting = true;

    private _tries = 0;

    player allowDamage false;

    while {_tries < 3} do
    {
        waitUntil
        {
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

        if (!_ground) then
        {
            private _curr = getPos player;
            private _height = _curr select 2;

            // Snap to ground if floating above 2m.
            if (_height > 2) then
            {
                player setPos [
                    _curr select 0,
                    _curr select 1,
                    0
                ];
            }
            else
            {
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

    [] spawn
    {
        sleep 2;
        player allowDamage true;
        TN_loadout_teleporting = nil;
    };

    _teleport = _tries > 0;

    if (_teleport) then
    {
        [_point] spawn
        {
            params ["_point"];
            sleep 5;
            if (player distance2D _point > 75) then
            {
                private _msg = format
                [
                    "Error: %1 was not teleported.",
                    name player
                ];
                _msg remoteExecCall ["systemChat", 0];
            };
        };
    };
};

if (_msgClass isEqualTo "") exitWith
{
    switch (true) do
    {
        case (_resetInventory && !_heal && !_teleport):
        {
            ["Reset", ["Rearmed", "Player is Rearmed!"]]
                call BIS_fnc_showNotification;
        };
        case (_resetInventory && _heal && !_teleport):
        {
            ["Reset", ["Reset", "Rearmed and Healed!"]]
                call BIS_fnc_showNotification;
        };
        case (_resetInventory && _heal && _teleport):
        {
            ["Reset",
                ["Full Reset",
                    "Rearmed, healed, and teleported!"]]
                call BIS_fnc_showNotification;
        };
        case (!_resetInventory && _heal && _teleport):
        {
            ["Document",
                ["Debrief", "Teleported for debrief!"]]
                call BIS_fnc_showNotification;
        };
        case (!_resetInventory && !_heal && _teleport):
        {
            ["Document",
                ["Teleported", "Player teleported!"]]
                call BIS_fnc_showNotification;
        };
        case (!_resetInventory && _heal && !_teleport):
        {
            ["Health", ["Healed", "Player is healed!"]]
                call BIS_fnc_showNotification;
        };
        default {};
    };
};

//rest isn't implemented yet!
