/*
 * Name:	DOTT_radio_fnc_initTransferSettings
 * Date:	12/24/2025
 * Version: 1.2
 * Author:  Bae [29th ID]
 *
 * Description:
 * Sets up automatic radio settings transfer when loadouts are switched such as arsenal or respawn.
 * Fixes some bugs related to TFAR encryption.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * Nothing
 *
 * Example:
 * call DOTT_radio_fnc_initTransferSettings;
 * 
 */

//modification from https://github.com/gruppe-adler/Shoot_and_Scoot.Tanoa/blob/4c7e5a7187c199d216228832329803c5c79543e8/scripts/tfar-persistence/functions/fn_transferRadiosAcrossRespawn.sqf
if (hasInterface) then {
	private _fn_saveSwSettings = 
	{
		params ["_unit"];
		if (_unit != player) exitWith {}; //don't do in remote control case		
		private _sw = call TFAR_fnc_activeSwRadio;
		if (isNil "_sw") exitWith {};
		DOTT_saved_active_sr_settings = _sw call TFAR_fnc_getSwSettings;
	};

	private _fn_saveLrSettings = 
	{
		params ["_unit"];
		if (_unit != player) exitWith {}; 	
		private _lr = player call TFAR_fnc_backpackLr;
		if (isNil "_lr") exitWith {};
		DOTT_saved_active_lr_settings = _lr call TFAR_fnc_getLrSettings;
	};

	{[_x, _fn_saveSwSettings] call CBA_fnc_addEventHandler} forEach [
		"TFAR_event_OnSWchannelSet",
		"TFAR_event_OnSWstereoSet",
		"TFAR_event_OnSWvolumeSet",
		"TFAR_event_OnSWChange",
		"TFAR_event_OnSWspeakersSet"	
	];

	{[_x, _fn_saveLrSettings] call CBA_fnc_addEventHandler} forEach [
		"TFAR_event_OnLRchannelSet",
		"TFAR_event_OnLRstereoSet",
		"TFAR_event_OnLRvolumeSet",
		"TFAR_event_OnLRChange",
		"TFAR_event_OnLRspeakersSet"
	];

	[
		"TFAR_event_OnFrequencyChanged",
		{
			params ["_unit","_radio"];
			if (_unit != player) exitWith {};

			private _sw = call TFAR_fnc_activeSwRadio;
			if (_sw isEqualTo _radio) exitWith {
				DOTT_saved_active_sr_settings = _sw call TFAR_fnc_getSwSettings;
			};

			private _lr = call TFAR_fnc_activeLrRadio;
			if (_lr isEqualTo _radio) exitWith {
				DOTT_saved_active_lr_settings = _lr call TFAR_fnc_getLrSettings;
			};
		}
	] call CBA_fnc_addEventHandler;

	/* Also check if after radio settings configured by TFAR that side encryption is correct, as even though we need to check anyway due to code in this file,
	TFAR has a bug that it will set the wrong side in certain conditions regardless. */

	//Code in event handler referenced from
	//https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/878f98e67496ccd278f39b9bd7c092fe9b7be449/addons/core/functions/fnc_getDefaultRadioSettings.sqf#L62
	#define TFAR_CODE_OFFSET 4

	[
		"loadSwSettings",
		"OnRadiosReceived",
		{
			params ["_unit","_radios"];
			if (_unit != player) exitWith {}; 

			{
				private _settings = DOTT_saved_active_sr_settings;
				if (isNil "_settings") then { _settings = _x call TFAR_fnc_getSwSettings };

				private _correctCode = [_x, "tf_encryptionCode", ""] call TFAR_fnc_getWeaponConfigProperty;
				if (_correctCode == "tf_guer_radio_code") then {_correctCode = "tf_independent_radio_code"}; //doesn't look like its needed anymore 
				_correctCode = missionNamespace getVariable [_correctCode, ""];

				private _currentCode = _x call TFAR_fnc_getSwRadioCode; //OnRadiosReceived for Sw radios only
				if (_currentCode != _correctCode) then 
				{
					_settings set [TFAR_CODE_OFFSET, _correctCode];
				};

				[_x, _settings] call TFAR_fnc_setSwSettings;
			} forEach _radios;
		}
	] call TFAR_fnc_addEventHandler;

	["loadout", 
	{
		private _lr = player call TFAR_fnc_backpackLr;
		if (isNil "_lr") exitWith {};

		private _settings = DOTT_saved_active_lr_settings;
		if (isNil "_settings") then { _settings = _lr call TFAR_fnc_getLrSettings };

		private _correctCode = [typeOf (_lr select 0), "tf_encryptionCode", ""] call TFAR_fnc_getVehicleConfigProperty;
		if (_correctCode == "tf_guer_radio_code") then {_correctCode = "tf_independent_radio_code"}; //doesn't look like its needed anymore 
		_correctCode = missionNamespace getVariable [_correctCode, ""];

		private _currentCode = _lr call TFAR_fnc_getLrRadioCode;
		if (_currentCode != _correctCode) then 
		{
			_settings set [TFAR_CODE_OFFSET, _correctCode];
		};

		[_lr, _settings] call TFAR_fnc_setLrSettings;
	}] call CBA_fnc_addPlayerEventHandler;

	private _fn_fixVehicleRadio = 
	{
		#include "fn_fixVehicleRadio.inc.sqf"
	};
	["DOTT_getInVicRadio", "GetInMan", _fn_fixVehicleRadio] call CBA_fnc_addBISPlayerEventHandler;
	["DOTT_seatSwitchVicRadio", "SeatSwitchedMan", _fn_fixVehicleRadio] call CBA_fnc_addBISPlayerEventHandler;	
};