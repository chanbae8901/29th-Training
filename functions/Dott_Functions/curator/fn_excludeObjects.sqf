/*
 * Name:	DOTT_curator_fnc_excludeObjects
 * Date:	7/27/2025
 * Version: 1.1
 * Author:  Bae [29th ID] modified from Hill [29th ID]
 *
 * Description:
 * Ensures that important mission objects are not editable by Zeus curators.
 * Loops every 3 seconds to remove editor placed objects (defined below) from curator editable list. 
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * None
 *
 * Example:
 * [] spawn DOTT_curator_fnc_excludeObjects;
 */

if (!isServer) exitWith {};

curatorExcludedObjects = [] spawn {
	private ["_ammoBoxes","_spectateTerminal","_garbage","_baseLights","_respawnPos","_zeus_modules", "_hcs", "_misc"];
	_ammoBoxes = [blu_ammo,red_ammo,grn_ammo];
	_spectateTerminal = [terminal,terminal_1,terminal_2,table,table_1,table_2];
	_garbage = [blu_garbage,red_garbage,green_garbage];
	_baseLights = [light,light_1,light_2,light_3,light_4,light_5];
	_respawnPos = [res_blu,res_red,res_grn,res_civ];
	_zeus_modules = [zeus_admin,zeus_ltc,zeus_maj,zeus_msgt,zeus_co,zeus_snco,zeus_cs,zeus_plt1_pl,zeus_plt1_ps1,zeus_plt1_ps2,zeus_plt2_pl,zeus_plt2_ps,
						zeus_red_plt,zeus_red_1_plt,
						zeus_grn_plt,zeus_grn_1_plt];
	_hcs = entities "HeadlessClient_F";
	_misc = [tfar_settings];

	//set a flag on each object to indicate it should be excluded from Zeus editing
	{
		{  _x setVariable ["isCuratorExcluded", true, false];  } forEach _x;
	} forEach [
		_ammoBoxes,
		_spectateTerminal,
		_garbage,
		_baseLights,
		_respawnPos,
		_zeus_modules,
		_hcs,
		_misc
	];

	while {true} do {
		{
			private _curator = _x;
			private _editableObjs = curatorEditableObjects _curator;
			private _objsToRemove = [];
			{
				if (!isNull _x && (_x getVariable ["isCuratorExcluded", false])) then {
					_objsToRemove pushBack _x;
				};
			} forEach _editableObjs;	

			if (count _objsToRemove > 0) then {
				_curator removeCuratorEditableObjects [_objsToRemove, true];
			};			
		} forEach allCurators;
		sleep 3;
	};
};