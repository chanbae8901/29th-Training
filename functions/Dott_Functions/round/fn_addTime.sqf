/*
 * Name:	fnc_addTime
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Adds time to currently running round. Cannot be used to add time to a round that is not active.
 * Notifies players about amount of time change.
 *
 * Parameter(s): 
 * _timeDelta (Number): Time in seconds to change the round time by. Can be negative to reduce time.
 *
 * Returns:
 * -1 if round not active, otherwise returns the new time left.
 *
 * Example:
 * [420] call DOTT_round_fnc_addTime;
 * 
 */

params["_timeDelta"];
if !(call DOTT_round_fnc_isRoundActive) exitWith {-1};
private _timeLeft = call DOTT_round_fnc_getTime;
[_timeDelta + _timeLeft] call BIS_fnc_countdown;
DOTT_round_timeAdded = true; //for roundEvents
publicVariable "DOTT_round_timeAdded";
format ["Added %1 minutes to the time limit!", _timeDelta/60] remoteExec ["hint"];
call DOTT_round_fnc_getTime