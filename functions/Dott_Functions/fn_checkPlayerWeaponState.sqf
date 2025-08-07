/*
 * Name:	fnc_checkPlayerWeaponState
 * Date:	8/5/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Check if a player's weapon state is correct to prevent one known case of silent weapon bug.
 * If weapon is incorrect, then notify all players of player name and weapon state.
 * Should be called server side, player won't desync his own weapon.
 *
 * Parameter(s): 
 * _unit (Object): The unit to check the weapon state of.
 * _autoFix (Boolean - Optional): If true, will automatically attempt to fix the weapon state by calling DOTT_fnc_fullSetUnitLoadout.
 * _msg (String - Optional): A message to broadcast to all players if unit weapon state is invalid.
 *
 * Returns:
 * true if the weapon state is correct, false otherwise.
 *
 * Example:
 * [player, "Arsenal"] call DOTT_fn_checkPlayerWeaponState;
 * 
 */

params [["_unit",objNull,[objNull]], ["_autoFix", false, [false]] ,["_msg","",[""]]];
if (!isServer) exitWith {[_unit, _autoFix, _msg] remoteExec ["DOTT_fnc_checkPlayerWeaponState", 2];	};

private _weapon = currentWeapon _unit; 

if !(_weapon in ["Throw", "Put"]) exitWith {true};

if(_autoFix) then {[_unit, "resetLoadout", true] remoteExec ["DOTT_fnc_fullSetUnitLoadout", _unit];};
if(_msg != "") then {_msg remoteExec ["systemChat", 0];};
false;


