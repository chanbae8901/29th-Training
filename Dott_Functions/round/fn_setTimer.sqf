/*
 * Name:	DOTT_round_fnc_setTimer
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Setter function for round length. 
 * Cannot be used while the round is active. (Use addTime instead.)
 *
 * Parameter(s): 
 * _time (Number) - value to set round length in seconds
 *
 * Returns:
 * true
 *
 * Example:
 * [500] call DOTT_round_fnc_setTimer;
 * 
 */

params["_time"];
if (_time <= 0 || call DOTT_round_fnc_isRoundActive) exitWith {false};
DOTT_round_timerLength = _time;
publicVariable "DOTT_round_timerLength";
true;