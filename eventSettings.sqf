//Use the variables below to customize your event mission

TN_event_hasTimer = true; //Use timer/ready system
TN_event_forcedSafeStart = 15 * 60;//Safe start time before all teams ready up in seconds
TN_event_readySafeStart = 30; //Safe start time after all teams ready up in seconds
TN_event_timerLength = 45 * 60; //Length of round in seconds
TN_event_timerObjects = [
    base_timerFlagWest,
    base_timerFlagEast,
    base_timerFlagGuer
]; //Objects players can interact with to ready up their team
TN_event_endingObject = base_endFlag; //Object admin can interact with to force safestart/end mission early

TN_event_numberOfLives = 1; //0 for unlimited lives
TN_event_spectateArea = base_endFlag; //Point where players will be teleported to spectate from when out of lives.
TN_event_spectateAreaRadius = 200; //Radius around TN_event_spectateArea that is used to determine which players are spectating/lost all lives
TN_event_respawnDisarmPlayers = true; //Disarm players when they are out of lives and teleported to spectateArea

TN_event_timeAcc = 1; //Time acceleration multiplier for the event (1 = normal time, 2 = 2x faster, 0.5 = half speed, etc)

TN_event_hasAliveCheck = true; //Automatically end mission if only one side has players alive with them as the winner

TN_event_arsenalRadius = 20; //Radius around arsenal object where players can access the arsenal

TN_event_autoMarkObjects = true;

//Win conditions
//Leave "" for no win condition for that side
TN_event_score = [0, 0, 0]; //Starting score for each side [OPFOR, BLUFOR, GRNFOR]
TN_event_bluforWinConditions = ""; //Conditions for BLUFOR to win the game
TN_event_opforWinConditions = ""; //Conditions for OPFOR to win the game
TN_event_grnforWinConditions = ""; //Conditions for GRNFOR to win the game

TN_event_winCheckInterval = 3; //Interval in seconds between win condition checks
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
["TN_safeStartTime", TN_event_readySafeStart,
    nil, "server", false] call cba_settings_fnc_set;
["TN_notifyFinalCheck", false,
    nil, "server", false] call cba_settings_fnc_set;
["TN_addRadio", 0,
    nil, "server", false] call cba_settings_fnc_set;
[TN_event_timerLength] call TN_round_fnc_setTimer;
