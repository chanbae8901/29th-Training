params ["_logic"];

//log sector capture in events + replace area color on map
[_logic, "ownerChanged", 
{
    params ["_sector", "_owner", "_ownerOld"];
    private _sectorName = _sector getVariable ["name", "sector"];
    private _ownerName = _owner call BIS_fnc_sideName;
    ["ocap_customEvent", ["generalEvent", format["%1 captured by %2", _sectorName, _ownerName]]] call CBA_fnc_serverEvent;

    [_sector, _owner] call DOTT_ocap_fnc_changeSectorSideMarker;
}] call BIS_fnc_addScriptedEventHandler;

//create area color and name on map on creation
[_logic] spawn
{
    params ["_logic"];

    sleep 0.5; //wait for owner/name to be assigned, maybe not needed

    private _owner = _logic getVariable ["owner", sideUnknown];
    [_logic, _owner] call DOTT_ocap_fnc_changeSectorSideMarker;

    private _sectorName = _logic getVariable ["name", ""];

    private _markerIconText = createmarkerlocal ["DOTT_ocap_iconText" + str _logic, position _logic];
    _markerIconText setmarkertypelocal "loc_Attack";
    _markerIconText setmarkercolorlocal "colorblack";
    _markerIconText setmarkertextlocal _sectorName;
    _markerIconText setmarkersizelocal [.5,.5];
    _markerIconText setmarkeralphalocal 1;

    _logic setVariable ["DOTT_nameMarker", _markerIconText];
};

_logic addEventHandler ["Deleted", 
    {
        params ["_entity"];
        private _areaMarkers = _entity getVariable ["DOTT_areaMarkers", []];

        {
            deleteMarkerLocal _x;
        }
        forEach _areaMarkers;

        deleteMarkerLocal (_entity getVariable ["DOTT_nameMarker", ""]);
    }
];