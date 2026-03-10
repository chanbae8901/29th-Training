//Use the variables below to customize your event mission

DOTT_event_hasTimer = true; //Use timer/ready system
DOTT_event_safeStart = 10 * 60; //Safe start time after all teams ready up in seconds
DOTT_event_timerLength = 45 * 60; //Length of round in seconds
DOTT_event_timerObjects = [
    base_timerFlagWest,
    base_timerFlagEast,
    base_timerFlagGuer
]; //Objects players can interact with to ready up their team
DOTT_event_endingObject = base_endFlag; //Object admin can interact with to force safestart/end mission early

DOTT_event_numberOfLives = 1; //0 for unlimited lives
DOTT_event_spectateArea = base_endFlag; //Point where players will be teleported to spectate from when out of lives.
DOTT_event_spectateAreaRadius = 200; //Radius around DOTT_event_spectateArea that is used to determine which players are spectating/lost all lives
DOTT_event_respawnDisarmPlayers = true; //Disarm players when they are out of lives and teleported to spectateArea

DOTT_event_timeAcc = 1; //Time acceleration multiplier for the event (1 = normal time, 2 = 2x faster, 0.5 = half speed, etc)

DOTT_event_hasAliveCheck = true; //Automatically end mission if only one side has players alive with them as the winner

DOTT_event_arsenalRadius = 20; //Radius around arsenal object where players can access the arsenal

DOTT_event_autoMarkObjects = true;

//Win conditions
//Leave "" for no win condition for that side
DOTT_event_score = [0, 0, 0]; //Starting score for each side [OPFOR, BLUFOR, GRNFOR]
DOTT_event_bluforWinConditions = ""; //Conditions for BLUFOR to win the game
DOTT_event_opforWinConditions = ""; //Conditions for OPFOR to win the game
DOTT_event_grnforWinConditions = ""; //Conditions for GRNFOR to win the game

DOTT_event_winCheckInterval = 3; //Interval in seconds between win condition checks
/*
Examples
DOTT_event_bluforWinConditions = ""; //No win condition for BLUFOR (except only team standing at end if hasAliveCheck = true)
DOTT_event_opforWinConditions = ["Points", 3, false]; //Win when OPFOR has 3 points at any time
DOTT_event_grnforWinConditions = ["Points", 2, true]; //Win when GRNFOR has 2 points at the end of the timer

Available Win Condition Functions:
    "Points"
        Win when team has a certain number of points
        These points can be increased or decreased by modifying the mission.sqm in editor, often by editing an object's init field.
        Put example code below in the init field of the relevant object

        Sector Example (gives _pointValue points to whoever is currently holding the sector):

        if !(isServer) exitWith {};
        private _pointValue = 1;
        this setVariable ["DOTT_pointValue", _pointValue];

        Kill/Destroy Example (gives _pointValue points to _awardTeam (in example BLUFOR) when object is killed/destroyed):

        if !(isServer) exitWith {};
        private _pointValue = 1;
        private _awardTeam = west;

        this setVariable ["DOTT_pointValue", _pointValue];
        this setVariable ["DOTT_awardTeam", _awardTeam];

    NOTE: If multiple teams meet their win conditions at the same time, the tiebreaker will be OPFOR, BLUFOR, then GRNFOR.
    Win conditions should be designed to avoid this where possible.
*/

/*** Do Not Edit Anything Below This Line ***/
["TN_safeStartTime", DOTT_event_safeStart,
    nil, "server", false] call cba_settings_fnc_set;
["TN_notifyFinalCheck", false,
    nil, "server", false] call cba_settings_fnc_set;
["TN_addRadio", 0,
    nil, "server", false] call cba_settings_fnc_set;
[DOTT_event_timerLength] call DOTT_round_fnc_setTimer;
