/*
 * Name:	fnc_assignCurator
 * Date:	7/23/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Unassigns and assigns a zeus module to a unit. Meant to fix JIP Zeus not working until respawn.
 * Parameter(s): 
 * _unit: Player to reassign _module to
 * _module: Zeus module "ModuleCurator_F"
 *
 * Returns:
 * n/a
 *
 * Example:
 * [blu_co, zeus_co] call Hill_fnc_assignCurator
 */

params ["_unit","_logic"];

if (!isServer) 	exitWith 
{
	[_unit, _logic] remoteExec ["Hill_fnc_assignCurator", 2];
};

if (isNull (getAssignedCuratorLogic _unit)) then 
{
	unassignCurator _logic;
	sleep 1;
	_unit assignCurator _logic;
};