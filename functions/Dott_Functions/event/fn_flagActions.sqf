{	//if timer object is nil, set to objNull to avoid errors
	if (isNil {_x}) then 
	{
		DOTT_event_timerObjects set [_forEachIndex, objNull];
	}; 
}
forEach DOTT_event_timerObjects;

if (isNil "DOTT_event_endingObject") then
{
	DOTT_event_endingObject = objNull;
	systemChat "WARNING: Admin object (endingObject) not found!";
};

DOTT_event_currentState = 
	switch (true) do
	{
		case (call DOTT_round_fnc_isRoundActive): {2};
		case (!isNil "DOTT_round_safeStartHappened"): {1};
		default {0};
	};

//these may not be needed if we always set state on event calls, but just in case
["DOTT_round_started", 
	{
		DOTT_event_currentState = 2;
	} 
] call CBA_fnc_addEventHandler;

["DOTT_round_safeStartBegin", 
	{
		DOTT_event_currentState = 1;
	} 
] call CBA_fnc_addEventHandler;

["DOTT_round_safeStartAborted", 
	{
		DOTT_event_currentState = 0;
	} 
] call CBA_fnc_addEventHandler;


/*** Side Ready ***/
private _fnc_addSideReadyActions =
	{
		{
			private _actionId = _x addAction ["<t color='#bf3eff'>Side Ready</t>", {(_this select 3) call DOTT_round_fnc_manageReady}, [playerSide, true], 1.5, true, true, "", "true", 8];
			_x setVariable ["DOTT_sideReadyActionId", _actionId];
		} forEach DOTT_event_timerObjects;
	};

private _fnc_removeSideReadyActions =
	{
		{
			private _actionId = _x getVariable ["DOTT_sideReadyActionId", -1];
			if (_actionId != -1) then
			{
				_x removeAction _actionId;
			};
		} forEach DOTT_event_timerObjects;
	};

if (DOTT_event_currentState == 0) then
{
	private _playerSideReady = [opfReady, bluReady, grnReady] select (playerSide call BIS_fnc_sideID);
	if !(_playerSideReady) then { call _fnc_addSideReadyActions };
};

if (DOTT_event_currentState < 2) then
{
	[
		"DOTT_round_sideReadyChanged",
		{
			params ["_side", "_isReady"];
			_thisArgs params ["_fnc_addSideReadyActions", "_fnc_removeSideReadyActions"];
			if (_side != playerSide) exitWith {};
			if (_isReady) then 
			{ 
				call _fnc_removeSideReadyActions; 
			} else 
			{ 
				call _fnc_addSideReadyActions; 
			};				
		}, [_fnc_addSideReadyActions, _fnc_removeSideReadyActions]
	] call CBA_fnc_addEventHandlerArgs;
};

/*** Ready All Sides (Admin) ***/
private _fnc_addAllReadyActions =
{
	private _fnc_readyAllSides = 
	{
		[west, true] call DOTT_round_fnc_manageReady;
		[east, true] call DOTT_round_fnc_manageReady;
		[resistance, true] call DOTT_round_fnc_manageReady;
	};

	{
		private _actionId = _x addAction ["<t color='#bf3eff'>Ready All Sides (Admin)</t>", _this select 3, _fnc_readyAllSides, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];
		_x setVariable ["DOTT_allReadyActionId", _actionId];
	} forEach DOTT_event_timerObjects;

	private _actionId = DOTT_event_endingObject addAction ["<t color='#bf3eff'>Ready All Sides (Admin)</t>", _this select 3, _fnc_readyAllSides, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];
	DOTT_event_endingObject setVariable ["DOTT_allReadyActionId", _actionId];
};

private _fnc_removeAllReadyActions =
{
	{
		private _actionId = _x getVariable ["DOTT_allReadyActionId", -1];
		if (_actionId != -1) then
		{
			_x removeAction _actionId;
		};
	} forEach DOTT_event_timerObjects;

	private _actionId = DOTT_event_endingObject getVariable ["DOTT_allReadyActionId", -1];
	if (_actionId != -1) then
	{
		DOTT_event_endingObject removeAction _actionId;
	};
};

if (DOTT_event_currentState == 0) then
{
	call _fnc_addAllReadyActions;
};

[
	"DOTT_round_safeStartBegin", 
	_fnc_removeAllReadyActions
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_safeStartAborted", 
	_fnc_addAllReadyActions
] call CBA_fnc_addEventHandler;

/*** Cancel Safestart (Admin) ***/
private _fnc_unreadyAllSides = 
{
	[west, false] call DOTT_round_fnc_manageReady;
	[east, false] call DOTT_round_fnc_manageReady;
	[resistance, false] call DOTT_round_fnc_manageReady;
};
#define ADD_CANCEL_SAFESTART_ACTION (DOTT_cancelSafeStartId = DOTT_event_endingObject addAction ["<t color='#bf3eff'>Cancel Safestart (Admin)</t>", _this select 3, _fnc_unreadyAllSides, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8])
#define REMOVE_CANCEL_SAFESTART_ACTION (DOTT_event_endingObject removeAction DOTT_cancelSafeStartId)

if (DOTT_event_currentState == 1) then
{
	ADD_CANCEL_SAFESTART_ACTION;
};

[
	"DOTT_round_safeStartBegin", 
	{
		private _fnc_unreadyAllSides = _thisArgs;
		ADD_CANCEL_SAFESTART_ACTION;
	}, _fnc_unreadyAllSides
] call CBA_fnc_addEventHandlerArgs;

[
	"DOTT_round_safeStartAborted", 
	{
		REMOVE_CANCEL_SAFESTART_ACTION;
	} 
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_started", 
	{
		REMOVE_CANCEL_SAFESTART_ACTION;
	}
] call CBA_fnc_addEventHandler;

/*** Force End Safestart (Admin) ***/
#define ADD_FORCE_END_SAFESTART_ACTION (DOTT_forceEndSafeStartId = DOTT_event_endingObject addAction ["<t color='#bf3eff'>Force End Safestart (Admin)</t>", {[DOTT_event_timerLength] call DOTT_round_fnc_start}, nil, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8])
#define REMOVE_FORCE_END_SAFESTART_ACTION (DOTT_event_endingObject removeAction DOTT_forceEndSafeStartId)

if (DOTT_event_currentState == 1) then
{
	ADD_FORCE_END_SAFESTART_ACTION;
};

[
	"DOTT_round_safeStartBegin", 
	{
		ADD_FORCE_END_SAFESTART_ACTION;
	} 
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_safeStartAborted", 
	{
		REMOVE_FORCE_END_SAFESTART_ACTION;
	} 
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_started", 
	{
		REMOVE_FORCE_END_SAFESTART_ACTION;
	}
] call CBA_fnc_addEventHandler;

/*** Ending Actions (Admin) ***/
private _fnc_addEndingActions = 
{
	DOTT_event_endingObject addAction ["<t color='#bf3eff'>Neutral Ending (Admin)</t>", 
	{ 
		[true] call DOTT_event_fnc_game; 
	},
	nil, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];	

	private _allPlayers = call BIS_fnc_listPlayers;
	private _sides = [[west, "BLUFOR", "#155DFC"], [east, "OPFOR", "#B40404"], [resistance, "GRNFOR", "#088A08"]];
	{
		private _side = _x select 0;
		private _sideName = _x select 1;
		private _sideColor = _x select 2;
		if (({side group _x == _side} count _allPlayers) > 0) then
		{
			private _actionText = format ["<t color='%1'>%2 Victory (Admin)</t>", _sideColor, _sideName];
			DOTT_event_endingObject addAction [_actionText, 
			{ 
				[true, _this select 3] call DOTT_event_fnc_game; 
			},
			_side, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];		
		};
	}
	forEach _sides; 			
};

if (DOTT_event_currentState == 2) then //if JIP after round start
{
	call _fnc_addEndingActions;
} else
{
	[
		"DOTT_round_started", 
		_fnc_addEndingActions
	] call CBA_fnc_addEventHandler;	
};

[
	"DOTT_event_gameCalled", //remove all ending options after one is selected
	{
		removeAllActions DOTT_event_endingObject;
	} 
] call CBA_fnc_addEventHandler;