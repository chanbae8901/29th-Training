params ["_logic", "_owner"];

private _oldAreaMarkers = _logic getVariable ["DOTT_areaMarkers", []];

[_oldAreaMarkers] spawn //due to new marker creation below being delayed by 2 seconds by OCAP for whatever reason, we delay deletion by 2 seconds to make transition more seamless
{
    params ["_oldAreaMarkers"];

    sleep 2;

    {
        deleteMarkerLocal _x;
    }
    forEach _oldAreaMarkers;
};

private _newMarkers = [];

private _areas = _logic getVariable ["areas", []];

private _markerColor = "colorgrey";
if (_owner != sideUnknown) then 
{
    _markerColor = [_owner, true] call bis_fnc_sidecolor;
};

{
    private _trigger = _x;
    private _markerName = "DOTT_ocap_sectorArea" + str _trigger + str time; //make sure new marker name doesn't match old via time
    private _marker = createMarkerLocal [_markerName, position _trigger];

    private _triggerArea = triggerarea _trigger;
    if (_triggerArea select 3) then {_marker setMarkerShapeLocal "rectangle";} else {_marker setMarkerShapeLocal "ellipse";};
    _marker setMarkerDirLocal (_triggerArea select 2);
    _marker setMarkerSizeLocal [(_triggerArea select 0),(_triggerArea select 1)]; 
    _marker setMarkerBrushLocal "Border";
    _marker setMarkerAlphaLocal 1;

    _marker setMarkerColorLocal _markerColor;

    _newMarkers pushBack _marker;
}
forEach _areas;

_logic setVariable ["DOTT_areaMarkers", _newMarkers];

//also change color of middle icon by recreating
private _oldTextMarker = _logic getVariable ["DOTT_nameMarker", ""];

[_oldTextMarker] spawn //due to new marker creation below being delayed by 2 seconds by OCAP for whatever reason, we delay deletion by 2 seconds to make transition more seamless
{
    params ["_oldTextMarker"];

    sleep 2;
    deleteMarkerLocal _oldTextMarker;
};

private _sectorName = _logic getVariable ["name", ""];

private _markerIconText = createmarkerlocal ["DOTT_ocap_iconText" + str _logic + str time, position _logic];
_markerIconText setmarkertypelocal "hd_objective";
_markerIconText setmarkercolorlocal _markerColor;
_markerIconText setmarkertextlocal _sectorName;
_markerIconText setmarkersizelocal [.5,.5];
_markerIconText setmarkeralphalocal 1;

_logic setVariable ["DOTT_nameMarker", _markerIconText];