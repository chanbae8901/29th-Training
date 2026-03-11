/**
 * DOTT_loadout_fnc_flexibleReset
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
 *       spawn DOTT_loadout_fnc_flexibleReset;
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

// If inventory array isn't empty, load specified inventory.
private _resetInventory = false;

if (_inventory isEqualTo true) then
{
    _inventory =
        missionNamespace getVariable ["resetLoadout", []];
};

if (count _inventory != 0) then
{
    if (!isNil
        {missionNamespace getVariable
            "BIS_EGSpectator_initialized"}) exitWith
    {
        systemChat
            "Player in spectator, skipping rearm.";
    };

    if (arsenalActionId != -1) exitWith
    {
        systemChat "Player in base, skipping rearm.";
    };

    [player, _inventory, true]
        spawn DOTT_loadout_fnc_fullSetUnitLoadout;

    // Set to true for switch below.
    _resetInventory = true;
};

if (_heal) then
{
    // Call ACE medical treatment function.
    [player] call ACE_medical_treatment_fnc_fullHealLocal;

    if (["ace_hearing"] call ace_common_fnc_isModLoaded) then
    {
        ace_hearing_deafnessDV = 0;
    };
};

private _pointCount = count _point;
private _teleport = false;

// True if array is less than required size for teleport.
if (_pointCount < 3) then
{
    // If array isn't empty, then it was the wrong size, provide
    // error message to client.
    if (_point isNotEqualTo []) then
    {
        hint
            "DOTT_fnc_roundReset Error:"
            + " Position Array wrong size!";
    };
}
else
{
    // Otherwise if array is correct size, then teleport requested.

    // In case player was dead during teleport call, wait up to
    // 30 seconds for player to respawn.
    private _timeStart = time;
    waitUntil
    {
        sleep 1;
        time - _timeStart > 30
            || (!isNull player && alive player)
    };

    // Kick player out of spectator.
    call DOTT_spectator_fnc_exit;

    DOTT_loadout_teleporting = true;

    // Try multiple times if it fails for whatever reason.
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

        // Check distance to point and compare to _pointRad,
        // if less then skip teleport.
        private _pointDist = player distance2D _point;
        if (_pointDist < _pointRad || !alive player)
            exitWith {};

        // Cut to black with teleporting title.
        titleText [
            "<t color='#ffffff' size='4'>"
                + "Teleporting...</t>",
            "BLACK OUT", 0.5, true, true
        ];

        sleep 0.1;

        // Damage off to prevent death/accidents during teleport.
        // Force player out of vehicle if they're in one.
        moveOut player;
        sleep 0.1;

        // Set player's position to specified point (ASL).
        private _dir = random 359;
        player setPosASL [
            (_point select 0) - 6 * sin(_dir),
            (_point select 1) - 6 * cos(_dir),
            (_point select 2)
        ];
        sleep 0.1;

        // Check if the player is touching ground.
        private _ground = isTouchingGround player;

        // If not touching ground then...
        if (!_ground) then
        {
            // Get current height above water/terrain/objects.
            private _curr = getPos player;
            private _height = _curr select 2;

            // If more than 2 meters in height set height to
            // water/terrain.
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

    // Return to normal state.
    [] spawn
    {
        sleep 2;
        player allowDamage true;
        DOTT_loadout_teleporting = nil;
    };

    // Teleport true for switch below.
    _teleport = _tries > 0;
};

// If no msgClass, use defaults below.
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
    };
};

//rest isn't implemented yet!
