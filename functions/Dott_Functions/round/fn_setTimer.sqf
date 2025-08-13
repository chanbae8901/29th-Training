params["_time"];
if (_time <= 0 || call DOTT_round_fnc_isRoundActive) exitWith {false};
timerLength = _time;
publicVariable "timerLength";
true;