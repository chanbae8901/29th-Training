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
                    TN_ticket_enabled = true;
                    publicVariable "TN_ticket_enabled";
                };

                // Only allow '!tickets enable' if system
                // is disabled.
                if (!TN_ticket_enabled) exitWith
                {
                    systemChat "Error: You must enable the ticket system first with '!tickets enable'";
                };

                // '!tickets' with no argument to see current
                // ticket values.
                if (_argument isEqualTo "") exitWith
                {
                    systemChat format [
                        "Current Tickets: Blu: %1, Opf: %2, Grn: %3",
                        TN_ticket_WEST,
                        TN_ticket_EAST,
                        TN_ticket_GUER
                    ];
                };

                // Filter out side and number the admin provides.
                private _filterAmount = [
                    _argument, "-0123456789"
                ] call BIS_fnc_filterString;
                private _filterArg = [
                    _argument, "abcdefghijklmnopqrstuvwxyz"
                ] call BIS_fnc_filterString;
                private _ticketAmount = parseNumber _filterAmount;

                switch (_filterArg) do
                {
                    case "blufor":
                    {
                        systemChat format [
                            "Changing Blufor tickets by %1",
                            _ticketAmount
                        ];
                        ["WEST", _ticketAmount] call TN_ticket_fnc_add;
                    };
                    case "opfor":
                    {
                        systemChat format [
                            "Changing Opfor tickets by %1",
                            _ticketAmount
                        ];
                        ["EAST", _ticketAmount] call TN_ticket_fnc_add;
                    };
                    case "grnfor":
                    {
                        systemChat format [
                            "Changing Grnfor tickets by %1",
                            _ticketAmount
                        ];
                        ["GUER", _ticketAmount] call TN_ticket_fnc_add;
                    };
                    case "reset":
                    {
                        systemChat "Resetting tickets to zero!";
                        ["reset"] call TN_ticket_fnc_add;
                    };
                    case "disable":
                    {
                        // Case for disable at the end.
                        systemChat "Ticket system disabled!";
                        TN_ticket_enabled = false;
                        publicVariable "TN_ticket_enabled";
                        TN_ticket_WEST = 0;
                        publicVariable "TN_ticket_WEST";
                        TN_ticket_EAST = 0;
                        publicVariable "TN_ticket_EAST";
                        TN_ticket_GUER = 0;
                        publicVariable "TN_ticket_GUER";
                    };
                    default
                    {
                        systemChat "Error: Invalid input! Must be 'blufor', 'opfor', 'grnfor',  'reset', 'enable', 'disable'";
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
] call TN_commands_fnc_addModule;
