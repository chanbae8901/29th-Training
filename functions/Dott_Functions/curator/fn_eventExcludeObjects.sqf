/*
 * Name:	DOTT_curator_fnc_eventExcludeObjects.sqf
 * Date:	7/27/2025
 * Version: 1.1.1
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
 * [] spawn DOTT_curator_fnc_eventExcludeObjects;
 */

if (!isServer) exitWith {};

curatorExcludedObjects = [] spawn {
	private _baseObjects = [];

	{ //forEach object placed in editor
		//get variable name in string format, if empty then skip to next object
		private _vicString = vehicleVarName _x;
		if (_vicString isEqualTo "") then { continue };
		
		//make all lower case to reduce user errors
		_vicString = toLowerANSI _vicString;
		
		//create array of tags split with an underscore (E.G. "base_action_terminal_0" becomes ["base","action","terminal","0"] )
		private _tags = _vicString splitString "_";
			
		//if the first tag isn't "base", skip object, continue to next object in array
		private _baseObject = _tags select 0;
		if (_baseObject isNotEqualTo "base") then { continue };
		_baseObjects pushBack _x;
	}
	forEach allMissionObjects "All";

	//set a flag on each object to indicate it should be excluded from Zeus editing
	{  _x setVariable ["isCuratorExcluded", true, false];  } forEach _baseObjects;

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