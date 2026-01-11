//Modified version from OCAP 2 Addon tweaked for this mission
// disregard recording attempts while OCAP is disabled.
#define OCAPEXTLOG(_args) [":LOG:", _args] call ocap_extension_fnc_sendData

if (!ocap_enabled) exitWith {};

// if recording started earlier and startTime has been noted, only restart the capture loop with any updated settings.
if (ocap_recorder_recording && ocap_recorder_captureFrameNo > 10) exitWith {
  OCAPEXTLOG(["OCAP was asked to record and is already recording!"]);
  [
    ["OCAP was asked to record", 1, [1, 1, 1, 1]],
    ["and is already recording", 1, [1, 1, 1, 1]]
  ] remoteExecCall ["CBA_fnc_notify", [0, -2] select isDedicated];
};

ocap_recorder_recording = true;
publicVariable "ocap_recorder_recording";

if (ocap_recorder_captureFrameNo == 0) then {
  call ocap_recorder_fnc_captureLoop;
};

// Log times
[] call ocap_recorder_fnc_updateTime;