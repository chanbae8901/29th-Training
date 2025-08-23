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
if (!serverCommandAvailable "#lock") exitWith {}; //make time warnings admin only for the time being

private _secondsLeft = call DOTT_round_fnc_getTime; 

private _minutes = ceil(_secondsLeft / 60); 
private _actualMinutes = _secondsLeft / 60;

private _prefix = if ((_minutes - _actualMinutes) > 0.25) then {"Less than "} else {""};
private _plural = if (_minutes != 1) then {"s"} else {""};

private _message = format 
[
	"%1%2 minute%3 remaining!", 
    _prefix, 
    _minutes, 
	_plural
];

["TimeWarning", [_message]] call BIS_fnc_showNotification;



