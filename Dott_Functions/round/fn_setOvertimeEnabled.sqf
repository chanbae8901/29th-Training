/*
 * Name:	DOTT_round_fnc_setOvertimeEnabled
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Setter function for overtime enabled.
 *
 * Parameter(s): 
 * _enabled (Boolean) - value to set overtime enabled state
 *
 * Returns:
 * true
 *
 * Example:
 * [true] call DOTT_round_fnc_setOvertimeEnabled;
 * 
 */

params["_enabled"];
DOTT_round_overtimeEnabled = _enabled;
publicVariable "DOTT_round_overtimeEnabled";
true;