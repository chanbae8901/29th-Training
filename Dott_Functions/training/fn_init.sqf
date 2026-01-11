/*
 * Name:	DOTT_training_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes training variation of mission template.
 * Should be initialized after round.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_training_fnc_init;
 * 
 */

if (hasInterface) then
{
	[] spawn 
	{
		waitUntil { !isNull player };
		call DOTT_training_fnc_initBaseObjects;		
	};

	[] spawn DOTT_training_fnc_initDefaultLoadouts;
};

if (isServer) then
{
	INDEPENDENT setFriend [WEST, 0];

	//set-up default date and weather
	private _forcedDate     = [2018, 3, 30, 12, 0]; 
	private _forcedOvercast = 0.1;
	private _forcedFog      = [0.1, 0.01, 0];
	[_forcedDate, _forcedOvercast, _forcedFog] call DOTT_training_fnc_initDateAndWeather;
};
