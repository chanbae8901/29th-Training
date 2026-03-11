/**
 * DOTT_ocap_fnc_stopRecording
 *
 * Purpose:
 *   Stops OCAP recording by updating timestamps and clearing
 *   the recording flag. Modified from OCAP 2 Addon for this
 *   mission's round system.
 *
 * Parameter(s): None
 * Returns: Nothing
 */

//Modified version from OCAP 2 Addon tweaked for this mission
// Log times
[] call ocap_recorder_fnc_updateTime;

ocap_recorder_recording = false;
publicVariable "ocap_recorder_recording";
