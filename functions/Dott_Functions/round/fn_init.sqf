/*
 * Name:	DOTT_round_fnc_init
 * Date:	12/11/2025
 * Version: 1.2
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Sets up the initial state of the round management system.
 * Sets up scoreboard blocking mid round.
 * Sets up final checks for player invulnerability and silent weapon bug.
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

	//prevent scores showing up on right side UI
	[
		"DOTT_round_started",
		{
			west addScoreSide -9999;
			east addScoreSide -9999;
			independent addScoreSide -9999;							
		} 
	] call CBA_fnc_addEventHandler;	

	[
		"DOTT_round_ended",
		{
			west addScoreSide 9999;
			east addScoreSide 9999;
			independent addScoreSide 9999;							
		} 
	] call CBA_fnc_addEventHandler;	
};

if (hasInterface) then
{
	//For JIP players
	//showScoreTable silently fails if called too early
	addMissionEventHandler ["PreloadFinished", {
		if (call DOTT_round_fnc_isRoundActive && DOTT_disableScoreboard) then {
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
					if(visibleScoretable && call DOTT_round_fnc_isRoundActive && DOTT_disableScoreboard) then { showScoretable 0 };
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
			if (call DOTT_round_fnc_isRoundActive && DOTT_disableScoreboard) then 
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
		("RscMPProgress" call bis_fnc_rscLayer) cutrsc ["RscMPProgress","plain"]; //fix countdown not showing up if no sectors ever placed
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
						if (call DOTT_round_fnc_isRoundActive && DOTT_disableScoreboard) then { showScoretable 0 };
						[] spawn
						{
							sleep 0.1;
							("RscMPProgress" call bis_fnc_rscLayer) cutrsc ["RscMPProgress","plain"]; //fix countdown/sector ui not showing up after zeusing
						};
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
			if !(DOTT_disableScoreboard) exitWith {};
			if !(isNull (uiNamespace getVariable ["RscDisplayCurator", displayNull])) exitWith {};
			if (!isNil { missionNamespace getVariable "BIS_EGSpectator_initialized" } && DOTT_limitSpectator == 0) exitWith {};
			showScoretable 0;							
		} 
	] call CBA_fnc_addEventHandler;

	[
		"exitedSpectator",
		{
			if (call DOTT_round_fnc_isRoundActive && DOTT_disableScoreboard) then { showScoretable 0 };							
		} 
	] call CBA_fnc_addEventHandler;

	[
		"enteredSpectator",
		{
			if (DOTT_limitSpectator == 0) then {showScoretable -1};							
		} 
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_ended",
		{
			showScoretable -1;							
		} 
	] call CBA_fnc_addEventHandler;	
};

/*---------- Safestart Countdown Timer ---------- */
[
	"DOTT_round_safeStartBegin",
	{
		[DOTT_safeStartTime] call BIS_fnc_countdown;
	}
] call CBA_fnc_addEventHandler;

[
	"DOTT_round_safeStartAborted",
	{
		[-1] call BIS_fnc_countdown;
	}
] call CBA_fnc_addEventHandler;
/*---------- Final Checks ---------- */
if (isServer) then 
{
	//check if any player has the silent weapon bug and fix
	[
		"DOTT_round_started",
		{	
			private _players = allPlayers - entities "HeadlessClient_F";
			_players = _players select { alive _x }; //only get alive players, probably not needed however
			{
				if !(currentWeapon _x == "Throw" || currentWeapon _x == "Put") exitWith {};
				[_x] remoteExec ["DOTT_fnc_resetWeaponState", _x];
				private _msg = format ["FIXED: %1 had silent weapon, now fixed.", name _x];
				[_msg] remoteExec ["systemChat"];
			}
			forEach _players;
		} 
	] call CBA_fnc_addEventHandler;
};

if (hasInterface) then 
{
	[
		"DOTT_round_started",
		{	
			//the player should not be invulnerable if they are not hidden (spectator or zeus option)
			if (isDamageAllowed player || isObjectHidden player) exitWith {};
			player allowDamage true;
			private _msg = format ["FIXED: %1 was invulnerable, can now take damage.", name player];
			[_msg] remoteExec ["systemChat"];
		} 
	] call CBA_fnc_addEventHandler;
};

true