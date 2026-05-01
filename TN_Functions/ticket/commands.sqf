#include "script_component.hpp"

[
    [
        [
            "tickets", {
                private _argument = _this select 0;
                _argument = toLower _argument;

                if (_argument isEqualTo "enable") exitWith {
                    if (GVAR(enabled)) exitWith {
                        systemChat "Ticket system is already enabled!";
                    };
                    [true] call FUNC(reset);
                    systemChat "Ticket system enabled!";
                };

                if (!GVAR(enabled)) exitWith {
                    systemChat "Error: You must enable the ticket system first with '!tickets enable'";
                };

                if (_argument isEqualTo "") exitWith {
                    private _currentCounts = if (ROUND_LIVE) then {GVAR(counts)} else {GVAR(startingCounts)};
                    systemChat format [
                        "Current Tickets: Blu: %1, Opf: %2, Grn: %3",
                        _currentCounts select 1,
                        _currentCounts select 0,
                        _currentCounts select 2
                    ];
                };

                private _parts = _argument splitString " ";
                private _sideArg = _parts select 0;

                if (_sideArg isEqualTo "reset") exitWith {
                    call FUNC(reset);
                    systemChat "Tickets reset to zero!";
                    ["All tickets reset to zero!"] remoteExecCall [QEFUNC(common,timedHint)];
                };

                if (_sideArg isEqualTo "disable") exitWith {
                    [false] call FUNC(reset);
                    systemChat "Ticket system disabled!";
                };

                private _side = [_sideArg] call EFUNC(common,convertSide);

                if (_side isEqualTo sideUnknown) exitWith {
                    systemChat "Error: Invalid input! Must be 'blufor', 'opfor', 'grnfor', 'reset', 'enable', 'disable'";
                };

                if (count _parts < 2) exitWith {
                    systemChat "Error: Missing ticket amount! E.G. '!tickets blufor 10'";
                };

                private _amountArg = _parts select 1;
                private _firstChar = _amountArg select [0, 1];
                private _isRelative = _firstChar in ["+", "-"];
                private _rest = _amountArg select [if (_isRelative) then {1} else {0}];

                if (_rest isEqualTo "" || {_rest isNotEqualTo ([_rest, "0123456789"] call BIS_fnc_filterString)}) exitWith {
                    systemChat "Error: Invalid number! E.G. '!tickets blufor 10' or '!tickets blufor +5'";
                };

                private _amount = parseNumber _amountArg;

                private _sideID = _side call BIS_fnc_sideID;
                private _newTotal = if (_isRelative) then {
                    private _currentCounts = if (ROUND_LIVE) then {GVAR(counts)} else {GVAR(startingCounts)};
                    (_currentCounts select _sideID) + _amount
                } else {
                    _amount
                };

                [_side, _newTotal] call FUNC(set);

                private _displayTotal = _newTotal max 0;
                systemChat format ["Set %1 tickets to %2", toUpper _sideArg, _displayTotal];
            }
        ]
    ],
    [
        [
            "tickets",
            "'!tickets enable'/'disable' to toggle the system. " +
            "'!tickets' shows current values. " +
            "'!tickets Blufor 10' sets Blufor to exactly 10 tickets. " +
            "Use + or - to add or subtract from the current count " +
            "(e.g. '!tickets Blufor +5' to add 5, '!tickets Blufor -3' to remove 3). " +
            "'!tickets reset' sets all tickets to zero. " +
            "When the round is not live, changes set the starting tickets which are restored each round. " +
            "When the round is live, changes apply to the current round only."
        ]
    ]
] call EFUNC(commands,addModule);
