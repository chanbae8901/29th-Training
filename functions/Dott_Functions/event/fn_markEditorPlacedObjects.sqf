/*
	Author: Mallen [FNF] small modifications by Bae [29th ID]
	https://github.com/FridayNightFight/FNF/blob/35d5e5fdef9bebe666846ec5d7cf0ec69e6c43f4/FNF_Mission_Template.VR/Client/UI/fn_markEditorPlacedObjects.sqf

	Description:
		Marks custom placed objects on the map provided they aren't excluded

	Parameter(s):
		None

	Returns:
		None

BSD 3-Clause License

Copyright (c) 2022, Friday Night Fight
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
	 list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
	 this list of conditions and the following disclaimer in the documentation
	 and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
	 contributors may be used to endorse or promote products derived from
	 this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

_baseClasses = ["Static","Cargo_base_F"]; //anything that is a subtype of these classes and is big enough will be marked

//checks bounding sphere value to see if object is large enough, not in the blacklist, and not in an excluded start zone
_canMark = {
	params ["_obj"];
    if (_obj getVariable ["DOTT_autoMarkForceInclude", false]) exitWith {true};
	_classBlacklist = ["Land_DataTerminal_01_F","Wreck_Base","FlagCarrierCore","Base_CUP_Plant"];

	if (_obj getVariable ["DOTT_autoMarkExclude", false]) exitWith {false};
	_size = (boundingBox _x) select 2;

	_size > 1.5
	and
	{if (_obj isKindOf _x) exitWith {false}; true} forEach _classBlacklist
};

//get buildings to create markers for - only include objects large enough
_objectsToMark = [];
{_objectsToMark append allMissionObjects _x} forEach _baseClasses;
_objectsToMark = _objectsToMark select {_x call _canMark};

_createMarker = {
	params["_obj","_markerNum"];

	// Create marker locally to save network bandwidth
	_marker = createMarkerlocal ["DOTT_ObjectMarker" + str _markerNum, _obj];

	// format marker and set direction
	_marker setMarkerShapeLocal "Rectangle";
	_marker setMarkerBrushLocal "SolidFull";
	_marker setMarkerColorLocal "ColorBlack";
	_marker setMarkerDirLocal getDir _obj;

	// Grab dimensions of bounding box of the object
	_bbr = boundingBoxReal _obj;
	_p1 = _bbr select 0;
	_p2 = _bbr select 1;
	_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
	_maxLength = abs ((_p2 select 1) - (_p1 select 1));

	// set marker size to size of bounding box
	_marker setMarkersizeLocal [_maxWidth / 2, _maxLength / 2];
};

// Used for unique marker names
_markerNum = 0;

{
	[_x, _markerNum] call _createMarker;
	_markerNum = _markerNum + 1;
} forEach _objectsToMark;