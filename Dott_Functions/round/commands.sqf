[
    [
        /* --- !timer --- */
        [
            "timer",
            {
                private _argument = _this select 0;
                private _minutes = abs (parseNumber _argument);
                [_minutes * 60] call TN_round_fnc_setTimer;
                systemChat format ["Timer set for %1 Minutes", _minutes];
            }
        ],

        /* --- !live --- */
        [
            "live",
            {
                if ([] call TN_round_fnc_start) then
                {
                    systemChat "Starting Round!";
                }
                else
                {
                    systemChat "Error: Timer already running!";
                };
            }
        ],

        /* --- !quicktimer --- */
        [
            "quicktimer",
            {
                private _argument = _this select 0;
                private _timerQuick = abs (parseNumber _argument);
                if ([_timerQuick * 60] call TN_round_fnc_start) then
                {
                    systemChat format ["Starting %1 Minute round!", _timerQuick];
                }
                else
                {
                    systemChat "Error: Timer already running! Use '!addtime' if you want to add time";
                };
            }
        ],

        /* --- !addtime --- */
        [
            "addtime",
            {
                private _argument = _this select 0;
                private _timeAdd = parseNumber _argument;
                if ([_timeAdd * 60] call TN_round_fnc_addTime != -1) then
                {
                    systemChat format ["Adding %1 Minutes to the time limit!", _timeAdd];
                }
                else
                {
                    systemChat "Error: No active timer! Use '!quicktimer' if you want to start a timer quickly";
                };
            }
        ],

        /* --- !game --- */
        [
            "game",
            {
                if !(call TN_round_fnc_isRoundActive) then
                {
                    [
                        "<t color='#ffffff' size='5'>GAME!</t>",
                        "PLAIN",
                        0.4
                    ] remoteExecCall ["TN_common_fnc_displayMsg"];
                    systemChat "No timer running! Only displaying end game message!";
                }
                else
                {
                    [true] call TN_round_fnc_end;
                    systemChat "Calling Game!";
                };
            }
        ],

        /* --- !overtime --- */
        [
            "overtime",
            {
                private _argument = _this select 0;
                // Overtime can't be negative!
                private _minutes = abs (parseNumber _argument);
                if (_minutes > 0) then
                {
                    [true] call TN_round_fnc_setOvertimeEnabled;
                    [_minutes * 60] call TN_round_fnc_setOverTimePeriod;
                    systemChat format ["Overtime set for %1 Minutes", _minutes];
                }
                else
                {
                    [false] call TN_round_fnc_setOvertimeEnabled;
                    systemChat "Overtime Disabled";
                };
            }
        ],

        /* --- !ready --- */
        [
            "ready",
            {
                // Works based off of local player's side.
                private _result = [playerSide, true] call TN_round_fnc_manageReady;
                switch (_result) do
                {
                    case 0:
                    {
                        systemChat "Setting side ready!";
                    };
                    case 1:
                    {
                        systemChat "Error: Round already started!";
                    };
                    case 2:
                    {
                        systemChat "Error: Side is already ready!";
                    };
                    default {};
                };
            }
        ],

        /* --- !unready --- */
        [
            "unready",
            {
                private _result = [playerSide, false] call TN_round_fnc_manageReady;
                switch (_result) do
                {
                    case 0:
                    {
                        systemChat "Setting side unready!";
                    };
                    case 1:
                    {
                        systemChat "Error: Round already started!";
                    };
                    case 2:
                    {
                        systemChat "Error: Side is already unready!";
                    };
                    default {};
                };
            }
        ],

        /* --- !safe --- */
        [
            "safe",
            {
                private _argument = _this select 0;
                // Overtime can't be negative!
                private _minutes = abs (parseNumber _argument);
                if (_minutes > 0) then
                {
                    switch (true) do
                    {
                        case (call TN_round_fnc_isRoundActive):
                        {
                            systemChat "Error: Round is currently active!";
                        };
                        case (!TN_round_safeStartActive):
                        {
                            [_minutes * 60, true] call TN_round_fnc_initSafeStart;
                            systemChat "Forcing Safe Start!";
                        };
                        default
                        {
                            if (call TN_round_fnc_checkAllSidesReady) exitWith
                            {
                                systemChat "Error: All teams are already ready!";
                            };
                            [_minutes * 60] call TN_round_fnc_changeForcedSafeStart;
                            systemChat "Changing forced safestart!";
                        };
                    };
                }
                else
                {
                    if ([0] call TN_round_fnc_changeForcedSafeStart) then
                    {
                        systemChat "Safe start is no longer forced and will end if all teams are not ready!";
                    }
                    else
                    {
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
        ["quicktimer", "Starts a countdown timer, specified in minutes (E.G. '!quicktimer 20' creates a 20 minute timer)"],
        ["overtime", "Creates an overtime period that occurs when the timer ends, a value of 0 disables overtime. Overtime must be reapplied for each timer"],
        ["game", "Calls game and ends any countdown"],
        ["ready", "Sets the player's side as ready, and begins the safe start if all player sides are ready"],
        ["unready", "Cancels the ready status for the player's side"],
        ["safe", "Forces safe start with a specified time in minutes, or unforce safe start if given 0 (E.G. '!safe 1' forces a 1 minute safe start)"]
    ]
] call TN_commands_fnc_addModule;
