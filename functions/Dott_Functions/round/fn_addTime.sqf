//return -1 if round not active, otherwise return the new time left
params["_timeDelta"];
if !(call DOTT_round_fnc_isRoundActive) exitWith {-1};
private _timeLeft = call DOTT_round_fnc_getTime;
[_timeDelta + _timeLeft] call BIS_fnc_countdown;
format ["Added %1 minutes to the time limit!", _timeDelta/60] remoteExec ["hint"];
call DOTT_round_fnc_getTime