private _loopChecks = [[{ false }], [{ false }], [{ false }]];
private _endChecks = [[{ false }], [{ false }], [{ false }]];

{
	private _pointValue = _x getVariable ["DOTT_pointValue", 0];
	if (_pointValue == 0) then { continue };

	switch (typeOf _x) do
	{
		case "ModuleSector_F": 
		{
			[_x, "ownerChanged", 
				{
					params ["_sector", "_newOwner", "_oldOwner"];
					private _pointValue = _sector getVariable ["DOTT_pointValue", 0];
					private _newOwnerId = _newOwner call BIS_fnc_sideId;
					private _oldOwnerId = _oldOwner call BIS_fnc_sideId;

					if (_newOwnerId <= 2) then {DOTT_event_score set [_newOwnerId, (DOTT_event_score select _newOwnerId) + _pointValue]};
					if (_oldOwnerId <= 2) then {DOTT_event_score set [_oldOwnerId, (DOTT_event_score select _oldOwnerId) - _pointValue]};
				}
			] call BIS_fnc_addScriptedEventHandler;

			private _owner = _x getVariable ["owner", sideUnknown];
			private _idx = _owner call BIS_fnc_sideID;
			if (_idx <= 2) then 
			{
				DOTT_event_score set [_idx, (DOTT_event_score select _idx) + _pointValue];
			};
		}; 
		default 
		{
			_x addEventHandler ["Killed", 
			{
				params ["_unit", "_killer", "_instigator"];
				private _pointValue = _unit getVariable ["DOTT_pointValue", 0];
				private _awardTeam = _unit getVariable ["DOTT_awardTeam", sideUnknown];
				private _idx = _awardTeam call BIS_fnc_sideID;
				if (_idx <= 2) then 
				{
					DOTT_event_score set [_idx, (DOTT_event_score select _idx) + _pointValue];
				};
			}];
		}; 
	};

} forEach (allMissionObjects "all");

fn_numPoints = 
{
	params ["_sideId", "_pointsRequired"];

	DOTT_event_score select _sideId >= _pointsRequired
};

private _sideSettings =
[
	DOTT_event_opforWinConditions,
	DOTT_event_bluforWinConditions,
	DOTT_event_grnforWinConditions
];

{
	if (_x isEqualType "") then { continue }; //no win condition for this side
	private _winCon  = toLower (_x select 0);
	private _winArgs = _x select 1;
	private _atEnd = _x select 2;
	private _checkFn = switch (_winCon) do
	{
		case "points": { [fn_numPoints, [_forEachIndex, _winArgs]]; };
		default { [{ false }] };
	};

	if (_atEnd) then
	{
		_endChecks set [_forEachIndex, _checkFn];
	} else 
	{
		_loopChecks set [_forEachIndex, _checkFn];
	};
}
forEach _sideSettings;

[
	"DOTT_round_ended",
	{
		private _endChecks = _thisArgs;
		{
			private _fnCheck = _x select 0;
			private _args = [];
			if (count _x >= 2) then {_args = _x select 1};
			if (_args call _fnCheck) exitWith
			{
				private _winningSide = _forEachIndex call BIS_fnc_sideType;
				[true, _winningSide] call DOTT_event_fnc_game;
			}
		} forEach _endChecks;

		[true] call DOTT_event_fnc_game; //no side met win conditions, call neutral ending
	}, _endChecks
] call CBA_fnc_addEventHandlerArgs;

while {call DOTT_round_fnc_isRoundActive} do
{
	sleep DOTT_event_winCheckInterval;

	{
		private _fnCheck = _x select 0;
		private _args = [];
		if (count _x >= 2) then {_args = _x select 1};
		if (_args call _fnCheck) exitWith
		{
			private _winningSide = _forEachIndex call BIS_fnc_sideType;
			[true, _winningSide] call DOTT_event_fnc_game;
		}
	} forEach _loopChecks;
};