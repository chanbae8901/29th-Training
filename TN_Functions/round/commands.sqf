#include "script_component.hpp"

[
    [
        /* --- !timer --- */
        [
            "timer", {
                private _argument = _this select 0;
                private _minutes = abs (parseNumber _argument);
                [_minutes * 60] call FUNC(setTimer);
                systemChat format ["Timer set for %1 Minutes", _minutes];
            }
        ],

        /* --- !live --- */
        [
            "live", {
                if ([] call FUNC(start)) then {
                    systemChat "Starting Round!";
                } else {
                    systemChat "Error: Timer already running!";
                };
            }
        ],

        /* --- !quicktimer --- */
        [
            "quicktimer", {
                private _argument = _this select 0;
                private _timerQuick = abs (parseNumber _argument);
                if ([_timerQuick * 60] call FUNC(start)) then {
                    systemChat format ["Starting %1 Minute round!", _timerQuick];
                } else {
                    systemChat "Error: Timer already running! Use '!addtime' if you want to add time";
                };
            }
        ],

        /* --- !addtime --- */
        [
            "addtime", {
                private _argument = _this select 0;
                private _timeAdd = parseNumber _argument;
                if ([_timeAdd * 60] call FUNC(addTime) isNotEqualTo -1) then {
                    systemChat format ["Adding %1 Minutes to the time limit!", _timeAdd];
                } else {
                    systemChat "Error: No active timer! Use '!quicktimer' if you want to start a timer quickly";
                };
            }
        ],

        /* --- !game --- */
        [
            "game", {
                if (NOT_ROUND_LIVE) then {
                    [
                        "<t color='#ffffff' size='5'>GAME!</t>",
                        "PLAIN",
                        0.4
                    ] remoteExecCall [QEFUNC(common,displayMsg)];
                    systemChat "No timer running! Only displaying end game message!";
                } else {
                    call FUNC(end);
                    systemChat "Calling Game!";
                };
            }
        ],

        /* --- !ready --- */
        [
            "ready", {
                // Works based off of local player's side.
                private _result = [playerSide, true] call FUNC(manageReady);
                systemChat (["Setting side ready!", "Error: Round already started!", "Error: Side is already ready!"] select _result);
                if (_result isEqualTo 0) then {
                    private _msg = format ["%1 readied %2.", name player, [playerSide] call EFUNC(common,convertSide)];
                    _msg remoteExecCall ["systemChat", -clientOwner];
                };
            }
        ],

        /* --- !unready --- */
        [
            "unready", {
                private _result = [playerSide, false] call FUNC(manageReady);
                systemChat (["Setting side unready!", "Error: Round already started!", "Error: Side is already unready!"] select _result);
                if (_result isEqualTo 0) then {
                    private _msg = format ["%1 unreadied %2.", name player, [playerSide] call EFUNC(common,convertSide)];
                    _msg remoteExecCall ["systemChat", -clientOwner];
                };
            }
        ],

        /* --- !safe --- */
        [
            "safe", {
                private _argument = _this select 0;
                private _minutes = abs (parseNumber _argument);
                if (_minutes > 0) then {
                    switch (true) do {
                        case (ROUND_LIVE): {
                            systemChat "Error: Round is currently active!";
                        };
                        case (NOT_ROUND_SAFE): {
                            [_minutes * 60, true] call FUNC(initSafeStart);
                            systemChat "Forcing Safe Start!";
                        };
                        default {
                            if (call FUNC(checkAllSidesReady)) exitWith {
                                systemChat "Error: All teams are already ready!";
                            };
                            [_minutes * 60] call FUNC(changeForcedSafeStart);
                            systemChat "Changing forced safestart!";
                        };
                    };
                } else {
                    if ([0] call FUNC(changeForcedSafeStart)) then {
                        systemChat "Safe start is no longer forced and will end if all teams are not ready!";
                    } else {
                        systemChat "Error: No safe start active!";
                    };
                };
            }
        ]
    ],
    [
        ["timer", "Sets countdown timer length, specified in minutes (E.G. '!timer 20' sets the timer length to 20 minutes)"],
        ["live", "Starts a countdown timer, specified by !timer"],
        ["addtime", "Adds time to the current timer, specified in minutes (negative values subtract)"],
        ["quicktimer", "Starts a round with specified time instantly, specified in minutes (E.G. '!quicktimer 20' creates a 20 minute round)"],
        ["game", "Displays game notification and ends any currently running round"],
        ["ready", "Sets the player's side as ready, and begins the safe start if all player sides are ready"],
        ["unready", "Cancels the ready status for the player's side"],
        ["safe", "Forces safe start with a specified time in minutes, or unforce safe start if given 0 (E.G. '!safe 1' forces a 1 minute safe start)"]
    ],
    [
        ["ready", 0],
        ["unready", 0]
    ]
] call EFUNC(commands,addModule);
