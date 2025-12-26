/******** CONFIG ********/
call compile preprocessFileLineNumbers "eventSettings.sqf";

/******* Timer ********/
if (DOTT_event_hasTimer) then
{
	if (hasInterface) then
	{
		call DOTT_event_fnc_flagActions;
	};

	if (isServer) then
	{
		[
			"DOTT_round_started",
			{
				[] spawn DOTT_event_fnc_checkWinCondition;		
			} 
		] call CBA_fnc_addEventHandler;	
	};
};

/******* AliveCheck ********/
if (DOTT_event_hasAliveCheck || DOTT_event_numberOfLives > 0) then
{
	if (isNil "DOTT_event_spectateArea") then
	{
		systemChat "WARNING: Spectate area object (spectateArea) not found!";
	};
};

if (DOTT_event_hasAliveCheck) then
{
	if (isServer) then
	{
		[
			"DOTT_round_started",
			{
				[] spawn DOTT_event_fnc_aliveCheck;					
			} 
		] call CBA_fnc_addEventHandler;	
	};
};

if (DOTT_event_numberOfLives > 0) then
{
	if (hasInterface) then
	{
		[] spawn 
		{
			waitUntil {!isNull player};
			player addEventHandler ["Respawn", 
			{
				[] spawn DOTT_event_fnc_respawn;
			}];
		};	
	};
};

/******* Time Accleration ********/
if (isServer) then
{
	[
		"DOTT_round_started",
		{
			setTimeMultiplier DOTT_event_timeAcc;
		} 
	] call CBA_fnc_addEventHandler;
};

/******* Auto Mark Editor Objects ********/
if (hasInterface) then
{
	if (DOTT_event_autoMarkObjects) then
	{
		call DOTT_event_fnc_markEditorPlacedObjects;
	};
};