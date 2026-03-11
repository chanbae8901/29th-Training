/**
 * DOTT_ocap_fnc_initClient
 *
 * Purpose:
 *   Client-side OCAP initialization. Handles JIP player
 *   registration (when autoStart is off) and sets up an ACE
 *   marker-move event handler so moved markers are tracked by
 *   OCAP with correct alpha values.
 *
 * Parameter(s):
 *   0: BOOL - Whether OCAP autoStart is enabled
 *
 * Returns: Nothing
 */

params ["_autoStart"];

if !(hasInterface) exitWith {};

//do OCAP initalization on players outside of capture loop so we can save proper marker info
if !(_autoStart) then
{
    [] spawn
    {
        waitUntil {!isNull player};

        if !(didJIP) exitWith {};

        [player] remoteExecCall
            ["DOTT_ocap_fnc_initializePlayer", 2];
    };
};

//Enable marker moves to be tracked
//Use ACE event to reduce spam to server
[
    "ace_markers_markerMoveEnded", //local event
    {
        params
            ["_player", "_marker",
            "_originalPos", "_finalPos"];

        private _isExcluded = false;

        if (!isNil
            "ocap_recorder_settings_excludeMarkerFromRecord"
        ) then
        {
            {
                if ((str _marker) find _x > -1) exitWith
                {
                    _isExcluded = true;
                };
            } forEach (parseSimpleArray
                ocap_recorder_settings_excludeMarkerFromRecord);
        };

        if (_isExcluded) exitWith {};

        private _pos = ATLToASL _finalPos;

        //force alpha to 1 due to ace moving temporarily setting it to 0.5 and the extension int forcing it to 0
        ["ocap_handleMarker",
            ["UPDATED", _marker, _player, _pos,
            "", "", "", markerDir _marker,
            "", "", 1]]
            call CBA_fnc_serverEvent;
    }
] call CBA_fnc_addEventHandler;
