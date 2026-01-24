params ["_logic", "_owner"];

private _oldMarkers = _logic getVariable ["DOTT_areaMarkers", []];

[_oldMarkers] spawn //due to new marker creation below being delayed by 2 seconds by OCAP for whatever reason, we delay deletion by 2 seconds to make transition more seamless
{
    params ["_oldMarkers"];

    sleep 2;

    {
        deleteMarkerLocal _x;
    }
    forEach _oldMarkers;
};

private _newMarkers = [];

private _areas = _logic getVariable ["areas", []];

{
    private _trigger = _x;
    private _markerName = "DOTT_ocap_sectorArea" + str _trigger + str time; //make sure new marker name doesn't match old via time
    private _marker = createMarkerLocal [_markerName, position _trigger];

    private _triggerArea = triggerarea _trigger;
    if (_triggerArea select 3) then {_marker setMarkerShapeLocal "rectangle";} else {_marker setMarkerShapeLocal "ellipse";};
    _marker setMarkerDirLocal (_triggerArea select 2);
    _marker setMarkerSizeLocal [(_triggerArea select 0)/2,(_triggerArea select 1)/2]; //we shouldn't have to divide by two, but OCAP doesn't do it properly so we do
    _marker setMarkerBrushLocal "Border";
    _marker setMarkerAlphaLocal 1;

    private _markerColor = "colorblack";
    if (_owner != sideUnknown) then 
    {
        _markerColor = [_owner, true] call bis_fnc_sidecolor;
    };

    _marker setMarkerColorLocal _markerColor;

    _newMarkers pushBack _marker;
}
forEach _areas;

_logic setVariable ["DOTT_areaMarkers", _newMarkers];
