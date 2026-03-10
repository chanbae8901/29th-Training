#include "defines.hpp"

/*
 * Name:	DOTT_round_fnc_manageReady
 * Date:	03/06/2026
 * Version: 1.2
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

private _sideIdx = _side call BIS_fnc_sideID;
if (_sideIdx > 2) exitWith {systemChat "Error: Invalid side to change ready state."};
private _playerSideReady = DOTT_round_sideReady select _sideIdx;
if (_playerSideReady == _isReady) exitWith { 2 };

DOTT_round_sideReady set [_sideIdx, _isReady];
publicVariable "DOTT_round_sideReady";

["DOTT_round_manageReadyChange", _this] call CBA_fnc_globalEvent;

private _readyStr = _side call BIS_fnc_sideName; //For now name of team

if (call DOTT_round_fnc_checkAllSidesReady) then 
{
	if (isNil "DOTT_round_safeStartActive") then { [] call DOTT_round_fnc_initSafeStart }
	else //we were in forced safe start and all teams are ready before the timer is up, so shorten the timer to the safe start time
	{
		if ([0] call BIS_fnc_countdown <= TN_safeStartTime) exitWith {};

		private _msgText = format [
			"<t color='#ffffff'><t size='3'>All teams ready! Shortening safe start.</t><br/><t size='2'>Live in %1!</t></t>",
			[TN_safeStartTime] call DOTT_round_fnc_formatTime
		];

		[
			_msgText,
			"PLAIN",
			0.5,
			false
		] remoteExecCall ["DOTT_common_fnc_displayMsg"];

		[TN_safeStartTime] call BIS_fnc_countdown;
	};
};

0