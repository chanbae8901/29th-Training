/*
 * Name:	fnc_setOvertimePeriod
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Setter function for overtime period.
 *
 * Parameter(s): 
 * _time (Number) - value to set overtime period in seconds
 *
 * Returns:
 * true
 *
 * Example:
 * [500] call DOTT_round_fnc_setOvertimePeriod;
 * 
 */

params["_time"];
if (_time <= 0) exitWith {false};
overtimePeriod = _time;
publicVariable "overtimePeriod";
true;