/**
 * DOTT_ocap_fnc_startRecording
 *
 * Purpose:
 *   Starts or resumes OCAP recording. If a recording is already
 *   well underway (>10 frames), it logs a warning and exits.
 *   Otherwise it sets the recording flag, waits for the extension
 *   session to be ready, kicks off the capture loop if needed,
 *   and updates timestamps.
 *   Modified from OCAP 2 Addon for this mission's round system.
 *
 * Parameter(s): None
 * Returns: Nothing
 */

//Modified version from OCAP 2 Addon tweaked for this mission
#define OCAPEXTLOG(_args) \
    [":LOG:", _args] call ocap_extension_fnc_sendData

if (!ocap_enabled) exitWith {};

if (ocap_recorder_recording
    && ocap_recorder_captureFrameNo > 10) exitWith
{
    OCAPEXTLOG(
        ["OCAP was asked to record and is already recording!"]);

    [
        ["OCAP was asked to record", 1, [1, 1, 1, 1]],
        ["and is already recording", 1, [1, 1, 1, 1]]
    ] remoteExecCall
        ["CBA_fnc_notify", [0, -2] select isDedicated];
};

ocap_recorder_recording = true;
publicVariable "ocap_recorder_recording";

private _systemTimeFormat = ["%1-%2-%3T%4:%5:%6.%7"];
_systemTimeFormat append (systemTimeUTC apply {if (_x < 10) then {"0" + str _x} else {str _x}});
private _missionDateFormat = ["%1-%2-%3T%4:%5:00"];
_missionDateFormat append (date apply {if (_x < 10) then {"0" + str _x} else {str _x}});

[[format _missionDateFormat, format _systemTimeFormat], {
    [{!isNull player}, {
        private _t = round cba_missionTime;
        private _elapsedStr = format ["%1:%2", floor (_t / 60), [str (_t mod 60), "0" + str (_t mod 60)] select (_t mod 60 < 10)];
        player setDiarySubjectPicture [
            "OCAPInfo",
            "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa"
        ];
        player createDiaryRecord [
            "OCAPInfo",
            [
                "Status",
                format["<font color='#33FF33'>OCAP started recording.<br/>In-Mission Time Elapsed: %1<br/>Mission World Time: %2<br/>System Time UTC: %3</font>", _elapsedStr, _this#0, _this#1]
            ]
        ];
    }, _this] call CBA_fnc_waitUntilAndExecute;
}] remoteExec ["call", [0, -2] select isDedicated, true];

if (ocap_recorder_captureFrameNo == 0) then
{
    if (!ocap_extension_sessionReady) then
    {
        call ocap_extension_fnc_newMission;
        [
            {ocap_extension_sessionReady},
            {call ocap_recorder_fnc_captureLoop;},
            [],
            30,
            {
                [":LOG:", ["Timeout waiting for new mission confirmation from extension. Recording will not start."]] call ocap_extension_fnc_sendData;
                ["OCAP failed to start recording: extension did not respond", 1, [1, 0, 0, 1]] remoteExecCall ["CBA_fnc_notify", [0, -2] select isDedicated];
            }
        ] call CBA_fnc_waitUntilAndExecute;
    } else {
        call ocap_recorder_fnc_captureLoop;
    };
};

["ocap_customEvent", ["generalEvent", "Recording started."]] call CBA_fnc_serverEvent;

// Log times
[] call ocap_recorder_fnc_updateTime;
