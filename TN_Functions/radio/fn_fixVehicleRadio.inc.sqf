// Fix bug entering a unentered vehicle with different faction
// backpack lr set causes vehicle to have wrong side encryption
// LR, or force vehicle radio to be of same side as player.

private _radios = player call TFAR_fnc_vehicleLr;
if (isNil "_radios") exitWith {};
private _vehicle = _radios select 0;

private _vehicleSide = _vehicle call TFAR_fnc_getVehicleSide;

private _correctSide = switch (GVARMAIN(forceSideLRVic)) do {
    case true: { side group player };
    case false: { _vehicleSide };
};

private _encryptionCode = "";
switch (_correctSide) do {
    case west: {
        _encryptionCode = "tf_west_radio_code";
    };
    case east: {
        _encryptionCode = "tf_east_radio_code";
    };
    default {
        _encryptionCode = "tf_independent_radio_code";
    };
};

_encryptionCode = missionNamespace getVariable [
    _encryptionCode, ""
];

[_radios, _encryptionCode] call TFAR_fnc_setLrRadioCode;

if (GVARMAIN(forceSideLRVic) && {_correctSide isNotEqualTo _vehicleSide}) then {
    systemChat "Vehicle LR radio set to your side's encryption.";
};
