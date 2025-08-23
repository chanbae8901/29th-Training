/*
 * Name:	fnc_init
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Sets up the initial state of the round management system.
 * Sets up scoreboard blocking mid round.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_round_fnc_init;
 * 
 */

if (isServer) then 
{
	bluReady = false;
	opfReady = false;	
	grnReady = false;
	timerLength = 20*60; 
	overtimeEnabled = false; 
	overtimePeriod = 5*60; 

	publicVariable "bluReady";
	publicVariable "opfReady";	
	publicVariable "grnReady";
	publicVariable "timerLength";
	publicVariable "overtimeEnabled";
	publicVariable "overtimePeriod";
};

if (hasInterface) then
{
	//For JIP players
	//showScoreTable silently fails if called too early
	addMissionEventHandler ["PreloadFinished", {
		if (call DOTT_round_fnc_isRoundActive) then {
			showScoreTable 0;
		};
		removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
	}];

	//prevent scoreboard in respawn menu (hacky)
	[] spawn 
	{
		waitUntil {!isNull player};
		player addEventHandler ["Killed", 
		{		
			disableRespawnScoreboard = addMissionEventHandler 
			[
				"Draw2D", 
				{
					if(visibleScoretable && call DOTT_round_fnc_isRoundActive) then { showScoretable 0 };
				}
			];
		}];
	};

	//needs to be readded every life
	[] spawn 
	{
		waitUntil {!isNull player};
		player addEventHandler ["Respawn", 
		{
			if (call DOTT_round_fnc_isRoundActive) then 
			{	
				[] spawn 
				{
					waitUntil {shownScoreTable == -1};
					showScoreTable 0;
				};
			};

			removeMissionEventHandler["Draw2D", disableRespawnScoreboard];
		}];
	};

	//allow player in zeus to see scoreboard
	[] spawn 
	{
		waitUntil {!isNull (findDisplay 46)};
		findDisplay 46 displayAddEventHandler ["KeyDown", {
			if (isNull (getAssignedCuratorLogic player)) exitWith {};
			if (inputAction "CuratorInterface" <= 0) exitWith {};
			
			showScoretable -1;

			[] spawn 
			{
				waitUntil {!isNull (findDisplay 312)};				
				findDisplay 312 displayAddEventHandler ["KeyDown", 
				{
					if (inputAction "CuratorInterface" > 0) then
					{
						if (call DOTT_round_fnc_isRoundActive) then { showScoretable 0 };
					};
					false
				}];	
			};

			false
		}];	
	};

	[
		"DOTT_round_started",
		{
			if (isNil { missionNamespace getVariable "BIS_EGSpectator_initialized" } &&
				isNull (uiNamespace getVariable ["RscDisplayCurator", displayNull])) then
			{ showScoretable 0 };							
		} 
	] call CBA_fnc_addEventHandler;

	[
		"exitedSpectator",
		{
			if (call DOTT_round_fnc_isRoundActive) then { showScoretable 0 };							
		} 
	] call CBA_fnc_addEventHandler;

	[
		"enteredSpectator",
		{
			showScoretable -1;							
		} 
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_ended",
		{
			showScoretable -1;							
		} 
	] call CBA_fnc_addEventHandler;	
};


true