/*
 * Name:	fnc_sendAll
 * Date:	8/26/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Function intended to be remoteexec from client to server 
 * that sends all previous rounds to client.
 *
 * Parameter(s): 
 * _player (Object): Object local to client that should receive info
 *
 * Returns:
 * true
 *
 * Example:
 * 	  [player] remoteExec ["DOTT_tracker_fnc_sendAll", 2]; //from client
 * 
 */

params["_player"];

private _numRounds = count DOTT_tracker_previous;

for "_i" from 0 to (_numRounds - 1) do {
	private _roundInfo = DOTT_tracker_previous select _i;
	private _events = _roundInfo select 0;
	private _names = _roundInfo select 1;
	private _sides = _roundInfo select 2;
	private _weapons = _roundInfo select 3;
	private _numRound = _i + 1;
	[
		_events, _names, _sides, _weapons, _numRound
	] remoteExec ["DOTT_tracker_fnc_createDiaryEntries", _player];	
};

true


