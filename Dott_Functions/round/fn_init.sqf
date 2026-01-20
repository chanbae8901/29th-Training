/*
 * Name:	DOTT_round_fnc_init
 * Date:	12/24/2025
 * Version: 1.3
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
	DOTT_round_sideReady = [false, false, false];
	timerLength = 20*60; 
	overtimeEnabled = false; 
	overtimePeriod = 5*60; 

	publicVariable "DOTT_round_sideReady";
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
	//check if any player has the silent weapon bug on server and fix
	[
		"DOTT_round_started",
		{	
			private _players = allPlayers - entities "HeadlessClient_F";
			_players = _players select { alive _x }; //only get alive players, probably not needed however

			diag_log "Round Start Weapon States:";			
			{
				diag_log format ["%1: %2", name _x, weaponState _x];
				if !(currentWeapon _x == "Throw" || currentWeapon _x == "Put") then { continue };
				[_x] remoteExec ["DOTT_loadout_fnc_resetWeaponState", _x];
				if (TN_notifyFinalCheck) then
				{
					private _msg = format ["FIXED: %1 had silent weapon, now fixed.", name _x];
					[_msg] remoteExec ["systemChat"];
				};
			}
			forEach _players;
		} 
	] call CBA_fnc_addEventHandler;

	//Collect client side silent weapons and notify
	[
		"DOTT_round_started",
		{
			DOTT_round_clientSilentWeapons = nil; //if for some reason non-empty due to late response from last time

			[] spawn
			{
				sleep 5;
				if (isNil "DOTT_round_clientSilentWeapons") exitWith {};

				{
					private _msg = format ["%1 has silent weapon for %2", _x, _y];
					[_msg] remoteExec ["systemChat"];
				}
				forEach DOTT_round_clientSilentWeapons;

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
				sleep 2.5; //Probably temporary, wait for server side fix attempt before we check on client

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