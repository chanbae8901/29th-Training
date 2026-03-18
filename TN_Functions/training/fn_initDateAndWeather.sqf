/*
 * Author: Bae [29th ID]
 * Sets date, overcast, and fog on the server. The engine
 * automatically syncs weather to clients. Must only run
 * on the server.
 *
 * Arguments:
 * 0: Date array [y, m, d, h, min] <ARRAY>
 * 1: Overcast level 0..1 <NUMBER>
 * 2: Fog density or [value, decay, base] <NUMBER or ARRAY>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [[2018, 3, 30, 12, 0], 0.1, [0.1, 0.01, 0]] call TN_training_fnc_initDateAndWeather;
 */

if (!isServer) exitWith {};

params ["_forcedDate", "_forcedOvercast", "_forcedFog"];

setDate _forcedDate;
0 setOvercast _forcedOvercast;
0 setFog _forcedFog;

forceWeatherChange;

diag_log text format [
    "Server Set Weather: date=%1, overcast=%2, fog=%3",
    date, overcast, fogParams
];
