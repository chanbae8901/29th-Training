#define COMPONENT event
#include "script_macros.hpp"

// Use the variables below to customize your event mission
// For PvE, recommended to set 
// useRoundSystem = false
// numberOfLives = 0
// hasAliveCheck = false
// disableStatistics = false


GVAR(useRoundSystem) = true; //Use timer/ready system
//=========== Only used if useRoundSystem = true ===========
GVAR(forcedSafeStart) = 15 * 60; //Safe start time before all teams ready up in seconds
GVAR(readySafeStart) = 30; //Safe start time after all teams ready up in seconds
GVAR(timerLength) = 45 * 60; //Length of round in seconds
GVAR(timerObjects) = [
    base_timerFlagWest,
    base_timerFlagEast,
    base_timerFlagGuer
]; //Objects players can interact with to ready up their team, default colored flags in editor
GVAR(stopTimeUntilLive) = true;      //Stop time so that time at round start is the same as mission start
GVAR(hasAliveCheck) = true;          //Automatically end mission if only one side has players alive with them as the winner
                                            //NOTE: Only used if numberOfLives > 0
//====================================================
GVAR(numberOfLives) = 1;         //0 for unlimited lives
GVAR(penalizeJIPLives) = true;   //If player JIP after round has started, reduce their number of lives by 1
                                        //NOTE: Only used if numberOfLives > 0 AND useRoundSystem = true

GVAR(timeAcc) = 1;   //Time acceleration multiplier for the event (1 = normal time, 2 = 2x faster, 0.5 = half speed, etc)
                            //If useRoundSystem = true, only takes effect at start of round

GVAR(arsenalRadius) = 20;        //Radius around arsenal object where players can access the arsenal

GVAR(autoMarkObjects) = true;    //Mark static editor placed objects on map for all players

GVAR(disableStatistics) = true;  //Disable statistics tab in map diary

GVAR(endingDelay) = 10; //Delay before ending is called after hasAliveCheck/checkWinConditions conditions are met 
                        //or useRoundSystem time running out

// Win conditions
// Format: [pointsRequired, atEnd]
// pointsRequired - Number of points the side needs to win
// atEnd - If true, only check at end of timer. If false, check throughout the round.
// NOTE: atEnd = true can only be used if useRoundSystem = true
// Leave [] for no win condition for that side.
// Points can be increased/decreased by modifying the mission.sqm in editor, often by editing an object's init field.
// See examples below.
GVAR(checkWinConditions) = true; //Run win condition checks.
//=========== Only used if checkWinConditions = true ===========
GVAR(score) = [0, 0, 0];         //Starting score for each side [OPFOR, BLUFOR, GRNFOR]
GVAR(bluforWinConditions) = [];  //Conditions for BLUFOR to win the game
GVAR(opforWinConditions) = [];   //Conditions for OPFOR to win the game
GVAR(grnforWinConditions) = [];  //Conditions for GRNFOR to win the game
//==============================================================

/*
Examples
GVAR(bluforWinConditions) = []; //No win condition for BLUFOR (except only team standing if hasAliveCheck = true)
GVAR(opforWinConditions) = [3, false]; //Win when OPFOR has 3 points at any time
GVAR(grnforWinConditions) = [2, true]; //Win when GRNFOR has 2 points at the end of the timer

Put example code below in the init field of the relevant object to award points.

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
