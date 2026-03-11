[
    [
        [
            "tickets",
            {
                private _argument = _this select 0;
                _argument = toLower _argument;

                // Enable ticket system.
                if (_argument isEqualTo "enable") exitWith
                {
                    systemChat "Ticket system enabled!";
                    DOTT_ticketEnabled = true;
                    publicVariable "DOTT_ticketEnabled";
                };

                // Only allow '!tickets enable' if system
                // is disabled.
                if (!DOTT_ticketEnabled) exitWith
                {
                    systemChat
                        "Error: You must enable the ticket system first with '!tickets enable'";
                };

                // '!tickets' with no argument to see current
                // ticket values.
                if (_argument isEqualTo "") exitWith
                {
                    systemChat format [
                        "Current Tickets: Blu: %1, Opf: %2, Grn: %3",
                        DOTT_ticketWEST,
                        DOTT_ticketEAST,
                        DOTT_ticketGUER
                    ];
                };

                // Filter out side and number the admin provides.
                private _filterAmount = [
                    _argument, "-0123456789"
                ] call BIS_fnc_filterString;
                private _filterArg = [
                    _argument, "abcdefghijklmnopqrstuvwxyz"
                ] call BIS_fnc_filterString;
                private _ticketAmount =
                    parseNumber _filterAmount;

                switch (_filterArg) do
                {
                    case "blufor":
                    {
                        systemChat format [
                            "Changing Blufor tickets by %1",
                            _ticketAmount
                        ];
                        ["WEST", _ticketAmount]
                            call DOTT_ticket_fnc_add;
                    };
                    case "opfor":
                    {
                        systemChat format [
                            "Changing Opfor tickets by %1",
                            _ticketAmount
                        ];
                        ["EAST", _ticketAmount]
                            call DOTT_ticket_fnc_add;
                    };
                    case "grnfor":
                    {
                        systemChat format [
                            "Changing Grnfor tickets by %1",
                            _ticketAmount
                        ];
                        ["GUER", _ticketAmount]
                            call DOTT_ticket_fnc_add;
                    };
                    case "reset":
                    {
                        systemChat
                            "Resetting tickets to zero!";
                        ["reset"]
                            call DOTT_ticket_fnc_add;
                    };
                    case "disable":
                    {
                        // Case for disable at the end.
                        systemChat
                            "Ticket system disabled!";
                        DOTT_ticketEnabled = false;
                        publicVariable "DOTT_ticketEnabled";
                        DOTT_ticketWEST = 0;
                        publicVariable "DOTT_ticketWEST";
                        DOTT_ticketEAST = 0;
                        publicVariable "DOTT_ticketEAST";
                        DOTT_ticketGUER = 0;
                        publicVariable "DOTT_ticketGUER";
                    };
                    default
                    {
                        systemChat
                            "Error: Invalid input! Must be 'blufor', 'opfor', 'grnfor',  'reset', 'enable', 'disable'";
                    };
                };
            }
        ]
    ],
    [
        [
            "tickets",
            "Manages tickets and changes tickets for a given side, by the given value (E.G. '!tickets Blufor 5' will add 5 tickets to Blufor). '!tickets reset' sets all tickets to zero. '!tickets' returns the current value of all teams tickets. '!tickets enable' or 'disable' to enable/disable ticket system"
        ]
    ]
] call DOTT_commands_fnc_addModule;
