#include "defines.hpp"

/*
 * Name:	DOTT_round_fnc_init
 * Date:	03/06/2026
 * Version: 1.4
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
	DOTT_round_sideReady = [false, false, false]; 	publicVariable "DOTT_round_sideReady";
	DOTT_round_timerLength = DEFAULT_TIMER; 		publicVariable "DOTT_round_timerLength";
	DOTT_round_overtimeEnabled = false; 			publicVariable "DOTT_round_overtimeEnabled";
	DOTT_round_overtimePeriod = DEFAULT_OVERTIME; 	publicVariable "DOTT_round_overtimePeriod";
	DOTT_round_ignoreReadiness = false; 			publicVariable "DOTT_round_ignoreReadiness";

	//prevent scores showing up on right side UI
	[
		"DOTT_round_started",
		{
			{
				_x addScoreSide -SCORE_REDUCE_VALUE
			} forEach [west, east, independent];					
		} 
	] call CBA_fnc_addEventHandler;	

	[
		"DOTT_round_ended",
		{
			{
				_x addScoreSide SCORE_REDUCE_VALUE
			} forEach [west, east, independent];						
		} 
	] call CBA_fnc_addEventHandler;	
};

if (hasInterface) then
{
	call DOTT_round_fnc_initReadyUI;

	//For JIP players
	//showScoreTable silently fails if called too early
	addMissionEventHandler ["PreloadFinished", {
		if (call DOTT_round_fnc_isRoundActive && TN_disableScoreboard) then {
			showScoreTable 0;
		};
		removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
	}];

	//prevent scoreboard in respawn menu (hacky)
	["DOTT_round_scoreboardRespawnMenuStart", "Killed", 		
		{		
			disableRespawnScoreboard = addMissionEventHandler 
			[
				"Draw2D", 
				{
					if(visibleScoretable && call DOTT_round_fnc_isRoundActive && TN_disableScoreboard) then { showScoretable 0 };
				}
			];
		}
	] call CBA_fnc_addBISPlayerEventHandler;


	//needs to be readded every life
	["DOTT_round_scoreboardRespawnMenuEnd",	"Respawn",
		{
			if (call DOTT_round_fnc_isRoundActive && TN_disableScoreboard) then 
			{	
				[] spawn 
				{
					waitUntil {shownScoreTable == -1};
					showScoreTable 0;
				};
			};

			removeMissionEventHandler["Draw2D", disableRespawnScoreboard];
		}
	] call CBA_fnc_addBISPlayerEventHandler;

	//fix countdown not showing up if no sectors placed down
	[] spawn
	{
		waitUntil {!isNull (findDisplay 46)};
		("RscMPProgress" call bis_fnc_rscLayer) cutrsc ["RscMPProgress","plain"]
	};

	//fix countdown not showing up when leaving curator interface
	["DOTT_exitedZeus", {[] spawn {sleep 0.1; ("RscMPProgress" call bis_fnc_rscLayer) cutrsc ["RscMPProgress","plain"]}}] call CBA_fnc_addEventHandler;

	//allow player in zeus to see scoreboard
	["DOTT_enteredZeus", {showScoretable -1}] call CBA_fnc_addEventHandler;
	["DOTT_exitedZeus", {if (call DOTT_round_fnc_isRoundActive && TN_disableScoreboard) then { showScoretable 0 }}] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_started",
		{
			if !(TN_disableScoreboard) exitWith {};
			if !(isNull (uiNamespace getVariable ["RscDisplayCurator", displayNull])) exitWith {};
			if (!isNil { missionNamespace getVariable "BIS_EGSpectator_initialized" } && TN_limitSpectator == 0) exitWith {};
			showScoretable 0;
		} 
	] call CBA_fnc_addEventHandler;

	[
		"exitedSpectator",
		{
			if (call DOTT_round_fnc_isRoundActive && TN_disableScoreboard) then { showScoretable 0 };                            
		} 
	] call CBA_fnc_addEventHandler;

	[
		"enteredSpectator",
		{
			if (TN_limitSpectator == 0) then {showScoretable -1};                            
		} 
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_ended",
		{
			showScoretable -1;							
		} 
	] call CBA_fnc_addEventHandler;	
};

/*---------- Final Checks ---------- */
if (isServer) then 
{
	//Collect client side silent weapons and notify
	[
		"DOTT_round_started",
		{
			DOTT_round_clientSilentWeapons = nil; //if for some reason non-empty due to late response from last time

			[] spawn
			{
				sleep 3;
				if (isNil "DOTT_round_clientSilentWeapons") exitWith {};

				private _msg = format ["%1 has silent weapon.", keys DOTT_round_clientSilentWeapons];
				diag_log _msg;
				[_msg] remoteExec ["systemChat"];

				DOTT_round_clientSilentWeapons = nil;
			};
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
			if (TN_notifyFinalCheck) then
			{
				private _msg = format ["FIXED: %1 was invulnerable, can now take damage.", name player];
				[_msg] remoteExec ["systemChat"];
			};
		} 
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_started",
		{	
			if !(TN_notifyFinalCheck) exitWith {};

			[] spawn
			{
				sleep 0.5;
				private _players = allPlayers - entities "HeadlessClient_F";
				_players = _players select { alive _x }; //only get alive players, probably not needed however
				
				{
					if !(currentWeapon _x == "Throw" || currentWeapon _x == "Put") then { continue };
					[name _x, name player] remoteExecCall ["DOTT_round_fnc_collectSilentWeapons", 2];
				}
				forEach _players;
			};				
		} 
	] call CBA_fnc_addEventHandler;
};

true