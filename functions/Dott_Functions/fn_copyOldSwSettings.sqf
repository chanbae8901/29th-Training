/*
 * Name:	DOTT_fnc_copyOldSwSettings
 * Date:	9/13/2025
 * Version:	1.0
 * Author:	Bae [29th ID]
 *
 * Description:
 * If oldSwRadioSettings missionNamespace variable is not nil and current SW Radio is a prototype 
 * (TFAR radio without the number) then wait for it to stop being a prototype and assign oldSwRadioSettings
 * to the new radio.
 *
 * Parameter(s):
 *  None
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_fnc_copyOldSwSettings
 * 
 */

private _newSwRadio = nil;
{
    if (_x call TFAR_fnc_isPrototypeRadio) exitWith {_newSwRadio = _x};
} forEach (assignedItems TFAR_currentUnit);

if (!isNil "oldSwRadioSettings" && !isNil "_newSwRadio") then
{
	[] spawn 
	{
		private _time = time;
		waitUntil { !isNil {call TFAR_fnc_activeSwRadio} || (time - _time) > 15 };
		if ((time - _time) > 15) exitWith {}; //edge case that could happen if player immediately drops radio for whatever reason
		private _newSwRadio = call TFAR_fnc_activeSwRadio;
		//only copy over radio settings with same side encryption
		if (isNil "oldSwRadioSettings") exitWith {}; //can occur in certain cases where this function is called multiple times
		if !(_newSwRadio call TFAR_fnc_getSwRadioCode == (oldSwRadioSettings select 4)) exitWith {};	
		[_newSwRadio, oldSwRadioSettings] call TFAR_fnc_setSwSettings;
		systemChat "Last known SW radio settings applied.";
	};
};
true