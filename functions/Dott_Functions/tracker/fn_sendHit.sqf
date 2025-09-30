/*
 * Name:	DOTT_tracker_fnc_sendHit
 * Date:	9/25/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Stores last hit of each player on a unit, as well as the last hit overall.
 *
 * Parameter(s): 
 * _unit: Object to set hit info on
 * _hitInfo: Information about the hit - see fn_addEventHandlersClient and fn_hit
 *
 * Returns:
 * Nothing
 *
 * Example:
 * [_hitEntity, _lastHit] remoteExecCall ["DOTT_tracker_fnc_sendHit", 2];
 * 
 */

params ["_unit", "_instigatorInfo"];

private _key = [_instigatorInfo select 0, _instigatorInfo select 1]; //name, side
private _value = [_instigatorInfo select 2, _instigatorInfo select 3, _instigatorInfo select 4]; //firing pos, weapon, time

private _hitMap = _unit getVariable ["DOTT_hitMap", createHashMap];
_hitMap set [_key, _value];

_unit setVariable ["DOTT_lastHit", _key];
_unit setVariable ["DOTT_hitMap", _hitMap];