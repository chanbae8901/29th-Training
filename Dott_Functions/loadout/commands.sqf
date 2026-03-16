/*
 * Loadout Commands Module
 *
 * Registers admin chat commands for heal, rearm, reset, debrief,
 * and goto. Commands dispatch flexibleReset calls to players via
 * remoteExec, filtered by side.
 */

// Maps lowercase side name -> [engineSide, displayName].
TN_loadout_cmdSideMap = createHashMapFromArray [
    ["blufor",  [west,       "Blufor"]],
    ["opfor",   [east,       "Opfor"]],
    ["grnfor",  [resistance, "Grnfor"]]
];

// Maps side name -> reset spawn object variable name.
TN_loadout_cmdResetBases = createHashMapFromArray [
    ["blufor",  "base_res_blu"],
    ["opfor",   "base_res_red"],
    ["grnfor",  "base_res_grn"]
];

/*
 * Dispatches a flexibleReset call, either to all players or to
 * players on the named side.
 *
 * _sideName - String: "blufor", "opfor", "grnfor", or "" for all players
 * _params   - Array: parameters to pass to flexibleReset
 * _msg      - String: systemChat message. When _sideName is non-empty,
 *             %1 in the string is replaced with the side's display name.
 *
 * Returns false if side is invalid, true otherwise.
 */
TN_loadout_fnc_cmdDispatch =
{
    params ["_sideName", "_params", "_msg"];

    private _target = 0;
    private _displayName = "all";
    private _ok = true;

    if (!(_sideName isEqualTo "")) then
    {
        private _entry = TN_loadout_cmdSideMap get _sideName;
        if (isNil "_entry") then
        {
            _ok = false;
        }
        else
        {
            _target = _entry select 0;
            _displayName = _entry select 1;
        };
    };

    if (!_ok) exitWith { false };

    _params remoteExec ["TN_loadout_fnc_flexibleReset", _target];
    if (!(_msg isEqualTo "")) then { systemChat format [_msg, _displayName]; };
    true
};


[
    [
        [
            "heal",
            {
                private _side = toLower (_this select 0);

                private _ok = [_side, [[], true], "Healing %1 players!"] call TN_loadout_fnc_cmdDispatch;

                if (!_ok) then
                {
                    systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'";
                };
            }
        ],
        [
            "rearm",
            {
                private _side = toLower (_this select 0);

                private _ok = [_side, [true], "Rearming %1 players!"] call TN_loadout_fnc_cmdDispatch;

                if (!_ok) then
                {
                    systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'";
                };
            }
        ],
        [
            "reset",
            {
                private _argument = _this select 0;

                // No argument = full reset + teleport everyone.
                if (_argument isEqualTo "") exitWith
                {
                    {
                        private _baseName = TN_loadout_cmdResetBases get _x;
                        private _baseObj = missionNamespace getVariable [_baseName, objNull];
                        [_x, [true, true, getPosASL _baseObj], ""] call TN_loadout_fnc_cmdDispatch;
                    } forEach ["blufor", "opfor", "grnfor"];
                    systemChat "Rearming, healing, and teleporting all players to spawn!";
                };

                private _argArr = (toLower _argument) splitString " ";

                private _stayArg = _argArr find "stay";

                if (_stayArg != -1) exitWith
                {
                    private _sideArg = if (count _argArr > 1) then { _argArr select (1 - _stayArg) } else { "" };

                    private _ok = [_sideArg, [true, true], "Rearming and healing %1 players!"] call TN_loadout_fnc_cmdDispatch;

                    if (!_ok) then
                    {
                        systemChat "Error: Invalid input(s)! Must be 'stay', 'blufor', 'opfor', 'grnfor'";
                    };
                };

                // Side only = full reset + teleport.
                private _side = toLower _argument;
                private _baseName = TN_loadout_cmdResetBases get _side;

                if (isNil "_baseName") exitWith
                {
                    systemChat "Error: Invalid input(s)! Must be 'stay', 'blufor', 'opfor', 'grnfor'";
                };

                private _baseObj = missionNamespace getVariable [_baseName, objNull];
                [_side, [true, true, getPosASL _baseObj], "Rearming, healing, and teleporting %1 players to spawn!"] call TN_loadout_fnc_cmdDispatch;
            }
        ],
        [
            "debrief",
            {
                private _argument = _this select 0;

                if (_argument isEqualTo "") then
                {
                    private _pos = getPosASL base_res_blu;
                    ["", [true, true, _pos], "Healing, rearming, and teleporting all players to Blufor base!"] call TN_loadout_fnc_cmdDispatch;
                }
                else
                {
                    // "here": teleport everyone 15m in front of the admin.
                    private _dir = getDir player;
                    private _pos = getPosASL player;
                    private _offset = _pos getPos [15, _dir];

                    // Use offset x/y but player z (satisfies ASL requirement).
                    private _telePos = [
                        _offset select 0,
                        _offset select 1,
                        _pos select 2
                    ];

                    ["", [true, true, _telePos], "Healing, rearming, and teleporting all players to you!"] call TN_loadout_fnc_cmdDispatch;
                };

                // Timestamp used by baseObjectsInit for Force Parade triggers.
                lastDebriefTime = time;
            }
        ],
        [
            "goto",
            {
                private _argument = toLower (_this select 0);

                // Maps side name -> arsenal base variable name.
                private _arsenalBases = createHashMapFromArray [
                    ["blufor", "base_action_arsenal_blu"],
                    ["opfor",  "base_action_arsenal_red"],
                    ["grnfor", "base_action_arsenal_grn"]
                ];

                private _entry = TN_loadout_cmdSideMap get _argument;
                private _baseName = _arsenalBases get _argument;

                if (isNil "_entry" || isNil "_baseName") exitWith
                {
                    systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'";
                };

                _entry params ["_target", "_displayName"];

                private _baseObj = missionNamespace getVariable [_baseName, objNull];
                [[], false, getPosASL _baseObj] spawn TN_loadout_fnc_flexibleReset;
                systemChat format ["Teleporting to %1 spawn!", _displayName];
            }
        ]
    ],
    [
        [
            "heal",
            "ACE Heals players. '!heal' for all players, otherwise '!heal SIDE' (blufor, opfor, grnfor)"
        ],
        [
            "rearm",
            "Rearms players. '!rearm' for all players, otherwise '!rearm SIDE' (blufor, opfor, grnfor)"
        ],
        [
            "reset",
            "Rearms, heals, and (optionally) teleports players to spawn."
                + " '!reset' will rearm, heal, and teleport players to spawn."
                + " '!reset stay' will rearm and heal them."
                + " May also specify side (blufor, opfor, grnfor)"
        ],
        [
            "debrief",
            "ACE Heals and teleports players for debrief."
                + " '!debrief' to teleport all players to Blufor base,"
                + " '!debrief here' to teleport all players to your position"
        ],
        [
            "goto",
            "Teleports admin to side spawns. '!goto SIDE' (blufor, opfor, grnfor)"
        ]
    ]
] call TN_commands_fnc_addModule;
