{
	[_x,[-1,-2,0]] call BIS_fnc_setCuratorVisionModes; // -2 = NV, -1 = normal, 3rd number is TI see https://community.bistudio.com/wiki/setCamUseTi
//	if (isServer) then {_x call BIS_fnc_drawCuratorLocations;}; // add location names to curators UI
//	[_x,[WEST,EAST,INDEPENDENT,CIVILIAN]] call BIS_fnc_drawCuratorRespawnMarkers;
} forEach allCurators;

{
  curatorEnteredLog = _x addEventHandler ["CuratorObjectRegistered", 
  {
    params ["_curator"];
    private _curatorObj = getAssignedCuratorUnit _curator;
    private _curatorName = name _curatorObj;
    private _msg = format ["CURATOR INTERFACE OPENED: %1", _curatorName];
    _msg remoteExec ["DOTT_fnc_diag_log",2];
  }];
} forEach allCurators;