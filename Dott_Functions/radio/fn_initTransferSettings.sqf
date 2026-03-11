/**
 * Function: DOTT_radio_fnc_initTransferSettings
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Sets up automatic TFAR radio settings persistence across
 *   loadout changes (arsenal, respawn). Saves SW/LR channel,
 *   stereo, volume, speaker, and frequency settings into global
 *   variables, then re-applies them when new radios are received.
 *
 *   Also corrects a TFAR bug where side encryption can be set
 *   incorrectly after a loadout swap.
 *
 *   Adapted from gruppe-adler/Shoot_and_Scoot.Tanoa.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   Nothing
 */

// Ref: https://github.com/gruppe-adler/Shoot_and_Scoot.Tanoa/blob/4c7e5a7/scripts/tfar-persistence/functions/fn_transferRadiosAcrossRespawn.sqf

// ------------------------------------------------------------------
// Save SW settings whenever any SW radio property changes.
// ------------------------------------------------------------------
private _fn_saveSwSettings =
{
    params ["_unit"];
    // Don't fire while Zeus remote-controlling a unit.
    if (_unit != player) exitWith {};

    private _sw = call TFAR_fnc_activeSwRadio;
    if (isNil "_sw") exitWith {};

    DOTT_saved_active_sr_settings =
        _sw call TFAR_fnc_getSwSettings;
};

// ------------------------------------------------------------------
// Save LR settings whenever any LR radio property changes.
// ------------------------------------------------------------------
private _fn_saveLrSettings =
{
    params ["_unit"];
    if (_unit != player) exitWith {};

    private _lr = player call TFAR_fnc_backpackLr;
    if (isNil "_lr") exitWith {};

    DOTT_saved_active_lr_settings =
        _lr call TFAR_fnc_getLrSettings;
};

// Register SW event listeners.
{
    [_x, _fn_saveSwSettings] call CBA_fnc_addEventHandler;
} forEach [
    "TFAR_event_OnSWchannelSet",
    "TFAR_event_OnSWstereoSet",
    "TFAR_event_OnSWvolumeSet",
    "TFAR_event_OnSWChange",
    "TFAR_event_OnSWspeakersSet"
];

// Register LR event listeners.
{
    [_x, _fn_saveLrSettings] call CBA_fnc_addEventHandler;
} forEach [
    "TFAR_event_OnLRchannelSet",
    "TFAR_event_OnLRstereoSet",
    "TFAR_event_OnLRvolumeSet",
    "TFAR_event_OnLRChange",
    "TFAR_event_OnLRspeakersSet"
];

// Frequency changes apply to either SW or LR -- check both.
[
    "TFAR_event_OnFrequencyChanged",
    {
        params ["_unit", "_radio"];
        if (_unit != player) exitWith {};

        private _sw = call TFAR_fnc_activeSwRadio;
        if (_sw isEqualTo _radio) exitWith
        {
            DOTT_saved_active_sr_settings =
                _sw call TFAR_fnc_getSwSettings;
        };

        private _lr = call TFAR_fnc_activeLrRadio;
        if (_lr isEqualTo _radio) exitWith
        {
            DOTT_saved_active_lr_settings =
                _lr call TFAR_fnc_getLrSettings;
        };
    }
] call CBA_fnc_addEventHandler;

// ------------------------------------------------------------------
// Restore SW settings and fix encryption on radio receive.
// TFAR has a bug where it sometimes assigns the wrong side's
// encryption code; we detect and correct it here.
// ------------------------------------------------------------------

// Ref: https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/878f98e/addons/core/functions/fnc_getDefaultRadioSettings.sqf#L62
#define TFAR_CODE_OFFSET 4

[
    "loadSwSettings",
    "OnRadiosReceived",
    {
        params ["_unit", "_radios"];
        if (_unit != player) exitWith {};

        {
            private _settings = DOTT_saved_active_sr_settings;
            if (isNil "_settings") then
            {
                _settings = _x call TFAR_fnc_getSwSettings;
            };

            // Resolve the correct encryption code for this radio.
            private _correctCode = [
                _x, "tf_encryptionCode", ""
            ] call TFAR_fnc_getWeaponConfigProperty;

            // Legacy alias -- may no longer be needed.
            if (_correctCode == "tf_guer_radio_code") then
            {
                _correctCode = "tf_independent_radio_code";
            };
            _correctCode = missionNamespace getVariable [
                _correctCode, ""
            ];

            private _currentCode =
                _x call TFAR_fnc_getSwRadioCode;

            if (_currentCode != _correctCode) then
            {
                _settings set [TFAR_CODE_OFFSET, _correctCode];
            };

            [_x, _settings] call TFAR_fnc_setSwSettings;
        } forEach _radios;
    }
] call TFAR_fnc_addEventHandler;

// ------------------------------------------------------------------
// Restore LR settings and fix encryption on loadout change.
// ------------------------------------------------------------------
[
    "loadout",
    {
        private _lr = player call TFAR_fnc_backpackLr;
        if (isNil "_lr") exitWith {};

        private _settings = DOTT_saved_active_lr_settings;
        if (isNil "_settings") then
        {
            _settings = _lr call TFAR_fnc_getLrSettings;
        };

        // Resolve the correct encryption code for this radio.
        private _correctCode = [
            typeOf (_lr select 0),
            "tf_encryptionCode", ""
        ] call TFAR_fnc_getVehicleConfigProperty;

        // Legacy alias -- may no longer be needed.
        if (_correctCode == "tf_guer_radio_code") then
        {
            _correctCode = "tf_independent_radio_code";
        };
        _correctCode = missionNamespace getVariable [
            _correctCode, ""
        ];

        private _currentCode = _lr call TFAR_fnc_getLrRadioCode;

        if (_currentCode != _correctCode) then
        {
            _settings set [TFAR_CODE_OFFSET, _correctCode];
        };

        [_lr, _settings] call TFAR_fnc_setLrSettings;
    }
] call CBA_fnc_addPlayerEventHandler;

// ------------------------------------------------------------------
// Fix vehicle LR encryption on entering or switching seats.
// ------------------------------------------------------------------
private _fn_fixVehicleRadio =
{
    #include "fn_fixVehicleRadio.inc.sqf"
};

[
    "DOTT_getInVicRadio",
    "GetInMan",
    _fn_fixVehicleRadio
] call CBA_fnc_addBISPlayerEventHandler;

[
    "DOTT_seatSwitchVicRadio",
    "SeatSwitchedMan",
    _fn_fixVehicleRadio
] call CBA_fnc_addBISPlayerEventHandler;
