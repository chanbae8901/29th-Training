// By Dott [29th ID]
// Script checks which sides are occupied, which sides are ready, and starts a timer if conditions are met, defined by "timerLength"
// Ready status and timerLength defined in fn_init

params["_side", "_isReady"];

if (call DOTT_round_fnc_isRoundActive) exitWith {false};
private _readyStr = "";
switch (_side) do
{
	case west: { bluReady = _isReady; publicVariable "bluReady"; _readyStr = "Blufor";};
	case east: { opfReady = _isReady; publicVariable "opfReady"; _readyStr = "Opfor";};
	case resistance: { grnReady = _isReady; publicVariable "grnReady"; _readyStr = "Grnfor"; };
};
if(_isReady) then
{
	_readyStr = _readyStr + " ready!";
} else {
	_readyStr = _readyStr + " not ready!";
};
_readyStr remoteExec ["hint"];

if(call DOTT_round_fnc_checkAllSidesReady) then {
	call DOTT_round_fnc_initSafeStart;
};

true