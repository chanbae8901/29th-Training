#include "defines.hpp"

/*
 * Name:	DOTT_round_fnc_manageReady
 * Date:	12/24/2025
 * Version: 1.1
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
params["_side", "_isReady", ["_showHint", true]];

if (call DOTT_round_fnc_isRoundActive) exitWith {1};

private _sideIdx = _side call BIS_fnc_sideID;
if (_sideIdx > 2) exitWith {systemChat "Error: Invalid side to change ready state."};
private _playerSideReady = DOTT_round_sideReady select _sideIdx;
if (_playerSideReady == _isReady) exitWith { 2 };

DOTT_round_sideReady set [_sideIdx, _isReady];
publicVariable "DOTT_round_sideReady";

["DOTT_round_manageReadyChange", _this] call CBA_fnc_globalEvent;

private _readyStr = _side call BIS_fnc_sideName; //For now name of team

if (_showHint) then
{
	if(_isReady) then
	{
		_readyStr = _readyStr + " ready!";
	} else 
	{
		_readyStr = _readyStr + " not ready!";
	};
	_readyStr remoteExec ["hint"];
};


if(call DOTT_round_fnc_checkAllSidesReady && isNil {DOTT_safeStartActive}) then 
{
	call DOTT_round_fnc_initSafeStart;
};

0