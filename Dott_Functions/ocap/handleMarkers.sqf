/**
 * Function: TN_ocap_fnc_init
 * Author:   OCAP Addon very slightly modified by Bae [29th ID]
 *
 * Purpose:
 *   Overwrite default event handler in OCAP Addon to support
 *   pausing and resuming recording. Makes sure marker times
 *   are saved properly.
 *
 * Hardcoded Paths:
 *
 * Parameter(s): None
 * Returns: Nothing
 *
 * Example:
 *   call compile preprocessFileLineNumbers "TN_Functions\ocap\handleMarkers.sqf"
 */

ocap_listener_markers = ["ocap_handleMarker", {

  if !(ocap_recorder_recording && {ocap_recorder_startTime > -1}) exitWith {};

  params["_eventType", "_mrk_name", "_mrk_owner", "_pos", "_type", "_shape", "_size", "_dir", "_brush", "_color", "_alpha", "_text", ["_forceGlobal", false], ["_creationTime", 0]];

  switch (_eventType) do {

    case "CREATED":{

      if (ocap_isDebug) then {
        "ocap" callExtension (":LOG:" + str ["MARKER:CREATE: Processing marker data -- ",_mrk_name]);
      };

      if (_mrk_name in ocap_recorder_trackedMarkers) exitWith {
        if (ocap_isDebug) then {
          "ocap" callExtension (":LOG:" + str ["MARKER:CREATE: Marker",_mrk_name,"already tracked, exiting"]);
        };
      };

      if (ocap_isDebug) then {
        format["CREATE:MARKER: Valid CREATED process of %1, sending to extension", _mrk_name] call {systemChat _this};
        "ocap" callExtension (":LOG:" + str ["CREATE:MARKER: Valid CREATED process of",_mrk_name,", sending to extension"]);
      };

      if (_type isEqualTo "") then {_type = "mil_dot"};
      ocap_recorder_trackedMarkers pushBackUnique _mrk_name;

      private _mrk_color = "";
      if (_color == "Default") then {
        _mrk_color = (configfile >> "CfgMarkers" >> _type >> "color") call BIS_fnc_colorConfigToRGBA call bis_fnc_colorRGBtoHTML;
      } else {
        _mrk_color = (configfile >> "CfgMarkerColors" >> _color >> "color") call BIS_fnc_colorConfigToRGBA call bis_fnc_colorRGBtoHTML;
      };

      private ["_sideOfMarker"];
      if (_mrk_owner isEqualTo objNull) then {
        _forceGlobal = true;
        _mrk_owner = -1;
        _sideOfMarker = -1;
      } else {
        _sideOfMarker = str side _mrk_owner;
        _mrk_owner = _mrk_owner getVariable["ocap_id", 0];
      };

      if (_sideOfMarker in ["EMPTY", "LOGIC", "UNKNOWN"] ||
      ("Projectile#" in _mrk_name) ||
      ("Detonation#" in _mrk_name) ||
      ("Mine#" in _mrk_name) ||
      ("ObjectMarker" in _mrk_name) ||
      ("moduleCoverMap" in _mrk_name) ||
      _forceGlobal) then {_sideOfMarker = -1};

      private ["_polylinePos"];
      if (count _pos > 3) then {
        _polylinePos = [];
        for [{_i = 0}, {_i < ((count _pos) - 1)}, {_i = _i + 1}] do {
          _polylinePos pushBack [_pos # (_i), _pos # (_i + 1)];
          _i = _i + 1;
        };
        _pos = _polylinePos;
      };

      if (isNil "_dir") then {
        _dir = 0;
      } else {if (_dir isEqualTo "") then {_dir = 0}};

      private _logParams = (str [_mrk_name, _dir, _type, _text, ocap_recorder_captureFrameNo, -1, _mrk_owner, _mrk_color, _size, _sideOfMarker, _pos, _shape, _alpha, _brush]);

      [":MARKER:CREATE:", [_mrk_name, _dir, _type, _text, ocap_recorder_captureFrameNo, -1, _mrk_owner, _mrk_color, _size, _sideOfMarker, _pos, _shape, _alpha, _brush]] call ocap_extension_fnc_sendData;

      // Seed state cache for diff tracking on updates
      ocap_recorder_trackedMarkerStates set [_mrk_name, [_pos, _dir, _alpha, _text, _mrk_color, str _size, _type, _brush, _shape]];
    };

    case "UPDATED":{

      if (_mrk_name in ocap_recorder_trackedMarkers) then {
        if (isNil "_dir") then {_dir = 0};

        private _currentState = [_pos, _dir, _alpha, _text, _color, str _size, _type, _brush, _shape];
        private _lastState = ocap_recorder_trackedMarkerStates getOrDefault [_mrk_name, []];

        if (_currentState isEqualTo _lastState) exitWith {};

        ocap_recorder_trackedMarkerStates set [_mrk_name, _currentState];

        [":MARKER:STATE:", [_mrk_name, ocap_recorder_captureFrameNo, _pos, _dir, _alpha, _text, _color, str _size, _type, _brush, _shape]] call ocap_extension_fnc_sendData;
      };
    };

    case "DELETED":{

      if (_mrk_name in ocap_recorder_trackedMarkers) then {

        if (ocap_isDebug) then {
          format["MARKER:DELETE: Marker %1", _mrk_name] call {systemChat _this};
          "ocap" callExtension (":LOG:" + str ["MARKER:DELETE: Marker",_mrk_name,"deleted"]);
        };

        [":MARKER:DELETE:", [_mrk_name, ocap_recorder_captureFrameNo]] call ocap_extension_fnc_sendData;
        ocap_recorder_trackedMarkers = ocap_recorder_trackedMarkers - [_mrk_name];
        ocap_recorder_trackedMarkerStates deleteAt _mrk_name;
      };
    };
  };
}] call CBA_fnc_addEventHandler;
