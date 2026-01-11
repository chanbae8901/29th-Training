// ----- basic concat helpers -----
#define DOUBLES(a,b) a##_##b
#define TRIPLES(a,b,c) a##_##b##_##c

#define PREFIX OCAP
#define COMPONENT recorder
#define ADDON DOUBLES(PREFIX,COMPONENT)

// ----- core helpers -----
#define QUOTE(x) #x

// ----- quoted variants -----
#define QDOUBLES(a,b) QUOTE(DOUBLES(a,b))
#define QTRIPLES(a,b,c) QUOTE(TRIPLES(a,b,c))

// GVAR(x)      -> PREFIX_COMPONENT_x
#define GVAR(var1) DOUBLES(ADDON,var1)
#define EGVAR(var1,var2) TRIPLES(PREFIX,var1,var2)
// QGVAR(x)     -> "PREFIX_COMPONENT_x"
#define QGVAR(var1) QUOTE(GVAR(var1))

// GVARMAIN(x)  -> PREFIX_x
#define GVARMAINS(var1,var2) var1##_##var2
#define GVARMAIN(var1) GVARMAINS(PREFIX,var1)

// QGVARMAIN(x) -> "PREFIX_x"
#define QGVARMAIN(var1) QUOTE(GVARMAIN(var1))

// EFUNC(a,b)   -> PREFIX_a_fnc_b
#define FUNC_INNER(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)
#define EFUNC(var1,var2) FUNC_INNER(var1,var2)

// QEFUNC(a,b)  -> "PREFIX_a_fnc_b"
#define QEFUNC(var1,var2) QUOTE(EFUNC(var1,var2))

#define ARR2(a,b) [a,b]
#define ARR3(a,b,c) [a,b,c]

#define SHOULDSAVEEVENTS ((missionNamespace getVariable [QGVAR(recording), false]) && missionNamespace getVariable [QGVAR(startTime), -1] > -1)
#define SYSCHAT remoteExec ["systemChat", [0, -2] select isDedicated]
#define OCAPEXTLOG(_args) [":LOG:", _args] call EFUNC(extension,sendData)

[QGVARMAIN(handleMarker), EGVAR(listener,markers)] call CBA_fnc_removeEventHandler;
EGVAR(listener,markers) = [QGVARMAIN(handleMarker), {

  //if (SHOULDSAVEEVENTS) exitWith {};

  params["_eventType", "_mrk_name", "_mrk_owner", "_pos", "_type", "_shape", "_size", "_dir", "_brush", "_color", "_alpha", "_text", ["_forceGlobal", false], ["_creationTime", 0]];

  switch (_eventType) do {

    case "CREATED":{

      if (GVARMAIN(isDebug)) then {
        OCAPEXTLOG(ARR2("MARKERALT:CREATE: Processing marker data -- ", _mrk_name));
      };

      if (_mrk_name in GVAR(trackedMarkers)) exitWith {
        if (GVARMAIN(isDebug)) then {
          OCAPEXTLOG(ARR3("MARKERALT:CREATE: Marker", _mrk_name, "already tracked, exiting"));
        };
      };

      if (GVARMAIN(isDebug)) then {
        format["CREATE:MARKERALT: Valid CREATED process of %1, sending to extension", _mrk_name] SYSCHAT;
        OCAPEXTLOG(ARR3("CREATE:MARKERALT: Valid CREATED process of", _mrk_name, ", sending to extension"));
      };

      if (_type isEqualTo "") then {_type = "mil_dot"};
      GVAR(trackedMarkers) pushBackUnique _mrk_name;

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
        _sideOfMarker = (side _mrk_owner) call BIS_fnc_sideID;
        _mrk_owner = _mrk_owner getVariable[QGVARMAIN(id), 0];
      };

      if (_sideOfMarker isEqualTo 4 ||
      (["Projectile#", _mrk_name] call BIS_fnc_inString) ||
      (["Detonation#", _mrk_name] call BIS_fnc_inString) ||
      (["Mine#", _mrk_name] call BIS_fnc_inString) ||
      (["ObjectMarker", _mrk_name] call BIS_fnc_inString) ||
      (["moduleCoverMap", _mrk_name] call BIS_fnc_inString) ||
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

      private _captureFrameNo = GVAR(captureFrameNo);

      [":MARKER:CREATE:", [_mrk_name, _dir, _type, _text, _captureFrameNo, -1, _mrk_owner, _mrk_color, _size, _sideOfMarker, _pos, _shape, _alpha, _brush]] call EFUNC(extension,sendData);
    };

    case "UPDATED":{

      if (_mrk_name in GVAR(trackedMarkers)) then {
        if (isNil "_dir") then {_dir = 0};
        [":MARKER:MOVE:", [_mrk_name, GVAR(captureFrameNo), _pos, _dir, _alpha]] call EFUNC(extension,sendData);
      };
    };

    case "DELETED":{

      if (_mrk_name in GVAR(trackedMarkers)) then {

        if (GVARMAIN(isDebug)) then {
          format["MARKERALT:DELETE: Marker %1 at %2 frame", _mrk_name, GVAR(captureFrameNo)] SYSCHAT;
          OCAPEXTLOG(ARR3("MARKERALT:DELETE: Marker", _mrk_name, "deleted"));
        };

        [":MARKER:DELETE:", [_mrk_name, GVAR(captureFrameNo)]] call EFUNC(extension,sendData);

        GVAR(trackedMarkers) = GVAR(trackedMarkers) - [_mrk_name];
      };
    };
  };
}] call CBA_fnc_addEventHandler;