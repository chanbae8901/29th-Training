/**
 * Function: TN_event_fnc_markEditorPlacedObjects
 * Author:   Mallen [FNF], modified by Bae [29th ID]
 *
 * Creates local map markers for editor-placed static objects
 * and cargo containers that are large enough to be tactically
 * relevant. Objects can opt in/out via object variables.
 *
 * Originally by Mallen [FNF], modified by Bae [29th ID].
 * https://github.com/FridayNightFight/FNF (BSD-3-Clause)
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 */

//anything that is a subtype of these classes and is
//big enough will be marked
_baseClasses = ["Static", "Cargo_base_F"];

//checks bounding sphere value to see if object is
//large enough, not in the blacklist, and not in an
//excluded start zone
_canMark =
{
    params ["_obj"];

    if (_obj getVariable
        ["TN_autoMarkForceInclude", false]) exitWith
    {
        true;
    };

    _classBlacklist = [
        "Land_DataTerminal_01_F",
        "Wreck_Base",
        "FlagCarrierCore",
        "Base_CUP_Plant"
    ];

    if (_obj getVariable
        ["TN_autoMarkExclude", false]) exitWith
    {
        false;
    };

    _size = (boundingBox _obj) select 2;

    _size > 1.5
    && {
        {
            if (_obj isKindOf _x) exitWith { false };
            true
        } forEach _classBlacklist
    }
};

//get buildings to create markers for - only include
//objects large enough
_objectsToMark = [];
{
    _objectsToMark append allMissionObjects _x;
} forEach _baseClasses;
_objectsToMark = _objectsToMark select { _x call _canMark };

_createMarker =
{
    params ["_obj", "_markerNum"];

    // Create marker locally to save network bandwidth
    _marker = createMarkerLocal [
        "TN_ObjectMarker" + str _markerNum,
        _obj
    ];

    _marker setMarkerShapeLocal "Rectangle";
    _marker setMarkerBrushLocal "SolidFull";
    _marker setMarkerColorLocal "ColorBlack";
    _marker setMarkerDirLocal getDir _obj;

    _bbr = boundingBoxReal _obj;
    _p1 = _bbr select 0;
    _p2 = _bbr select 1;
    _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
    _maxLength = abs ((_p2 select 1) - (_p1 select 1));

    _marker setMarkerSizeLocal [
        _maxWidth / 2,
        _maxLength / 2
    ];
};

// Used for unique marker names
_markerNum = 0;

{
    [_x, _markerNum] call _createMarker;
    _markerNum = _markerNum + 1;
} forEach _objectsToMark;
