/**
 * DOTT_ocap_fnc_stopRecording
 *
 * Purpose:
 *   Stops OCAP recording by firing a CBA server event, pushing a
 *   diary entry to clients, updating timestamps, and clearing the
 *   recording flag.
 *   Modified from OCAP 2 Addon for this mission's round system.
 *
 * Parameter(s): None
 * Returns: Nothing
 */

//Modified version from OCAP 2 Addon tweaked for this mission
private _systemTimeFormat = ["%1-%2-%3T%4:%5:%6.%7"];
_systemTimeFormat append (systemTimeUTC apply {if (_x < 10) then {"0" + str _x} else {str _x}});
private _missionDateFormat = ["%1-%2-%3T%4:%5:00"];
_missionDateFormat append (date apply {if (_x < 10) then {"0" + str _x} else {str _x}});

["ocap_customEvent", ["generalEvent", "Recording paused."]] call CBA_fnc_serverEvent;

[[cba_missionTime, format _missionDateFormat, format _systemTimeFormat], {
    [{!isNull player}, {
        player createDiaryRecord [
            "OCAPInfo",
            [
                "Status",
                format["<font color='#33FF33'>OCAP stopped recording.<br/>In-Mission Time Elapsed: %1<br/>Mission World Time: %2<br/>System Time UTC: %3</font>", _this#0, _this#1, _this#2]
            ]
        ];
        player setDiarySubjectPicture [
            "OCAPInfo",
            "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa"
        ];
    }, _this] call CBA_fnc_waitUntilAndExecute;
}] remoteExec ["call", [0, -2] select isDedicated, true];

// Log times
[] call ocap_recorder_fnc_updateTime;

ocap_recorder_recording = false;
publicVariable "ocap_recorder_recording";
