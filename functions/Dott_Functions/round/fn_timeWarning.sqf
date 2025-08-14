/*
 * Name:	fnc_timeWarning
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Short function to display a time warning notification for compatibility with fn_roundEvents.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * None
 *
 * Example:
 * call DOTT_round_fnc_timeWarning;
 * 
 */

private _minutesLeft = round ((call DOTT_round_fnc_getTime) / 60);
["TimeWarning", [format ["%1 minutes remaining!", _minutesLeft]]] call BIS_fnc_showNotification;
