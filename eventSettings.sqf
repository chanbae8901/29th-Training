#include "script_macros.hpp"

//Use the variables below to customize your event mission
//For PvE, recommended to set 
// hasTimer = false
// numberOfLives = 0
// hasAliveCheck = false


EGVAR(event,hasTimer) = true; //Use timer/ready system
EGVAR(event,forcedSafeStart) = 15 * 60; //Safe start time before all teams ready up in seconds
EGVAR(event,readySafeStart) = 30; //Safe start time after all teams ready up in seconds
EGVAR(event,timerLength) = 45 * 60; //Length of round in seconds
EGVAR(event,timerObjects) = [
    base_timerFlagWest,
    base_timerFlagEast,
    base_timerFlagGuer
]; //Objects players can interact with to ready up their team, default colored flags in editor

EGVAR(event,numberOfLives) = 1; //0 for unlimited lives
EGVAR(event,spectateArea) = base_endFlag; //Point where players will be teleported to spectate from when out of lives.
EGVAR(event,spectateAreaRadius) = 200; //Radius around EGVAR(event,spectateArea) that is used to determine which players are spectating/lost all lives
EGVAR(event,respawnDisarmPlayers) = true; //Disarm players when they are out of lives and teleported to spectateArea
EGVAR(event,timeAcc) = 1; //Time acceleration multiplier for the event (1 = normal time, 2 = 2x faster, 0.5 = half speed, etc)

EGVAR(event,hasAliveCheck) = true; //Automatically end mission if only one side has players alive with them as the winner

EGVAR(event,arsenalRadius) = 20; //Radius around arsenal object where players can access the arsenal

EGVAR(event,autoMarkObjects) = true; //Mark static editor placed objects on map for all players

//Win conditions
//Leave "" for no win condition for that side
EGVAR(event,score) = [0, 0, 0]; //Starting score for each side [OPFOR, BLUFOR, GRNFOR]
EGVAR(event,bluforWinConditions) = ""; //Conditions for BLUFOR to win the game
EGVAR(event,opforWinConditions) = ""; //Conditions for OPFOR to win the game
EGVAR(event,grnforWinConditions) = ""; //Conditions for GRNFOR to win the game

EGVAR(event,winCheckInterval) = 3; //Interval in seconds between win condition checks
/*
Examples
TN_event_bluforWinConditions = ""; //No win condition for BLUFOR (except only team standing at end if hasAliveCheck = true)
TN_event_opforWinConditions = ["Points", 3, false]; //Win when OPFOR has 3 points at any time
TN_event_grnforWinConditions = ["Points", 2, true]; //Win when GRNFOR has 2 points at the end of the timer

Available Win Condition Functions:
    "Points"
        Win when team has a certain number of points
        These points can be increased or decreased by modifying the mission.sqm in editor, often by editing an object's init field.
        Put example code below in the init field of the relevant object

        Sector Example (gives _pointValue points to whoever is currently holding the sector):

        if !(isServer) exitWith {};
        private _pointValue = 1;
        this setVariable ["TN_pointValue", _pointValue];

        Kill/Destroy Example (gives _pointValue points to _awardTeam (in example BLUFOR) when object is killed/destroyed):

        if !(isServer) exitWith {};
        private _pointValue = 1;
        private _awardTeam = west;

        this setVariable ["TN_pointValue", _pointValue];
        this setVariable ["TN_awardTeam", _awardTeam];

    NOTE: If multiple teams meet their win conditions at the same time, the tiebreaker will be OPFOR, BLUFOR, then GRNFOR.
    Win conditions should be designed to avoid this where possible.
*/

/*** Do Not Edit Anything Below This Line ***/
[QGVARMAIN(safeStartTime), EGVAR(event,readySafeStart),
    nil, "server", false] call cba_settings_fnc_set;
[QGVARMAIN(notifyFinalCheck), false,
    nil, "server", false] call cba_settings_fnc_set;
[QGVARMAIN(addRadio), 0,
    nil, "server", false] call cba_settings_fnc_set;
[EGVAR(event,timerLength)] call EFUNC(round,setTimer);
