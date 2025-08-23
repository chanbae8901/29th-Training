/*
 * Name:	fnc_manageReady
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Changes the ready state of a side and checks if all sides are ready to start the round.
 *
 * Parameter(s): 
 * _side (Side) - what side to change ready state
 * _isReady (Boolean) - what state to set the side to
 *
 * Returns:
 * 2 if side already ready/unready, 1 if round already started, 0 otherwise
 *
 * Example:
 * [playerSide, true] call DOTT_round_fnc_manageReady;
 * 
 */
params["_side", "_isReady"];

if (call DOTT_round_fnc_isRoundActive) exitWith {1};

if ((_side == west && bluReady == _isReady) ||
    (_side == east && opfReady == _isReady) ||
    (_side == resistance && grnReady == _isReady)) exitWith { 2 };

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
} else 
{
	_readyStr = _readyStr + " not ready!";
};
_readyStr remoteExec ["hint"];

if(call DOTT_round_fnc_checkAllSidesReady) then 
{
	call DOTT_round_fnc_initSafeStart;
};

0