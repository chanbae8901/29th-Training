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

    //update markers
    while {sleep 3; !((_logic getvariable ["finalized",false]) || (isnull _logic))} do 
    {
        private _areas = _logic getVariable ["areas", []];
        private _areaMarkers = _logic getVariable ["DOTT_areaMarkers", []];
        private _moved = false;

        //if sector moves
        {
            private _trigger = _x;
            private _triggerPos = position _trigger;
            private _marker = _areaMarkers select _forEachIndex;
            if (_triggerPos distance2D (getMarkerPos _marker) > 1) then 
            {
                _marker setMarkerPosLocal _triggerPos;
                _moved = true;
            };
        }
        forEach _areas;

        if (_moved) then
        {
            _markerIconText setMarkerPosLocal position _logic;
        };

        //if sector size changes
        {
            private _trigger = _x;
            private _triggerArea = (triggerArea _trigger) select [0, 2];
            private _marker = _areaMarkers select _forEachIndex;
            private _markerArea = ((getMarkerSize _marker) select [0, 2]) apply {_x * 2}; //remultiply by two due to OCAP bug
            if (_triggerArea isNotEqualTo _markerArea) exitWith 
            {
                private _owner = _logic getVariable ["owner", sideUnknown];
                [_logic, _owner] call DOTT_ocap_fnc_changeSectorSideMarker;
            };
        }
        forEach _areas;        
    };    
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
