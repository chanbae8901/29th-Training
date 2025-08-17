if (isServer) then
{
	DOTT_tracker_trackedEvents = [];
	DOTT_tracker_names = [];
	DOTT_tracker_sides = [];	
	DOTT_tracker_currentRound = 0;

	DOTT_tracker_startTime = -1;	
	publicVariable "DOTT_tracker_startTime";
	[
		"DOTT_round_started",
		{
			DOTT_tracker_startTime = serverTime;
			publicVariable "DOTT_tracker_startTime";	

			DOTT_tracker_trackedEvents = [];
			DOTT_tracker_names = [];	
			DOTT_tracker_sides = [];							
		} 
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_ended",
		{
			DOTT_tracker_startTime = -1;
			DOTT_tracker_currentRound = DOTT_tracker_currentRound + 1;
			publicVariable "DOTT_tracker_startTime";
			publicVariable "DOTT_tracker_currentRound";

			publicVariable "DOTT_tracker_trackedEvents";
			publicVariable "DOTT_tracker_names";
			publicVariable "DOTT_tracker_sides";

			[] remoteExec ["DOTT_tracker_fnc_createDiaryEntry"];
		} 
	] call CBA_fnc_addEventHandler;

	// --- Sector Capture --- //
	{
		[_x, "ownerChanged", 
		{
			_this call DOTT_tracker_fnc_recordSectorCapture;
		}] call BIS_fnc_addScriptedEventHandler;
	} forEach (allMissionObjects "ModuleSector_F");

	addMissionEventHandler ["EntityCreated", 
	{
		params ["_entity"];
		if (_entity isKindOf "ModuleSector_F") then 
		{
			[_entity, "ownerChanged", 
				{ _this call DOTT_tracker_fnc_recordSectorCapture;}
			] call BIS_fnc_addScriptedEventHandler;
		};
	}];
}; 

if (hasInterface) then 
{
	// --- Kill --- //	
	player addEventHandler ["Killed", 
	{
		params ["_unit", "_killer", "_instigator"];
		[_unit, _killer, _instigator] call DOTT_tracker_fnc_recordKill;
	}];

	// --- Consciousness --- //	
	[
		"ace_unconscious", 
		{ _this call DOTT_tracker_fnc_recordACEConscious; }
	]
	call CBA_fnc_addEventHandler;	

	// --- Tracker Diary --- //
	DOTT_tracker_diary_subject = player createDiarySubject ["RoundEventLog","Round Event Log"];
};



