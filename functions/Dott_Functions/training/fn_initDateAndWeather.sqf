/*
 * Name:	DOTT_training_fnc_initDateAndWeather
 * Date:	7/24/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Sets date, overcast, and fog settings on server, which is automatically synched with clients by the game.
 * Small exception with the year if it is changed mid-session, which is not automatically synched.
 * Should only be run on server.
 * Parameter(s) (All Optional): 
 * _forcedDate (Array): Array of format Date https://community.bistudio.com/wiki/Date
 * _forcedOvercast (Number): in range 0..1
 * _forcedFog: fog: Number(fog density or [fogValue, fogDecay, fogBase] 
 *                  reference https://community.bistudio.com/wiki/setFog
 *
 * Returns:
 * n/a
 *
 * Example:
 * private _forcedDate     = [2018, 3, 30, 12, 0]; 
 *  private _forcedOvercast = 0.1;
 * private _forcedFog      = [0.1, 0.01, 0];
 * [_forcedDate, _forcedOvercast, _forcedFog] call DOTT_training_fnc_initDateAndWeather;
 * 
 */

if (!isServer) exitWith {};
params["_forcedDate", "_forcedOvercast", "_forcedFog"];

setDate _forcedDate;
0 setOvercast _forcedOvercast;
0 setFog _forcedFog;

forceWeatherChange;

diag_log format ["Server Set Weather: date=%1, overcast=%2, fog=%3", date, overcast, fogParams];
